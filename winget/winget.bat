CHCP 65001
@echo off
cls

:check_Permissions
echo Permissions administrateur requises. Détection des autorisations...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Succès : Autorisations administrateur confirmées.
) else (
    echo Échec : Les autorisations actuelles sont insuffisantes.
    pause >nul
    exit
)
echo.
echo Suppression de la source msstore de WinGet...
winget source remove msstore
timeout /t 3



:menu
cls
REM Vérifier si la variable d'environnement profile est définie
if defined profile (
    set "profil_exist=%profile%"
) else (
    set "profil_exist=non renseigné"
)

REM Afficher MOTD
echo.
echo ********************************
echo      Script WinGet Loritz
echo.
echo Nom    : %COMPUTERNAME%
echo Profil : %profil_exist%
echo.
echo ********************************
echo.
echo  1. Mettre à jour tous les logiciels
echo  2. Installer un pack de logiciels
echo  3. Redémarrer le PC
echo  4. Quitter
echo.
set /p choix="Entrez le numéro de l'action souhaitée : "

if "%choix%"=="1" goto upgrade
if "%choix%"=="2" goto install
if "%choix%"=="3" goto redemarrer_pc
if "%choix%"=="4" goto quitter
echo Option invalide.
pause
goto menu



:upgrade
echo.
winget upgrade --all
echo.
echo.
echo **** FIN ****
echo.
pause
goto menu






:install
cls

REM Afficher menu install
echo.
echo ********************************
echo      Script WinGet Loritz
echo.
echo Nom    : %COMPUTERNAME%
echo Profil : %profil_exist%
echo.
echo ********************************
echo.
echo Sélection du pack à installer :
echo.
echo  1. Lobau
echo  2. Atelier
echo  3. Geometre
echo  4. Quitter
echo.
set /p pack="Entrez le numéro du pack souhaitée : "

if "%pack%"=="1" goto install_pack
if "%pack%"=="2" goto install_pack
if "%pack%"=="3" goto install_pack
if "%pack%"=="4" goto quitter
echo Option invalide.
pause
goto install

:install_pack
if "%pack%"=="1" set "pack_name=lobau.txt"
if "%pack%"=="2" set "pack_name=atelier.txt"
if "%pack%"=="3" set "pack_name=geometre.txt"

echo.
winget install (cat .\pack\%pack_name%) --scope machine
echo.
echo.
echo **** FIN ****
echo.
pause
goto menu

:redemarrer_pc
echo.
echo Vous allez redémarrer le PC. Voulez-vous continuer ? (O/N)
set /p confirm="Votre choix : "
if /i "%confirm%"=="O" (
    echo Redémarrage en cours...
    shutdown /r /t 5
) else (
    echo Redémarrage annulé.
)
pause
goto menu


:quitter
exit