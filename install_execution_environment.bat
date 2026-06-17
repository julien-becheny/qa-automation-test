@echo off
REM ============================================================
REM  Installation de l'environnement d'execution (Windows)
REM  - Cree un environnement virtuel Python isole (env)
REM  - Installe Robot Framework + Browser Library
REM  - Telecharge Playwright et les navigateurs (rfbrowser init)
REM ============================================================

echo [1/4] Creation de l'environnement virtuel...
python -m venv env
if %errorlevel% neq 0 goto :error

echo [2/4] Activation de l'environnement virtuel...
call env\Scripts\activate.bat
if %errorlevel% neq 0 goto :error

echo [3/4] Installation des dependances Python...
python -m pip install --upgrade pip
pip install -r requirements.txt
if %errorlevel% neq 0 goto :error

echo [4/4] Initialisation de Browser Library (Playwright + navigateurs)...
rfbrowser init
if %errorlevel% neq 0 goto :error

echo.
echo ============================================================
echo  INSTALLATION TERMINEE AVEC SUCCES
echo ============================================================
echo.
echo  Prochaine etape - lancer les tests :
echo.
echo    1. Activer l'environnement virtuel :
echo         env\Scripts\activate.bat        (Invite de commandes / cmd)
echo         .\env\Scripts\Activate.ps1      (PowerShell)
echo.
echo    2. Lancer la suite de tests :
echo         robot --outputdir results tests/
echo.
echo  Resultat attendu : 1 test, 1 passed, 0 failed
echo ============================================================
echo.
pause
goto :eof

:error
echo.
echo ============================================================
echo  ERREUR durant l'installation. Consultez les messages ci-dessus.
echo ============================================================
echo.
pause
exit /b 1
