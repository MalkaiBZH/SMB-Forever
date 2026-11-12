// Mise à jour de l'addon GuildUpSMB depuis GitHub, pour le client WoW Forever.
//
// Fonctionnement :
//   1. Trouve le dossier du jeu (_forever_) : réglage enregistré, registre de Blizzard, chemins
//      habituels, sinon le demande au joueur.
//   2. Demande à l'API GitHub l'empreinte du dernier commit de la branche (en-tête
//      « Accept: application/vnd.github.sha » : la réponse est l'empreinte seule, sans JSON).
//   3. Si elle diffère de celle notée dans Interface\AddOns\GuildUpSMB\.miseajour, télécharge
//      l'archive de ce commit, en extrait le dossier GuildUpSMB/ (sans les *.bak / *.previous)
//      et synchronise le dossier installé : fichiers ajoutés, modifiés, supprimés.
//
// Arguments :
//   /auto        sans fenêtre (lancement au démarrage de Windows) ; une bulle signale une mise à jour.
//   /jeu:<dossier>  dossier du jeu imposé, non enregistré (essais).
// Variable d'environnement GUILDUPSMB_JETON : jeton GitHub facultatif (dépôt privé, essais).
//
// Réglages : %APPDATA%\GuildUpSMB-MiseAJour\reglages.ini ; journal du dernier passage : journal.txt.
// Construction : outils\MiseAJour\construire.bat (csc.exe du .NET Framework 4, fourni avec Windows).

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Win32;

[assembly: System.Reflection.AssemblyTitle("GuildUpSMB - mise à jour")]
[assembly: System.Reflection.AssemblyProduct("GuildUpSMB")]
[assembly: System.Reflection.AssemblyVersion("1.0.0.0")]

namespace GuildUpSMB
{
	// Résultat d'un passage de mise à jour.
	class Bilan
	{
		public bool DejaAJour;
		public string Version = "?";
		public int Ajoutes, Modifies, Supprimes;
	}

	static class MiseAJour
	{
		const string DEPOT = "MalkaiBZH/SMB-Forever";
		const string BRANCHE = "main";
		const string ADDON = "GuildUpSMB";
		const string MARQUE = ".miseajour";		// empreinte du commit installé, dans le dossier de l'addon
		const string CLE_DEMARRAGE = @"Software\Microsoft\Windows\CurrentVersion\Run";
		const string NOM_DEMARRAGE = "GuildUpSMB-MiseAJour";

		static readonly string DossierReglages = Path.Combine(
			Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "GuildUpSMB-MiseAJour");
		static readonly string FichierReglages = Path.Combine(DossierReglages, "reglages.ini");
		static readonly string FichierJournal = Path.Combine(DossierReglages, "journal.txt");

		// ---------------------------------------------------------------- Point d'entrée

		[STAThread]
		static int Main(string[] args)
		{
			// GitHub refuse les anciens protocoles : TLS 1.2 (3072) obligatoire.
			ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;

			bool auto = false;
			string jeuImpose = null;
			foreach (string a in args)
			{
				if (a.Equals("/auto", StringComparison.OrdinalIgnoreCase)) auto = true;
				else if (a.StartsWith("/jeu:", StringComparison.OrdinalIgnoreCase)) jeuImpose = a.Substring(5).Trim('"');
			}

			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);

			if (auto) return PassageAuto(jeuImpose);
			Application.Run(new Fenetre(jeuImpose));
			return 0;
		}

		// Lancement au démarrage de Windows : pas de fenêtre, une bulle seulement si l'addon a changé.
		static int PassageAuto(string jeuImpose)
		{
			var journal = new StringBuilder();
			Action<string> noter = delegate(string t) { journal.AppendLine(t); };
			try
			{
				string jeu = jeuImpose ?? TrouverJeu();
				if (jeu == null) { noter("Dossier du jeu introuvable : lancez le programme une fois sans /auto."); return 2; }
				Bilan b = Executer(jeu, noter);
				if (!b.DejaAJour) Bulle("GuildUpSMB mis à jour", "Version " + b.Version + " installée. Faites /reload en jeu.");
				return 0;
			}
			catch (Exception e)
			{
				noter("Erreur : " + Message(e));
				return 1;
			}
			finally
			{
				EcrireJournal(journal.ToString());
			}
		}

