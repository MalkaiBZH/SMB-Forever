// Mise à jour automatique de l'addon GuildUpSMB depuis GitHub, pour le client WoW Forever.
//
// Application de la zone de notification (une seule instance) :
//   * trouve le dossier du jeu (_forever_) : réglage enregistré, registre de Blizzard, chemins
//     habituels, sinon le demande au joueur ;
//   * vérifie au lancement puis à intervalle régulier (15 min par défaut, 2 min après une erreur) ;
//     GitHub ne sait pas prévenir un PC : on l'interroge. La requête est conditionnelle (ETag) :
//     une réponse 304 « rien de neuf » ne compte pas dans la limite de 60 requêtes par heure ;
//   * l'API renvoie l'empreinte du dernier commit de la branche (en-tête
//     « Accept: application/vnd.github.sha », réponse sans JSON). Si elle diffère de celle notée dans
//     Interface\AddOns\GuildUpSMB\.miseajour, télécharge l'archive de ce commit, en extrait le
//     dossier GuildUpSMB/ (sans les *.bak / *.previous) et synchronise le dossier installé ;
//   * notification Windows ensuite : /reload si seuls des fichiers existants ont changé, relancer
//     le jeu si des fichiers sont ajoutés ou si le .toc change (le jeu ne voit les nouveaux fichiers
//     qu'au démarrage), prochain lancement si le jeu est fermé.
// Fermer la fenêtre la range dans la zone de notification ; « Quitter » (menu de l'icône) arrête tout.
//
// Arguments :
//   /auto           démarrage de Windows : directement dans la zone de notification, sans fenêtre.
//   /jeu:<dossier>  dossier du jeu imposé, non enregistré (essais).
//   /verifier       un seul passage, sans interface ; code de sortie 0 = ok (essais, scripts).
// Relancer le programme alors qu'il tourne affiche la fenêtre de l'instance déjà lancée.
// Variable d'environnement GUILDUPSMB_JETON : jeton GitHub facultatif (dépôt privé, essais).
//
// Réglages : %APPDATA%\GuildUpSMB-MiseAJour\reglages.ini (jeu, intervalle, demarrage) ;
// journal du dernier passage : journal.txt. Démarrage avec Windows : clé HKCU\...\Run.
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
[assembly: System.Reflection.AssemblyVersion("2.0.0.0")]

namespace GuildUpSMB
{
	// Résultat d'un passage de mise à jour.
	class Bilan
	{
		public bool DejaAJour;
		public string Version = "?";
		public string Commit = "";
		public int Ajoutes, Modifies, Supprimes;
		public bool TocModifie;
		// Le jeu ne voit les nouveaux fichiers (et un .toc changé) qu'à son démarrage.
		public bool RelancerJeu { get { return Ajoutes > 0 || TocModifie; } }
	}

	static class MiseAJour
	{
		const string DEPOT = "MalkaiBZH/SMB-Forever";
		const string BRANCHE = "main";
		const string ADDON = "GuildUpSMB";
		const string MARQUE = ".miseajour";		// empreinte du commit installé, dans le dossier de l'addon
		const string CLE_DEMARRAGE = @"Software\Microsoft\Windows\CurrentVersion\Run";
		const string NOM_DEMARRAGE = "GuildUpSMB-MiseAJour";
		public const string NOM_INSTANCE = @"Local\GuildUpSMB-MiseAJour";
		public const string NOM_SIGNAL = @"Local\GuildUpSMB-MiseAJour-Afficher";

		static readonly string DossierReglages = Path.Combine(
			Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "GuildUpSMB-MiseAJour");
		static readonly string FichierReglages = Path.Combine(DossierReglages, "reglages.ini");
		static readonly string FichierJournal = Path.Combine(DossierReglages, "journal.txt");

		[System.Runtime.InteropServices.DllImport("user32.dll")]
		static extern bool AllowSetForegroundWindow(int processus);

		// Dernière réponse de l'API, pour les requêtes conditionnelles.
		static string etagConnu, commitConnu;

		// ---------------------------------------------------------------- Point d'entrée

