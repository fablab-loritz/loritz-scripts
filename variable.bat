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

:menu
cls
REM Vérifier si la variable d'environnement PROFILE est définie
if defined PROFILE (
    set "profil_exist=%PROFILE%"
) else (
    set "profil_exist=non renseigné"
)

REM Afficher MOTD
echo.
echo ********************************
echo     Script Variable Loritz
echo.
echo Nom    : %COMPUTERNAME%
echo Profil : %profil_exist%
echo.
echo ********************************
echo.
echo  1. Créer ou modifier la variable PROFILE
echo  2. Modifier le nom du PC
echo  3. Redémarrer le PC
echo  4. Quitter
echo.
set /p choix="Entrez le numéro de l'action souhaitée : "

if "%choix%"=="1" goto creer_profile
if "%choix%"=="2" goto modifier_pc
if "%choix%"=="3" goto redemarrer_pc
if "%choix%"=="4" goto quitter
echo Option invalide.
pause
goto menu


:creer_profile
echo.
REM Demander à l'utilisateur de saisir une valeur pour la variable PROFILE
set /p profile_value="Entrez la valeur à assigner à la variable PROFILE : "

REM Créer la variable d'environnement PROFILE avec la valeur saisie par l'utilisateur
setx PROFILE "%profile_value%" /M

REM Vérifier si la variable PROFILE a été correctement définie
if defined PROFILE (
    echo La variable d'environnement PROFILE a été créée avec la valeur : %PROFILE%
) else (
    echo Erreur lors de la création de la variable PROFILE.
)
pause
goto menu


:modifier_pc
echo.
set /p new_pc_name="Entrez le nouveau nom du PC : "
REM Commande pour renommer le PC
wmic computersystem where name="%COMPUTERNAME%" call rename name="%new_pc_name%"
echo Le nom du PC a été modifié en : %new_pc_name%
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




pause >nul
exit