		static void Bulle(string titre, string texte)
		{
			using (var icone = new NotifyIcon())
			{
				icone.Icon = IconeProgramme();
				icone.Text = "GuildUpSMB";
				icone.Visible = true;
				icone.ShowBalloonTip(8000, titre, texte, ToolTipIcon.Info);
				var minuteur = new System.Windows.Forms.Timer { Interval = 9000 };
				minuteur.Tick += delegate { minuteur.Stop(); Application.ExitThread(); };
				minuteur.Start();
				Application.Run();
				icone.Visible = false;
			}
		}

		// ---------------------------------------------------------------- Mise à jour

		public static Bilan Executer(string jeu, Action<string> noter)
		{
			var bilan = new Bilan();
			string dossierAddon = Path.Combine(jeu, "Interface", "AddOns", ADDON);
			string fichierMarque = Path.Combine(dossierAddon, MARQUE);

			noter("Dossier du jeu : " + jeu);
			noter("Recherche de la dernière version sur GitHub…");
			string commit = Telecharger("https://api.github.com/repos/" + DEPOT + "/commits/" + BRANCHE,
				"application/vnd.github.sha").Trim();
			if (commit.Length < 7 || commit.Length > 64 || commit.Any(c => !Uri.IsHexDigit(c)))
				throw new Exception("réponse inattendue de GitHub.");

			string installe = File.Exists(fichierMarque) ? File.ReadAllText(fichierMarque).Trim() : "";
			if (installe == commit && File.Exists(Path.Combine(dossierAddon, ADDON + ".toc")))
			{
				bilan.DejaAJour = true;
				bilan.Version = LireVersion(dossierAddon);
				noter("L'addon est déjà à jour (version " + bilan.Version + ", commit " + commit.Substring(0, 7) + ").");
				return bilan;
			}

			string temp = Path.Combine(Path.GetTempPath(), "GuildUpSMB-MiseAJour-" + Guid.NewGuid().ToString("N"));
			Directory.CreateDirectory(temp);
			try
			{
				noter("Téléchargement du commit " + commit.Substring(0, 7) + "…");
				string archive = Path.Combine(temp, "addon.zip");
				TelechargerFichier("https://api.github.com/repos/" + DEPOT + "/zipball/" + commit, archive);

				noter("Extraction…");
				string source = Path.Combine(temp, ADDON);
				Extraire(archive, source);
				if (!File.Exists(Path.Combine(source, ADDON + ".toc")))
					throw new Exception("l'archive ne contient pas " + ADDON + "/" + ADDON + ".toc.");
				bilan.Version = LireVersion(source);

				noter("Installation de la version " + bilan.Version + "…");
				Directory.CreateDirectory(dossierAddon);
				Synchroniser(source, dossierAddon, bilan, noter);
				File.WriteAllText(fichierMarque, commit);
			}
			finally
			{
				try { Directory.Delete(temp, true); } catch { }
			}

			noter(string.Format("Terminé : {0} ajouté(s), {1} modifié(s), {2} supprimé(s).",
				bilan.Ajoutes, bilan.Modifies, bilan.Supprimes));
			noter("En jeu, faites /reload (ou relancez le jeu) pour charger la nouvelle version.");
			return bilan;
		}