		[STAThread]
		static int Main(string[] args)
		{
			// GitHub refuse les anciens protocoles : TLS 1.2 (3072) obligatoire.
			ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;

			bool auto = false, unPassage = false;
			string jeuImpose = null;
			foreach (string a in args)
			{
				if (a.Equals("/auto", StringComparison.OrdinalIgnoreCase)) auto = true;
				else if (a.Equals("/verifier", StringComparison.OrdinalIgnoreCase)) unPassage = true;
				else if (a.StartsWith("/jeu:", StringComparison.OrdinalIgnoreCase)) jeuImpose = a.Substring(5).Trim('"');
			}
			if (unPassage) return UnPassage(jeuImpose);

			bool premiere;
			using (var instance = new Mutex(true, NOM_INSTANCE, out premiere))
			{
				if (!premiere)
				{
					// Déjà lancé : un lancement à la main montre sa fenêtre, celui du démarrage ne fait rien.
					// Lancé par le joueur, ce programme a le droit de passer au premier plan : il le cède à
					// l'instance déjà lancée (sinon Windows laisse sa fenêtre derrière le jeu).
					if (!auto)
						try { AllowSetForegroundWindow(-1); EventWaitHandle.OpenExisting(NOM_SIGNAL).Set(); } catch { }
					return 0;
				}
				using (var signal = new EventWaitHandle(false, EventResetMode.AutoReset, NOM_SIGNAL))
				{
					Application.EnableVisualStyles();
					Application.SetCompatibleTextRenderingDefault(false);
					Application.Run(new Appli(auto, jeuImpose, signal));
				}
			}
			return 0;
		}

		static int UnPassage(string jeuImpose)
		{
			var journal = new StringBuilder();
			try
			{
				string jeu = jeuImpose ?? TrouverJeu();
				if (jeu == null) { journal.AppendLine("Dossier du jeu introuvable."); return 2; }
				Bilan b = Executer(jeu, delegate(string t) { journal.AppendLine(t); });
				if (!b.DejaAJour)
					journal.AppendLine(b.RelancerJeu ? "Il faut relancer le jeu." : "Un /reload suffit.");
				return 0;
			}
			catch (Exception e)
			{
				journal.AppendLine("Erreur : " + Message(e));
				return 1;
			}
			finally
			{
				EcrireJournal(journal.ToString());
			}
		}

		// ---------------------------------------------------------------- Mise à jour

