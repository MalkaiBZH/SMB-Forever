@echo off
rem Construit GuildUpSMB-MiseAJour.exe avec le compilateur C# fourni avec Windows (.NET Framework 4).
rem icone.ico : la chope de GuildUpSMB/media/gu_emote.tga (16 a 92 pixels), incorporee au programme.
setlocal
set CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe
if not exist "%CSC%" set CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe
if not exist "%CSC%" (
	echo csc.exe introuvable : le .NET Framework 4 est-il installe ?
	exit /b 1
)
cd /d "%~dp0"
"%CSC%" /nologo /codepage:65001 /target:winexe /optimize+ /platform:anycpu ^
	/out:GuildUpSMB-MiseAJour.exe ^
	/win32icon:icone.ico /resource:icone.ico,icone.ico ^
	/r:System.Windows.Forms.dll /r:System.Drawing.dll ^
	/r:System.IO.Compression.dll /r:System.IO.Compression.FileSystem.dll ^
	MiseAJour.cs