		// Garde uniquement le dossier GuildUpSMB/ de l'archive (dont la racine est « depot-commit/ »).
		static void Extraire(string archive, string destination)
		{
			string racine = Path.GetFullPath(destination) + Path.DirectorySeparatorChar;
			using (ZipArchive zip = ZipFile.OpenRead(archive))
			{
				foreach (ZipArchiveEntry entree in zip.Entries)
				{
					string chemin = entree.FullName.Replace('\\', '/');
					int barre = chemin.IndexOf('/');
					if (barre < 0) continue;
					chemin = chemin.Substring(barre + 1);
					if (!chemin.StartsWith(ADDON + "/")) continue;
					chemin = chemin.Substring(ADDON.Length + 1);
					if (chemin.Length == 0 || chemin.EndsWith("/") || Ignore(chemin)) continue;

					string cible = Path.GetFullPath(Path.Combine(destination, chemin.Replace('/', Path.DirectorySeparatorChar)));
					if (!cible.StartsWith(racine, StringComparison.OrdinalIgnoreCase)) continue;	// chemin hors du dossier
					Directory.CreateDirectory(Path.GetDirectoryName(cible));
					entree.ExtractToFile(cible, true);
				}
			}
		}

		// Fichiers de travail des bannières, jamais installés.
		static bool Ignore(string chemin)
		{
			return chemin.EndsWith(".bak", StringComparison.OrdinalIgnoreCase)
				|| chemin.EndsWith(".previous", StringComparison.OrdinalIgnoreCase);
		}

		static void Synchroniser(string source, string cible, Bilan bilan, Action<string> noter)
		{
			var attendus = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			foreach (string fichier in Directory.GetFiles(source, "*", SearchOption.AllDirectories))
			{
				string relatif = fichier.Substring(source.Length + 1);
				attendus.Add(relatif);
				string destination = Path.Combine(cible, relatif);
				if (File.Exists(destination))
				{
					if (Identiques(fichier, destination)) continue;
					bilan.Modifies++;
					noter("  modifié : " + relatif);
				}
				else
				{
					bilan.Ajoutes++;
					noter("  ajouté : " + relatif);
				}
				Directory.CreateDirectory(Path.GetDirectoryName(destination));
				File.Copy(fichier, destination, true);
			}

			foreach (string fichier in Directory.GetFiles(cible, "*", SearchOption.AllDirectories))
			{
				string relatif = fichier.Substring(cible.Length + 1);
				if (attendus.Contains(relatif) || relatif.Equals(MARQUE, StringComparison.OrdinalIgnoreCase)) continue;
				File.SetAttributes(fichier, FileAttributes.Normal);
				File.Delete(fichier);
				bilan.Supprimes++;
				noter("  supprimé : " + relatif);
			}

			// Dossiers devenus vides, du plus profond au moins profond.
			foreach (string dossier in Directory.GetDirectories(cible, "*", SearchOption.AllDirectories)
				.OrderByDescending(d => d.Length))
			{
				if (!Directory.EnumerateFileSystemEntries(dossier).Any())
					try { Directory.Delete(dossier); } catch { }
			}
		}

		static bool Identiques(string a, string b)
		{
			if (new FileInfo(a).Length != new FileInfo(b).Length) return false;
			using (var sha = SHA256.Create())
			{
				byte[] ea, eb;
				using (var f = File.OpenRead(a)) ea = sha.ComputeHash(f);
				using (var f = File.OpenRead(b)) eb = sha.ComputeHash(f);
				return ea.SequenceEqual(eb);
			}
		}

		// « ## Version: 1.6.0 » dans le .toc.
		static string LireVersion(string dossierAddon)
		{
			string toc = Path.Combine(dossierAddon, ADDON + ".toc");
			if (!File.Exists(toc)) return "?";
			foreach (string ligne in File.ReadAllLines(toc))
			{
				string l = ligne.Trim();
				if (l.StartsWith("## Version:", StringComparison.OrdinalIgnoreCase)) return l.Substring(11).Trim();
			}
			return "?";
		}

		// ---------------------------------------------------------------- Réseau