		public static Bilan Executer(string jeu, Action<string> noter)
		{
			var bilan = new Bilan();
			string dossierAddon = Path.Combine(jeu, "Interface", "AddOns", ADDON);
			string fichierMarque = Path.Combine(dossierAddon, MARQUE);

			string commit = DernierCommit();
			bilan.Commit = commit;
			string installe = File.Exists(fichierMarque) ? File.ReadAllText(fichierMarque).Trim() : "";
			if (installe == commit && File.Exists(Path.Combine(dossierAddon, ADDON + ".toc")))
			{
				bilan.DejaAJour = true;
				bilan.Version = LireVersion(dossierAddon);
				noter("Déjà à jour (version " + bilan.Version + ", commit " + commit.Substring(0, 7) + ").");
				return bilan;
			}

			string temp = Path.Combine(Path.GetTempPath(), "GuildUpSMB-MiseAJour-" + Guid.NewGuid().ToString("N"));
			Directory.CreateDirectory(temp);
			try
			{
				noter("Nouvelle version sur GitHub : téléchargement du commit " + commit.Substring(0, 7) + "…");
				string archive = Path.Combine(temp, "addon.zip");
				TelechargerFichier("https://api.github.com/repos/" + DEPOT + "/zipball/" + commit, archive);

				string source = Path.Combine(temp, ADDON);
				Extraire(archive, source);
				if (!File.Exists(Path.Combine(source, ADDON + ".toc")))
					throw new Exception("l'archive ne contient pas " + ADDON + "/" + ADDON + ".toc.");
				bilan.Version = LireVersion(source);

				noter("Installation de la version " + bilan.Version + " dans " + dossierAddon);
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
			return bilan;
		}

		// Empreinte du dernier commit de la branche. Requête conditionnelle : un 304 rend l'empreinte connue.
		static string DernierCommit()
		{
			var requete = (HttpWebRequest)WebRequest.Create("https://api.github.com/repos/" + DEPOT + "/commits/" + BRANCHE);
			Preparer(requete, "application/vnd.github.sha");
			if (etagConnu != null && commitConnu != null) requete.Headers[HttpRequestHeader.IfNoneMatch] = etagConnu;

			string commit;
			try
			{
				using (var reponse = (HttpWebResponse)requete.GetResponse())
				{
					if (reponse.StatusCode == HttpStatusCode.NotModified) return commitConnu;
					using (var lecteur = new StreamReader(reponse.GetResponseStream(), Encoding.UTF8))
						commit = lecteur.ReadToEnd().Trim();
					if (commit.Length < 7 || commit.Length > 64 || commit.Any(c => !Uri.IsHexDigit(c)))
						throw new Exception("réponse inattendue de GitHub.");
					etagConnu = reponse.Headers[HttpResponseHeader.ETag];
					commitConnu = commit;
				}
			}
			catch (WebException e)
			{
				var r = e.Response as HttpWebResponse;
				if (r != null && r.StatusCode == HttpStatusCode.NotModified && commitConnu != null) return commitConnu;
				throw;
			}
			return commit;
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
					if (relatif.Equals(ADDON + ".toc", StringComparison.OrdinalIgnoreCase)) bilan.TocModifie = true;
					noter("  modifié : " + relatif);
				}
				else
				{
					bilan.Ajoutes++;
					noter("  ajouté : " + relatif);
				}
				Directory.CreateDirectory(Path.GetDirectoryName(destination));
				if (File.Exists(destination)) File.SetAttributes(destination, FileAttributes.Normal);
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

		// Le jeu tourne-t-il depuis ce dossier ? (Wow.exe du client Forever)
		public static bool JeuLance(string jeu)
		{
			string dossier = Path.GetFullPath(jeu).TrimEnd('\\');
			foreach (Process p in Process.GetProcessesByName("Wow"))
			{
				try
				{
					string exe = p.MainModule.FileName;
					if (Path.GetDirectoryName(exe).Equals(dossier, StringComparison.OrdinalIgnoreCase)) return true;
				}
				catch { return true; }	// processus illisible : on le suppose lancé
				finally { p.Dispose(); }
			}
			return false;
		}

		// ---------------------------------------------------------------- Réseau

		static void Preparer(HttpWebRequest requete, string accept)
		{
			requete.UserAgent = "GuildUpSMB-MiseAJour";
			requete.Accept = accept;
			requete.Timeout = 30000;
			string jeton = Environment.GetEnvironmentVariable("GUILDUPSMB_JETON");
			if (!string.IsNullOrEmpty(jeton)) requete.Headers[HttpRequestHeader.Authorization] = "Bearer " + jeton.Trim();
		}

		static void TelechargerFichier(string url, string fichier)
		{
			var requete = (HttpWebRequest)WebRequest.Create(url);
			Preparer(requete, "application/vnd.github+json");
			requete.Timeout = 120000;
			using (var reponse = requete.GetResponse())
			using (var flux = reponse.GetResponseStream())
			using (var sortie = File.Create(fichier))
				flux.CopyTo(sortie);
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
					return "GitHub limite les requêtes (60 par heure) : nouvel essai plus tard.";
				return "connexion à GitHub impossible (" + w.Message + ").";
			}
			if (e is UnauthorizedAccessException)
				return "accès refusé au dossier du jeu. Lancez ce programme en tant qu'administrateur. (" + e.Message + ")";
			if (e is IOException)
				return "fichier de l'addon inaccessible (" + e.Message + ").";
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

			// Le réglage enregistré d'abord (quel que soit le nom du dossier), puis un vrai _forever_.
			if (JeuValable(candidats[0])) return candidats[0];
			foreach (string c in candidats)
				if (JeuValable(c) && Path.GetFileName(c.TrimEnd('\\', '/')).Equals("_forever_", StringComparison.OrdinalIgnoreCase))
					return c;
			return null;
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
			try
			{
				var lignes = new List<string>();
				if (File.Exists(FichierReglages))
					lignes.AddRange(File.ReadAllLines(FichierReglages, Encoding.UTF8)
						.Where(l => { int e = l.IndexOf('='); return !(e > 0 && l.Substring(0, e).Trim() == nom); }));
				lignes.Add(nom + "=" + valeur);
				Directory.CreateDirectory(DossierReglages);
				File.WriteAllLines(FichierReglages, lignes, Encoding.UTF8);
			}
			catch { }
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
			try
			{
				using (RegistryKey k = Registry.CurrentUser.OpenSubKey(CLE_DEMARRAGE))
					return k != null && k.GetValue(NOM_DEMARRAGE) != null;
			}
			catch { return false; }
		}

