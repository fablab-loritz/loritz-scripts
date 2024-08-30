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
REM Vérifier si la variable d'environnement profil est définie
if defined profil (
    set "profil_exist=%profil%"
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
echo  1. Créer ou modifier la variable profil
echo  2. Modifier le nom du PC
echo  3. Redémarrer le PC
echo  4. Quitter
echo.
set /p choix="Entrez le numéro de l'action souhaitée : "

if "%choix%"=="1" goto creer_profil
if "%choix%"=="2" goto modifier_pc
if "%choix%"=="3" goto redemarrer_pc
if "%choix%"=="4" goto quitter
echo Option invalide.
pause
goto menu


:creer_profil
echo.
REM Demander à l'utilisateur de saisir une valeur pour la variable PROFIL
set /p profil_value="Entrez la valeur à assigner à la variable profil : "

REM Créer la variable d'environnement PROFIL avec la valeur saisie par l'utilisateur
setx profil "%profil_value%" /M

REM Vérifier si la variable PROFIL a été correctement définie
if defined profil (
    echo La variable d'environnement profil a été créée avec la valeur : %profil_value%
) else (
    echo Erreur lors de la création de la variable profil.
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


:quitter
exit