		static WebClient Client(string accept)
		{
			var client = new WebClient();
			client.Headers[HttpRequestHeader.UserAgent] = "GuildUpSMB-MiseAJour";
			client.Headers[HttpRequestHeader.Accept] = accept;
			string jeton = Environment.GetEnvironmentVariable("GUILDUPSMB_JETON");
			if (!string.IsNullOrEmpty(jeton)) client.Headers[HttpRequestHeader.Authorization] = "Bearer " + jeton.Trim();
			return client;
		}

		static string Telecharger(string url, string accept)
		{
			using (WebClient client = Client(accept))
			{
				client.Encoding = Encoding.UTF8;
				return client.DownloadString(url);
			}
		}

		static void TelechargerFichier(string url, string fichier)
		{
			using (WebClient client = Client("application/vnd.github+json"))
				client.DownloadFile(url, fichier);
		}

		public static string Message(Exception e)
		{
			var w = e as WebException;
			if (w != null)
			{
				var r = w.Response as HttpWebResponse;
				if (r != null && (int)r.StatusCode == 404)
					return "dépôt " + DEPOT + " introuvable sur GitHub (est-il public ?).";
				if (r != null && (int)r.StatusCode == 403)
					return "GitHub limite les requêtes (60 par heure) : réessayez plus tard.";
				return "connexion à GitHub impossible (" + w.Message + ").";
			}
			if (e is UnauthorizedAccessException)
				return "accès refusé au dossier du jeu. Fermez le jeu ou lancez ce programme en tant qu'administrateur. (" + e.Message + ")";
			return e.Message;
		}

		// ---------------------------------------------------------------- Dossier du jeu

		// Un dossier de jeu valable contient Wow.exe (client Forever).
		public static bool JeuValable(string dossier)
		{
			return !string.IsNullOrEmpty(dossier) && File.Exists(Path.Combine(dossier, "Wow.exe"));
		}

		public static string TrouverJeu()
		{
			var candidats = new List<string>();
			candidats.Add(LireReglage("jeu"));

			// Le lanceur Blizzard note le dossier de la dernière variante installée (_retail_, _forever_…).
			foreach (string cle in new[] {
				@"SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft",
				@"SOFTWARE\Blizzard Entertainment\World of Warcraft" })
			{
				try
				{
					using (RegistryKey k = Registry.LocalMachine.OpenSubKey(cle))
					{
						string chemin = k == null ? null : k.GetValue("InstallPath") as string;
						if (string.IsNullOrEmpty(chemin)) continue;
						chemin = chemin.TrimEnd('\\', '/');
						candidats.Add(chemin);
						string parent = Path.GetDirectoryName(chemin);
						if (parent != null) candidats.Add(Path.Combine(parent, "_forever_"));
					}
				}
				catch { }
			}

			foreach (DriveInfo d in DriveInfo.GetDrives())
			{
				if (d.DriveType != DriveType.Fixed) continue;
				string r = d.RootDirectory.FullName;
				candidats.Add(Path.Combine(r, @"Program Files (x86)\World of Warcraft\_forever_"));
				candidats.Add(Path.Combine(r, @"Program Files\World of Warcraft\_forever_"));
				candidats.Add(Path.Combine(r, @"World of Warcraft\_forever_"));
				candidats.Add(Path.Combine(r, @"Games\World of Warcraft\_forever_"));
				candidats.Add(Path.Combine(r, @"Jeux\World of Warcraft\_forever_"));
			}

			foreach (string c in candidats)
				if (JeuValable(c) && Path.GetFileName(c.TrimEnd('\\', '/')).Equals("_forever_", StringComparison.OrdinalIgnoreCase))
					return c;
			// Le réglage enregistré peut désigner un dossier valable d'un autre nom.
			return JeuValable(candidats[0]) ? candidats[0] : null;
		}

		// ---------------------------------------------------------------- Réglages

		public static string LireReglage(string nom)
		{
			try
			{
				if (!File.Exists(FichierReglages)) return null;
				foreach (string ligne in File.ReadAllLines(FichierReglages, Encoding.UTF8))
				{
					int egal = ligne.IndexOf('=');
					if (egal > 0 && ligne.Substring(0, egal).Trim() == nom) return ligne.Substring(egal + 1).Trim();
				}
			}
			catch { }
			return null;
		}