		public static void LancerAuDemarrage(bool oui)
		{
			using (RegistryKey k = Registry.CurrentUser.CreateSubKey(CLE_DEMARRAGE))
			{
				if (oui) k.SetValue(NOM_DEMARRAGE, "\"" + Application.ExecutablePath + "\" /auto");
				else if (k.GetValue(NOM_DEMARRAGE) != null) k.DeleteValue(NOM_DEMARRAGE);
			}
		}

		// ---------------------------------------------------------------- Icône

		// icone.ico est incorporé au programme (construire.bat) : toutes les tailles, dont 16 x 16 pour la zone de notification.
		public static Icon Icone(Size taille)
		{
			try
			{
				using (Stream flux = typeof(MiseAJour).Assembly.GetManifestResourceStream("icone.ico"))
					if (flux != null) return new Icon(flux, taille);
			}
			catch { }
			return SystemIcons.Application;
		}
	}

	// ---------------------------------------------------------------- Application (zone de notification)

	class Appli : ApplicationContext
	{
		static readonly int[] INTERVALLES = { 5, 15, 30, 60 };	// minutes
		const int INTERVALLE_DEFAUT = 15;
		const int DELAI_ERREUR = 2;		// minutes avant un nouvel essai après une erreur

		readonly bool auto;
		readonly string jeuImpose;
		readonly NotifyIcon icone = new NotifyIcon();
		readonly Fenetre fenetre;
		readonly System.Windows.Forms.Timer minuteur = new System.Windows.Forms.Timer();
		readonly ToolStripMenuItem menuDemarrage;
		readonly RegisteredWaitHandle attente;
		string jeu;
		bool enCours, quitte, rangeeSignalee;
		Action apresBulle;	// action d'un clic sur la dernière notification

		public Appli(bool auto, string jeuImpose, EventWaitHandle signal)
		{
			this.auto = auto;
			this.jeuImpose = jeuImpose;

			fenetre = new Fenetre(this);
			IntPtr poignee = fenetre.Handle;	// poignée créée : BeginInvoke possible avant le premier affichage

			var menu = new ContextMenuStrip();
			var ouvrir = new ToolStripMenuItem("Ouvrir", null, delegate { Afficher(); });
			ouvrir.Font = new Font(ouvrir.Font, FontStyle.Bold);
			menu.Items.Add(ouvrir);
			menu.Items.Add(new ToolStripMenuItem("Vérifier maintenant", null, delegate { Verifier(true); }));
			menu.Items.Add(new ToolStripSeparator());
			menuDemarrage = new ToolStripMenuItem("Lancer au démarrage de Windows", null, delegate { Demarrage = !Demarrage; });
			menu.Items.Add(menuDemarrage);
			menu.Items.Add(new ToolStripSeparator());
			menu.Items.Add(new ToolStripMenuItem("Quitter", null, delegate { Quitter(true); }));

			icone.Icon = MiseAJour.Icone(SystemInformation.SmallIconSize);
			icone.ContextMenuStrip = menu;
			icone.MouseClick += delegate(object s, MouseEventArgs e) { if (e.Button == MouseButtons.Left) Afficher(); };
			icone.BalloonTipClicked += delegate
			{
				Action a = apresBulle ?? Afficher;
				apresBulle = null;
				a();
			};
			Infobulle("démarrage…");
			icone.Visible = true;

			minuteur.Tick += delegate { Verifier(false); };

			// Un second lancement du programme demande d'afficher la fenêtre.
			attente = ThreadPool.RegisterWaitForSingleObject(signal, delegate
			{
				try { fenetre.BeginInvoke((Action)Afficher); } catch { }
			}, null, -1, false);

			fenetre.BeginInvoke((Action)MiseEnRoute);
		}

		void MiseEnRoute()
		{
			if (jeuImpose == null)
			{
				// Premier lancement : démarrage avec Windows activé par défaut (décochable).
				if (MiseAJour.LireReglage("demarrage") == null)
				{
					try { MiseAJour.LancerAuDemarrage(true); } catch { }
					MiseAJour.EcrireReglage("demarrage", "propose");
				}
				// Suit le programme s'il a été déplacé.
				else if (MiseAJour.LanceAuDemarrage())
					try { MiseAJour.LancerAuDemarrage(true); } catch { }
			}
			MajDemarrage();

			jeu = jeuImpose ?? MiseAJour.TrouverJeu();
			if (jeu != null && jeuImpose == null) MiseAJour.EcrireReglage("jeu", jeu);
			fenetre.MajJeu(jeu);

			if (!auto) Afficher();
			if (jeu == null)
			{
				Infobulle("dossier du jeu à indiquer");
				if (auto) Bulle("Dossier de WoW Forever introuvable", "Cliquez ici pour l'indiquer.", ToolTipIcon.Warning, DemanderJeu);
				else DemanderJeu();
				return;
			}
			Verifier(false);
		}

