@echo off
setlocal EnableExtensions

REM ============================================================
REM FOG Snap-in - Installation de Blender
REM
REM Téléchargement du MSI depuis un serveur Web
REM Installation silencieuse via MSIEXEC
REM Log : C:\Blender_Install.log
REM ============================================================

REM ------------------------------------------------------------
REM Configuration
REM ------------------------------------------------------------

set "DOWNLOAD_URL=https://mirror.blender.org/release/Blender5.2/blender-5.2.1-windows-x64.msi"
set "DOWNLOAD_DIR=C:\Temp\Blender"
set "MSI_FILE=%DOWNLOAD_DIR%\blender.msi"
set "LOGFILE=C:\Blender_Install.log"

REM ------------------------------------------------------------
REM Initialisation du log
REM ------------------------------------------------------------

echo ============================================================ > "%LOGFILE%"
echo [%date% %time%] Debut du Snap-in Blender >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

echo Installation de Blender...
echo [%date% %time%] URL : %DOWNLOAD_URL% >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Création du répertoire temporaire
REM ------------------------------------------------------------

if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%" >> "%LOGFILE%" 2>&1
)

if not exist "%DOWNLOAD_DIR%" (
    echo ERREUR : Impossible de creer le repertoire temporaire.
    echo [%date% %time%] ERREUR : Impossible de creer %DOWNLOAD_DIR% >> "%LOGFILE%"
    exit /b 1
)

REM ------------------------------------------------------------
REM Suppression d'un ancien MSI
REM ------------------------------------------------------------

if exist "%MSI_FILE%" (
    echo [%date% %time%] Suppression de l'ancien MSI >> "%LOGFILE%"
    del /f /q "%MSI_FILE%" >> "%LOGFILE%" 2>&1
)

REM ------------------------------------------------------------
REM Téléchargement du MSI
REM ------------------------------------------------------------

echo Telechargement de Blender...
echo [%date% %time%] Debut du telechargement >> "%LOGFILE%"

powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%MSI_FILE%' -UseBasicParsing"

set "DOWNLOAD_ERROR=%ERRORLEVEL%"

if not "%DOWNLOAD_ERROR%"=="0" (
    echo ERREUR : Le telechargement a echoue.
    echo [%date% %time%] ERREUR : Telechargement PowerShell. Code : %DOWNLOAD_ERROR% >> "%LOGFILE%"
    exit /b 2
)

REM ------------------------------------------------------------
REM Vérification du fichier téléchargé
REM ------------------------------------------------------------

if not exist "%MSI_FILE%" (
    echo ERREUR : Le fichier MSI n'existe pas apres le telechargement.
    echo [%date% %time%] ERREUR : MSI absent apres telechargement >> "%LOGFILE%"
    exit /b 3
)

for %%A in ("%MSI_FILE%") do set "MSI_SIZE=%%~zA"

echo [%date% %time%] Telechargement termine. Taille : %MSI_SIZE% octets >> "%LOGFILE%"

if "%MSI_SIZE%"=="0" (
    echo ERREUR : Le fichier MSI est vide.
    echo [%date% %time%] ERREUR : MSI vide >> "%LOGFILE%"
    exit /b 4
)

REM ------------------------------------------------------------
REM Installation de Blender
REM ------------------------------------------------------------

echo Installation de Blender...
echo [%date% %time%] Debut installation MSI >> "%LOGFILE%"

msiexec.exe /i "%MSI_FILE%" /qn /norestart /L*v "%LOGFILE%"

set "MSI_ERROR=%ERRORLEVEL%"

REM ------------------------------------------------------------
REM Analyse du résultat MSI
REM ------------------------------------------------------------

if "%MSI_ERROR%"=="0" (
    echo Blender a ete installe avec succes.
    echo [%date% %time%] Installation reussie. Code : 0 >> "%LOGFILE%"
    goto CLEANUP
)

if "%MSI_ERROR%"=="3010" (
    echo Blender a ete installe. Un redemarrage est necessaire.
    echo [%date% %time%] Installation reussie. Redemarrage necessaire. Code : 3010 >> "%LOGFILE%"
    goto CLEANUP
)

echo ERREUR : L'installation de Blender a echoue.
echo [%date% %time%] ERREUR MSI. Code retour : %MSI_ERROR% >> "%LOGFILE%"

goto ERROR

REM ------------------------------------------------------------
REM Nettoyage
REM ------------------------------------------------------------

:CLEANUP

echo [%date% %time%] Suppression du fichier MSI temporaire >> "%LOGFILE%"

del /f /q "%MSI_FILE%" >> "%LOGFILE%" 2>&1

echo [%date% %time%] Fin du Snap-in Blender >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

exit /b 0

REM ------------------------------------------------------------
REM Erreur
REM ------------------------------------------------------------

:ERROR

echo [%date% %time%] Echec du Snap-in Blender >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

exit /b %MSI_ERROR%