		public static void EcrireReglage(string nom, string valeur)
		{
			var lignes = new List<string>();
			if (File.Exists(FichierReglages))
				lignes.AddRange(File.ReadAllLines(FichierReglages, Encoding.UTF8)
					.Where(l => { int e = l.IndexOf('='); return !(e > 0 && l.Substring(0, e).Trim() == nom); }));
			lignes.Add(nom + "=" + valeur);
			Directory.CreateDirectory(DossierReglages);
			File.WriteAllLines(FichierReglages, lignes, Encoding.UTF8);
		}

		public static void EcrireJournal(string texte)
		{
			try
			{
				Directory.CreateDirectory(DossierReglages);
				File.WriteAllText(FichierJournal, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + Environment.NewLine + texte, Encoding.UTF8);
			}
			catch { }
		}

		// ---------------------------------------------------------------- Démarrage de Windows

		public static bool LanceAuDemarrage()
		{
			using (RegistryKey k = Registry.CurrentUser.OpenSubKey(CLE_DEMARRAGE))
				return k != null && k.GetValue(NOM_DEMARRAGE) != null;
		}

		public static void LancerAuDemarrage(bool oui)
		{
			using (RegistryKey k = Registry.CurrentUser.CreateSubKey(CLE_DEMARRAGE))
			{
				if (oui) k.SetValue(NOM_DEMARRAGE, "\"" + Application.ExecutablePath + "\" /auto");
				else if (k.GetValue(NOM_DEMARRAGE) != null) k.DeleteValue(NOM_DEMARRAGE);
			}
		}