		// ---- Réglages

		public int Intervalle
		{
			get
			{
				int m;
				return int.TryParse(MiseAJour.LireReglage("intervalle"), out m) && INTERVALLES.Contains(m) ? m : INTERVALLE_DEFAUT;
			}
			set
			{
				MiseAJour.EcrireReglage("intervalle", value.ToString());
				if (!enCours) Programmer(value);
			}
		}

		public static int[] Intervalles { get { return INTERVALLES; } }

		public bool Demarrage
		{
			get { return MiseAJour.LanceAuDemarrage(); }
			set
			{
				try { MiseAJour.LancerAuDemarrage(value); }
				catch (Exception e) { MessageBox.Show(fenetre, e.Message, fenetre.Text, MessageBoxButtons.OK, MessageBoxIcon.Warning); }
				MiseAJour.EcrireReglage("demarrage", value ? "oui" : "non");
				MajDemarrage();
			}
		}

		void MajDemarrage()
		{
			bool oui = MiseAJour.LanceAuDemarrage();
			menuDemarrage.Checked = oui;
			fenetre.MajDemarrage(oui);
		}

		void Programmer(int minutes)
		{
			minuteur.Stop();
			minuteur.Interval = minutes * 60000;
			minuteur.Start();
		}

		// ---- Actions

		public void Afficher()
		{
			if (quitte) return;
			fenetre.Show();
			if (fenetre.WindowState == FormWindowState.Minimized) fenetre.WindowState = FormWindowState.Normal;
			// Passage au premier plan, même quand Windows refuse l'activation (fenêtre ouverte depuis
			// l'icône ou une notification pendant qu'un autre programme a la main).
			fenetre.TopMost = true;
			fenetre.TopMost = false;
			fenetre.Activate();
		}

		// Fenêtre fermée : l'application continue dans la zone de notification (signalé une fois).
		public void Ranger()
		{
			fenetre.Hide();
			if (rangeeSignalee) return;
			rangeeSignalee = true;
			Bulle("GuildUpSMB reste actif", "Les mises à jour continuent en arrière-plan. Clic droit sur l'icône pour quitter.",
				ToolTipIcon.Info, null);
		}

		public void DemanderJeu()
		{
			Afficher();
			string choisi = fenetre.ChoisirJeu(jeu);
			if (choisi == null) return;
			jeu = choisi;
			MiseAJour.EcrireReglage("jeu", jeu);
			fenetre.MajJeu(jeu);
			Verifier(true);
		}

		public void Verifier(bool manuel)
		{
			if (enCours || quitte) return;
			if (jeu == null) { if (manuel) DemanderJeu(); return; }
			enCours = true;
			minuteur.Stop();
			string dossier = jeu;
			fenetre.Debut();
			Infobulle("vérification…");

			var lignes = new StringBuilder();
			Action<string> noter = delegate(string t)
			{
				string ligne = DateTime.Now.ToString("HH:mm") + "  " + t;
				lock (lignes) lignes.AppendLine(ligne);
				fenetre.Noter(ligne);
			};
			var fil = new Thread(delegate()
			{
				Bilan bilan = null;
				Exception erreur = null;
				try { bilan = MiseAJour.Executer(dossier, noter); }
				catch (Exception e) { erreur = e; noter("Erreur : " + MiseAJour.Message(e)); }
				MiseAJour.EcrireJournal(lignes.ToString());
				try { fenetre.BeginInvoke((Action)delegate { Fin(bilan, erreur, manuel); }); } catch { }
			});
			fil.IsBackground = true;
			fil.Start();
		}

