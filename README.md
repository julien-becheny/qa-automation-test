# Test technique QA Automatisation — Robot Framework + Browser Library

Automatisation d'un parcours utilisateur web avec **Robot Framework** et la **Browser Library** (Playwright), organisée selon le **Page Object Model (POM)**.

Le parcours automatisé s'exécute sur le site de démonstration [saucedemo.com](https://www.saucedemo.com) : connexion → ajout de deux produits au panier → vérification de leur prix → tunnel de commande → confirmation.

---

## Démarrage rapide

Pour cloner, installer et exécuter en une fois :

```bash
git clone https://github.com/julien-becheny/qa-automation-test.git
cd qa-automation-test
python -m venv env
.\env\Scripts\Activate.ps1      # Windows (PowerShell) — macOS/Linux : source env/bin/activate
pip install -r requirements.txt
rfbrowser init
robot --outputdir results tests/
```

Résultat attendu : la suite se termine sur `1 test, 1 passed, 0 failed`.

---

## Prérequis

| Outil | Version | Remarque |
|-------|---------|----------|
| [Python](https://www.python.org/downloads/) | 3.10+ (testé en 3.12) | Cocher **« Add Python to PATH »** lors de l'installation |
| [Git](https://git-scm.com/downloads/) | Dernière | Pour cloner le dépôt |
| Navigateur | Chromium | Installé automatiquement par `rfbrowser init` |

> Sous Windows, **ouvrir un nouveau terminal** après l'installation de Python pour que le `PATH` soit pris en compte.

---

## Installation des dépendances

### Cloner le dépôt

```bash
git clone https://github.com/mastafungus/qa-automation-test.git
cd qa-automation-test
```

### Option A — Script automatique (Windows)

À la racine du dépôt :

```cmd
install_execution_environment.bat
```

Le script crée l'environnement virtuel, installe les dépendances et initialise Browser Library.

> ⚠️ Le script s'exécute dans son propre processus : une fois terminé, l'environnement virtuel **n'est plus actif** dans votre terminal. Avant de lancer les tests, activez-le manuellement :
>
> ```cmd
> :: Invite de commandes (cmd)
> env\Scripts\activate.bat
> ```
>
> ```powershell
> # PowerShell
> .\env\Scripts\Activate.ps1
> ```
>
> L'environnement est actif lorsque le préfixe `(env)` apparaît au début de la ligne du terminal.

### Option B — Manuelle (Windows / macOS / Linux)

1. Créer et activer un environnement virtuel :

   ```powershell
   # PowerShell (Windows)
   python -m venv env
   .\env\Scripts\Activate.ps1
   ```

   ```cmd
   :: Invite de commandes (cmd, Windows)
   python -m venv env
   env\Scripts\activate.bat
   ```

   ```bash
   # macOS / Linux
   python3 -m venv env
   source env/bin/activate
   ```

2. Installer les dépendances Python :

   ```bash
   pip install -r requirements.txt
   ```

3. Initialiser Browser Library (télécharge Playwright et les navigateurs) :

   ```bash
   rfbrowser init
   ```

> `rfbrowser init` peut prendre quelques minutes au premier lancement (téléchargement des navigateurs). C'est normal.

4. Vérifier que l'installation est complète :

   ```bash
   robot --version
   rfbrowser --version
   ```

---

## Lancement des tests

Depuis la racine du dépôt, environnement virtuel activé :

```bash
robot --outputdir results tests/
```

Exécuter en mode sans interface graphique (headless) :

```bash
robot --outputdir results --variable HEADLESS:True tests/
```

À la fin de l'exécution, la console doit afficher `1 test, 1 passed, 0 failed`.

---

## Rapports d'exécution

Après chaque exécution, Robot Framework génère dans le dossier `results/` :

- `report.html` — rapport de synthèse (statut global, durées, tags)
- `log.html` — journal détaillé pas à pas de chaque keyword
- `output.xml` — résultats bruts au format XML

---

## Structure du projet

```
.
├── tests/                      # Suites de test (scénarios)
│   └── parcours_achat.robot
├── pages/                      # Page Objects (locators + keywords métier par écran)
│   ├── login_page.resource
│   ├── inventory_page.resource
│   ├── cart_page.resource
│   └── checkout_page.resource
├── resources/                  # Ressources communes (setup navigateur, helpers)
│   └── common.resource
├── results/                    # Rapports d'exécution (log.html, report.html, output.xml)
├── functional_test_cases.txt   # 2 cas de test fonctionnels (partie fonctionnelle du test)
├── requirements.txt            # Dépendances Python
└── install_execution_environment.bat
```

### Principes appliqués

- **Page Object Model** : chaque écran a son fichier `.resource` (locators + keywords), les suites de `tests/` ne manipulent que des keywords métier lisibles.
- **Pas de `Sleep`** : la Browser Library applique un *auto-wait* sur les éléments avant chaque action.
- **Assertions explicites** : vérifications via les getters (`Get Text ... ==`, `Get Element Count`, `Wait For Elements State`).
- **Capture d'écran sur échec** : un screenshot est pris automatiquement en cas de test en erreur.
