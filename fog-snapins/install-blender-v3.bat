@echo off
setlocal EnableExtensions

REM ============================================================
REM FOG Snap-in - Installation de Blender
REM
REM Source : \\172.17.1.30\drivers
REM Log principal : C:\Blender_Install.log
REM Log MSI       : C:\Blender_MSI.log
REM ============================================================

REM ------------------------------------------------------------
REM Configuration
REM ------------------------------------------------------------

set "SOURCE=\\172.17.1.30\drivers\blender-5.2.1-windows-x64.msi"

set "DOWNLOAD_DIR=C:\Temp\Blender"
set "MSI_FILE=%DOWNLOAD_DIR%\blender-5.2.1-windows-x64.msi"

set "LOGFILE=C:\Blender_Install.log"
set "MSI_LOG=C:\Blender_MSI.log"

REM ------------------------------------------------------------
REM Initialisation du log
REM ------------------------------------------------------------

echo ============================================================ > "%LOGFILE%"
echo [%date% %time%] Debut du Snap-in Blender >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

echo Installation de Blender...

echo [%date% %time%] Source : %SOURCE% >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Vérification du partage réseau
REM ------------------------------------------------------------

echo Verification du partage reseau...

if not exist "\\172.17.1.30\drivers\" (
    echo ERREUR : Le partage \\172.17.1.30\drivers est inaccessible.
    echo [%date% %time%] ERREUR : Partage reseau inaccessible >> "%LOGFILE%"
    exit /b 1
)

echo [%date% %time%] Partage reseau accessible >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Vérification du MSI
REM ------------------------------------------------------------

if not exist "%SOURCE%" (
    echo ERREUR : Le fichier MSI est introuvable.
    echo [%date% %time%] ERREUR : MSI introuvable : %SOURCE% >> "%LOGFILE%"
    exit /b 2
)

echo [%date% %time%] MSI trouve sur le partage >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Création du répertoire temporaire
REM ------------------------------------------------------------

if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%" >> "%LOGFILE%" 2>&1
)

if not exist "%DOWNLOAD_DIR%" (
    echo ERREUR : Impossible de creer le repertoire temporaire.
    echo [%date% %time%] ERREUR : Creation repertoire temporaire impossible >> "%LOGFILE%"
    exit /b 3
)

REM ------------------------------------------------------------
REM Copie du MSI en local
REM ------------------------------------------------------------

echo Copie du MSI en local...
echo [%date% %time%] Copie du MSI vers %MSI_FILE% >> "%LOGFILE%"

copy /Y "%SOURCE%" "%MSI_FILE%" >> "%LOGFILE%" 2>&1

set "COPY_ERROR=%ERRORLEVEL%"

if not "%COPY_ERROR%"=="0" (
    echo ERREUR : Impossible de copier le MSI.
    echo [%date% %time%] ERREUR copie MSI. Code : %COPY_ERROR% >> "%LOGFILE%"
    exit /b 4
)

REM ------------------------------------------------------------
REM Vérification de la copie
REM ------------------------------------------------------------

if not exist "%MSI_FILE%" (
    echo ERREUR : Le MSI n'existe pas apres la copie.
    echo [%date% %time%] ERREUR : MSI absent apres copie >> "%LOGFILE%"
    exit /b 5
)

for %%A in ("%MSI_FILE%") do set "MSI_SIZE=%%~zA"

echo [%date% %time%] Taille du MSI : %MSI_SIZE% octets >> "%LOGFILE%"

if "%MSI_SIZE%"=="0" (
    echo ERREUR : Le MSI est vide.
    echo [%date% %time%] ERREUR : MSI vide >> "%LOGFILE%"
    exit /b 6
)

echo [%date% %time%] Copie terminee avec succes >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Installation de Blender
REM ------------------------------------------------------------

echo Installation de Blender...

echo [%date% %time%] Debut installation MSI >> "%LOGFILE%"

msiexec.exe ^
    /i "%MSI_FILE%" ^
    /qn ^
    /norestart ^
    /L*v "%MSI_LOG%"

set "MSI_ERROR=%ERRORLEVEL%"

echo [%date% %time%] Code retour MSI : %MSI_ERROR% >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Résultat
REM ------------------------------------------------------------

if "%MSI_ERROR%"=="0" goto INSTALL_OK

if "%MSI_ERROR%"=="3010" goto INSTALL_OK

echo ERREUR : L'installation de Blender a echoue.
echo [%date% %time%] ERREUR MSI. Code retour : %MSI_ERROR% >> "%LOGFILE%"
echo [%date% %time%] Consulter %MSI_LOG% pour les details. >> "%LOGFILE%"

REM On conserve le MSI pour diagnostic
exit /b %MSI_ERROR%


REM ============================================================
REM INSTALLATION OK
REM ============================================================

:INSTALL_OK

echo.
echo ==========================================
echo Blender a ete installe avec succes.
echo ==========================================

echo [%date% %time%] Blender installe avec succes. >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Nettoyage
REM ------------------------------------------------------------

del /f /q "%MSI_FILE%" >> "%LOGFILE%" 2>&1

echo [%date% %time%] MSI temporaire supprime >> "%LOGFILE%"
echo [%date% %time%] Fin du Snap-in >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

exit /b 0