		void Fin(Bilan bilan, Exception erreur, bool manuel)
		{
			enCours = false;
			if (quitte) return;
			fenetre.Fin(bilan, erreur);
			string heure = DateTime.Now.ToString("HH:mm");
			if (erreur != null)
			{
				Infobulle("erreur à " + heure + ", nouvel essai bientôt");
				if (manuel && !fenetre.Visible)
					Bulle("Mise à jour impossible", MiseAJour.Message(erreur), ToolTipIcon.Warning, null);
				Programmer(DELAI_ERREUR);
				return;
			}
			Programmer(Intervalle);
			if (bilan.DejaAJour)
			{
				Infobulle(bilan.Version + " à jour (vérifié à " + heure + ")");
				if (manuel && !fenetre.Visible)
					Bulle("GuildUpSMB est à jour", "Version " + bilan.Version + ".", ToolTipIcon.Info, null);
				return;
			}
			Infobulle(bilan.Version + " installée à " + heure);

			// Que faire pour charger la nouvelle version ?
			string texte;
			if (!MiseAJour.JeuLance(jeu))
				texte = "Elle sera chargée au prochain lancement du jeu.";
			else if (bilan.RelancerJeu)
				texte = "Relancez le jeu : de nouveaux fichiers ont été ajoutés, /reload ne suffit pas.";
			else
				texte = "Tapez /reload en jeu pour la charger.";
			fenetre.Noter(heure + "  " + texte);
			Bulle("GuildUpSMB " + bilan.Version + " installé", texte, ToolTipIcon.Info, null);
		}

		void Bulle(string titre, string texte, ToolTipIcon type, Action clic)
		{
			apresBulle = clic;
			icone.ShowBalloonTip(10000, titre, texte, type);
		}

		// Infobulle de l'icône : 63 caractères au plus (au-delà, Windows Forms refuse).
		void Infobulle(string etat)
		{
			string t = "GuildUpSMB : " + etat;
			icone.Text = t.Length > 63 ? t.Substring(0, 63) : t;
		}

		public bool Quitte { get { return quitte; } }

		public void Quitter(bool fermerFenetre)
		{
			if (quitte) return;
			quitte = true;
			minuteur.Stop();
			if (attente != null) attente.Unregister(null);
			icone.Visible = false;
			icone.Dispose();
			if (fermerFenetre) fenetre.Close();
			ExitThread();
		}
	}

	// ---------------------------------------------------------------- Fenêtre

	class Fenetre : Form
	{
		readonly Appli appli;
		readonly Label etat = new Label();
		readonly Label lblJeu = new Label();
		readonly ProgressBar barre = new ProgressBar();
		readonly TextBox journal = new TextBox();
		readonly CheckBox demarrage = new CheckBox();
		readonly ComboBox intervalle = new ComboBox();
		readonly Button btnVerifier = new Button();
		readonly Button btnDossier = new Button();
		readonly Button btnMasquer = new Button();
		readonly Button btnQuitter = new Button();
		bool majEnCours;	// mise à jour des contrôles par le programme : pas d'événement

