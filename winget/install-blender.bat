@echo off
setlocal

REM ============================================================
REM FOG Snap-in - Installation de Blender via WinGet
REM ============================================================

echo ==========================================
echo Installation de Blender
echo ==========================================

REM Vérification de la présence de WinGet
where winget.exe >nul 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo ERREUR : WinGet n'est pas disponible.
    exit /b 1
)

echo WinGet detecte.
echo Installation de Blender en cours...

REM Installation de Blender
winget install --id BlenderFoundation.Blender ^
    --exact ^
    --silent ^
    --accept-package-agreements ^
    --accept-source-agreements ^
    --disable-interactivity

if %ERRORLEVEL% NEQ 0 (
    echo ERREUR : L'installation de Blender a echoue.
    exit /b %ERRORLEVEL%
)

echo.
echo ==========================================
echo Blender a ete installe avec succes.
echo ==========================================

exit /b 0