		public static Icon IconeProgramme()
		{
			try { return Icon.ExtractAssociatedIcon(Application.ExecutablePath) ?? SystemIcons.Application; }
			catch { return SystemIcons.Application; }
		}
	}

	// ---------------------------------------------------------------- Fenêtre

	class Fenetre : Form
	{
		readonly string jeuImpose;
		string jeu;
		readonly Label etat = new Label();
		readonly Label lblJeu = new Label();
		readonly ProgressBar barre = new ProgressBar();
		readonly TextBox journal = new TextBox();
		readonly CheckBox demarrage = new CheckBox();
		readonly Button btnRelancer = new Button();
		readonly Button btnDossier = new Button();
		readonly Button btnFermer = new Button();
		readonly StringBuilder texteJournal = new StringBuilder();

		public Fenetre(string jeuImpose)
		{
			this.jeuImpose = jeuImpose;
			Text = "GuildUpSMB - mise à jour";
			Icon = MiseAJour.IconeProgramme();
			FormBorderStyle = FormBorderStyle.FixedDialog;
			MaximizeBox = false;
			StartPosition = FormStartPosition.CenterScreen;
			ClientSize = new Size(560, 380);
			Font = new Font("Segoe UI", 9f);

			etat.SetBounds(12, 12, 536, 22);
			etat.Font = new Font("Segoe UI", 11f, FontStyle.Bold);
			lblJeu.SetBounds(12, 36, 536, 18);
			lblJeu.ForeColor = SystemColors.GrayText;
			lblJeu.AutoEllipsis = true;
			barre.SetBounds(12, 60, 536, 14);
			barre.Style = ProgressBarStyle.Marquee;
			journal.SetBounds(12, 82, 536, 230);
			journal.Multiline = true;
			journal.ReadOnly = true;
			journal.ScrollBars = ScrollBars.Vertical;
			journal.BackColor = SystemColors.Window;

			demarrage.SetBounds(12, 318, 536, 22);
			demarrage.Text = "Vérifier les mises à jour à chaque démarrage de Windows";
			try { demarrage.Checked = MiseAJour.LanceAuDemarrage(); } catch { }
			demarrage.CheckedChanged += delegate
			{
				try { MiseAJour.LancerAuDemarrage(demarrage.Checked); }
				catch (Exception e) { MessageBox.Show(this, e.Message, Text, MessageBoxButtons.OK, MessageBoxIcon.Warning); }
			};

			btnDossier.SetBounds(12, 346, 170, 26);
			btnDossier.Text = "Changer le dossier du jeu…";
			btnDossier.Click += delegate { if (ChoisirJeu()) Lancer(); };
			btnRelancer.SetBounds(296, 346, 120, 26);
			btnRelancer.Text = "Vérifier à nouveau";
			btnRelancer.Click += delegate { Lancer(); };
			btnFermer.SetBounds(428, 346, 120, 26);
			btnFermer.Text = "Fermer";
			btnFermer.Click += delegate { Close(); };
			CancelButton = btnFermer;

			Controls.AddRange(new Control[] { etat, lblJeu, barre, journal, demarrage, btnDossier, btnRelancer, btnFermer });
			Shown += delegate { Demarrer(); };
		}

		void Demarrer()
		{
			jeu = jeuImpose ?? MiseAJour.TrouverJeu();
			if (jeu == null)
			{
				MessageBox.Show(this, "Le dossier de WoW Forever (_forever_, qui contient Wow.exe) n'a pas été trouvé.\n"
					+ "Indiquez-le dans la fenêtre suivante.", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
				if (!ChoisirJeu()) { Close(); return; }
			}
			else if (jeuImpose == null) MiseAJour.EcrireReglage("jeu", jeu);
			Lancer();
		}

		bool ChoisirJeu()
		{
			using (var choix = new FolderBrowserDialog())
			{
				choix.Description = "Choisissez le dossier _forever_ de World of Warcraft (celui qui contient Wow.exe).";
				choix.ShowNewFolderButton = false;
				if (jeu != null) choix.SelectedPath = jeu;
				while (choix.ShowDialog(this) == DialogResult.OK)
				{
					if (MiseAJour.JeuValable(choix.SelectedPath))
					{
						jeu = choix.SelectedPath;
						MiseAJour.EcrireReglage("jeu", jeu);
						return true;
					}
					MessageBox.Show(this, "Ce dossier ne contient pas Wow.exe.", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
				}
			}
			return false;
		}

		void Lancer()
		{
			if (jeu == null) return;
			texteJournal.Clear();
			journal.Clear();
			lblJeu.Text = jeu;
			etat.ForeColor = SystemColors.ControlText;
			etat.Text = "Vérification…";
			barre.Visible = true;
			btnRelancer.Enabled = btnDossier.Enabled = false;

			var fil = new Thread(delegate()
			{
				Bilan bilan = null;
				Exception erreur = null;
				try { bilan = MiseAJour.Executer(jeu, Noter); }
				catch (Exception e) { erreur = e; }
				MiseAJour.EcrireJournal(texteJournal.ToString());
				BeginInvoke((Action)delegate { Fin(bilan, erreur); });
			});
			fil.IsBackground = true;
			fil.Start();
		}

		void Noter(string texte)
		{
			lock (texteJournal) texteJournal.AppendLine(texte);
			BeginInvoke((Action)delegate { journal.AppendText(texte + Environment.NewLine); });
		}

		void Fin(Bilan bilan, Exception erreur)
		{
			barre.Visible = false;
			btnRelancer.Enabled = btnDossier.Enabled = true;
			if (erreur != null)
			{
				string m = MiseAJour.Message(erreur);
				journal.AppendText("Erreur : " + m + Environment.NewLine);
				etat.ForeColor = Color.Firebrick;
				etat.Text = "Échec de la mise à jour";
			}
			else if (bilan.DejaAJour)
			{
				etat.ForeColor = Color.SeaGreen;
				etat.Text = "Déjà à jour - version " + bilan.Version;
			}
			else
			{
				etat.ForeColor = Color.SeaGreen;
				etat.Text = "Version " + bilan.Version + " installée";
			}
		}
	}
}