		public Fenetre(Appli appli)
		{
			this.appli = appli;
			Text = "GuildUpSMB - mise à jour";
			Icon = MiseAJour.Icone(new Size(32, 32));
			FormBorderStyle = FormBorderStyle.FixedDialog;
			MaximizeBox = false;
			StartPosition = FormStartPosition.CenterScreen;
			ClientSize = new Size(560, 420);
			Font = new Font("Segoe UI", 9f);
			ShowInTaskbar = true;

			etat.SetBounds(12, 12, 536, 22);
			etat.Font = new Font("Segoe UI", 11f, FontStyle.Bold);
			etat.Text = "En attente…";
			lblJeu.SetBounds(12, 36, 536, 18);
			lblJeu.ForeColor = SystemColors.GrayText;
			lblJeu.AutoEllipsis = true;
			barre.SetBounds(12, 60, 536, 12);
			barre.Style = ProgressBarStyle.Marquee;
			barre.Visible = false;
			journal.SetBounds(12, 80, 536, 236);
			journal.Multiline = true;
			journal.ReadOnly = true;
			journal.ScrollBars = ScrollBars.Vertical;
			journal.BackColor = SystemColors.Window;

			demarrage.SetBounds(12, 324, 536, 22);
			demarrage.Text = "Lancer au démarrage de Windows (dans la zone de notification)";
			demarrage.CheckedChanged += delegate { if (!majEnCours) appli.Demarrage = demarrage.Checked; };

			var lblIntervalle = new Label();
			lblIntervalle.SetBounds(12, 353, 170, 20);
			lblIntervalle.Text = "Vérifier les mises à jour toutes les";
			lblIntervalle.AutoSize = true;
			intervalle.SetBounds(206, 350, 100, 22);
			intervalle.DropDownStyle = ComboBoxStyle.DropDownList;
			foreach (int m in Appli.Intervalles) intervalle.Items.Add(m < 60 ? m + " minutes" : (m / 60) + " heure");
			intervalle.SelectedIndex = Math.Max(0, Array.IndexOf(Appli.Intervalles, appli.Intervalle));
			intervalle.SelectedIndexChanged += delegate { appli.Intervalle = Appli.Intervalles[intervalle.SelectedIndex]; };

			btnDossier.SetBounds(12, 384, 170, 26);
			btnDossier.Text = "Changer le dossier du jeu…";
			btnDossier.Click += delegate { appli.DemanderJeu(); };
			btnVerifier.SetBounds(194, 384, 130, 26);
			btnVerifier.Text = "Vérifier maintenant";
			btnVerifier.Click += delegate { appli.Verifier(true); };
			btnMasquer.SetBounds(336, 384, 100, 26);
			btnMasquer.Text = "Masquer";
			btnMasquer.Click += delegate { appli.Ranger(); };
			btnQuitter.SetBounds(448, 384, 100, 26);
			btnQuitter.Text = "Quitter";
			btnQuitter.Click += delegate { appli.Quitter(true); };
			CancelButton = btnMasquer;

			Controls.AddRange(new Control[] { etat, lblJeu, barre, journal, demarrage, lblIntervalle, intervalle,
				btnDossier, btnVerifier, btnMasquer, btnQuitter });
		}

		protected override void OnFormClosing(FormClosingEventArgs e)
		{
			if (!appli.Quitte)
			{
				if (e.CloseReason == CloseReason.UserClosing)
				{
					// La croix range la fenêtre ; « Quitter » arrête le programme.
					e.Cancel = true;
					appli.Ranger();
					return;
				}
				appli.Quitter(false);	// fermeture de session Windows, etc.
			}
			base.OnFormClosing(e);
		}

		public void MajJeu(string jeu)
		{
			lblJeu.Text = jeu == null ? "Dossier du jeu non trouvé" : "Dossier du jeu : " + jeu;
		}

		public void MajDemarrage(bool oui)
		{
			majEnCours = true;
			demarrage.Checked = oui;
			majEnCours = false;
		}

		public string ChoisirJeu(string actuel)
		{
			using (var choix = new FolderBrowserDialog())
			{
				choix.Description = "Choisissez le dossier _forever_ de World of Warcraft (celui qui contient Wow.exe).";
				choix.ShowNewFolderButton = false;
				if (actuel != null) choix.SelectedPath = actuel;
				while (choix.ShowDialog(this) == DialogResult.OK)
				{
					if (MiseAJour.JeuValable(choix.SelectedPath)) return choix.SelectedPath;
					MessageBox.Show(this, "Ce dossier ne contient pas Wow.exe.", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
				}
			}
			return null;
		}

		public void Debut()
		{
			etat.ForeColor = SystemColors.ControlText;
			etat.Text = "Vérification…";
			barre.Visible = true;
			btnVerifier.Enabled = btnDossier.Enabled = false;
		}

		// Appelé depuis le fil de la mise à jour.
		public void Noter(string ligne)
		{
			try
			{
				BeginInvoke((Action)delegate
				{
					// Journal limité : on oublie la première moitié quand il devient long.
					if (journal.TextLength > 60000) journal.Text = journal.Text.Substring(journal.TextLength / 2);
					journal.AppendText(ligne + Environment.NewLine);
				});
			}
			catch { }
		}

		public void Fin(Bilan bilan, Exception erreur)
		{
			barre.Visible = false;
			btnVerifier.Enabled = btnDossier.Enabled = true;
			if (erreur != null)
			{
				etat.ForeColor = Color.Firebrick;
				etat.Text = "Échec de la mise à jour (nouvel essai dans 2 minutes)";
			}
			else if (bilan.DejaAJour)
			{
				etat.ForeColor = Color.SeaGreen;
				etat.Text = "À jour - version " + bilan.Version;
			}
			else
			{
				etat.ForeColor = Color.SeaGreen;
				etat.Text = "Version " + bilan.Version + " installée";
			}
		}
	}
}
