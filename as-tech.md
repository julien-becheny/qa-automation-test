cdi

port marianne
as-tech solution

depuis 1980

editeur logiciel
logiciel de gestion de patrimoine
100 n

l-cabos@maten.fr

### 

### **Ton parcours**

> *"J’ai une expérience centrée sur l'automatisation de tests pour des éditeurs de logiciels. Actuellement, je travaille pour un éditeur de logiciel santé, CGM, où j’ai conçu, je maintiens et j’améliore l’infrastructure globale des test auto, pour une application native multiplateforme (iOS, Android, Windows).

Ma stack quotidienne : **Robot Framework, Appium, Python et Playwright**

Avec comme objectif permanent : Augmenter la couverture des tests, réduire la maintenance et valider les release rapidement"*
> 

### **"Pourquoi cherchez-vous à quitter votre poste actuel ?"**

> *"Le framework que j'ai construit est aujourd'hui mature — 350 tests, 4 OS, pipeline CI, le tout bien rodé. J'ai envie d'un nouveau challenge technique, et mettre en place l'automatisation de zéro comme chez votre client, c'est exactement ce qui me motive. C'est la partie du métier que je préfère : partir d'une page blanche et construire quelque chose de solide."*
> 

### 

### **"Qu'avez-vous mis en place concrètement ?"**

### **🔧 Axe 1 — Le framework de test**

- **Robot Framework + Appium + Python** : code multi-OS (Windows, Android, iOS)
- Lib Python GenZLibrary structurée par OS (windows/, android/, ios/, mobile/, common/) + modules métier (api/, performance/, external/)
- ~50 fichiers de keywords Robot (`.resource`) couvrant : facturation, prescription, planification, patient, roadmap, feuille de route, performances, préférences, profils, retrocession, XPath dynamiques
- TestObjects séparés : locators centralisés, pas hardcodés dans les tests
- Pattern data-driven : données YAML/Python séparées du code de test
- Tests de performance dédiés : fuites mémoire (3 OS), temps de chargement des pages, benchmarking
- 
- **362 test cases** Robot Framework + Appium, pilotés par données YAML, exécutables sur les 3 OS depuis la même base de code
- Un système de **locators centralisés** (TestObjects) et de **keywords métier réutilisables** (~60 fichiers .resource) pour que n'importe quel testeur puisse écrire un test sans toucher aux locators
- Un pattern **data-driven** complet : les données de test (73 fichiers YAML/Python, ~39 000 lignes) sont séparées du code de test. Un même scénario tourne sur Windows, Android et iOS sans modification
- Des **tests de performance** dédiés : mesure automatisée des fuites mémoire (3 OS) et des temps de chargement d'écrans, avec stockage en base et envoi vers ELK

**Résultat** : une campagne complète (362 tests) s'exécute en autonome sur les 7 bancs en parallèle. Les régressions sont détectées avant chaque release.

### **🖥️ Axe 2 — L'application RF-EM (Robot Framework Execution Manager)**

*J'ai développé une application complète react*

*interface de pilotage pour ma plateforme de tests*

## **Architecture technique**

- **Backend** : API Flask (Python) sur le port 5001, avec WebSocket (Socket.IO) pour le temps réel
- **Frontend** : Application React (SPA) avec ~35 pages/écrans
- **Communication** : REST + WebSocket bidirectionnel (logs live, notifications, statut d'exécution)
- **Persistance** : JSON (`variables_config.json`) + SQLite (performances) + fichiers YAML/XML

- **Sélection d'environnement** : 18+ environnements (testeurs, demo, rc, next, develop, feature branches…)
- **Sélection d'OS** : Windows / Android / iOS avec logos et config spécifique
- **Sélection de version** : page dédiée par environnement avec **détection de la dernière version** et comparaison avec la version stockée

## **3. Exécution de tests**

### **Modes d'exécution**

- **Cas nominal** : test de base de l'application (inscription patient, parcours standard)
- **Tests par tags** : sélection de tags d'inclusion/exclusion avec **système d'exclusion contextuelle automatique** (OS, environnement, banc)
- **Tests aléatoires (randomisés)** : sélection d'un échantillon parmi les tests matchés, avec nombre configurable
- **Tests depuis XML** : upload d'un `output.xml` pour **rejouer uniquement les tests en échec**
- 
- **Re-run automatique** : les tests en échec sont automatiquement relancés, puis les résultats sont **fusionnés** (merge XML original + rerun)
- **Stop signal** : arrêt gracieux en cours d'exécution via fichier signal, respecté dans toute la chaîne
- **Logs temps réel** : les listeners Robot Framework envoient les logs via HTTP → WebSocket → UI React
- **Statut final** : détection du résultat (PASS/FAIL/SKIP) et notification live
- **Gestion multi-utilisateurs** : détection IP pour empêcher un utilisateur de perturber l'exécution d'un autre

## **4. Gestion des campagnes de tests**

- **Création / activation / fermeture / suppression** de campagnes
- **Configuration par campagne** : tags, nombre de tests, options Allure, rerun
- **Exécution par OS** : lancement des tests restants pour un OS donné (ANDROID, IOS, WINDOWS)
- **Tracking** : mise à jour automatique des résultats par OS après chaque exécution
- **Statistiques** : taux de réussite, tests restants, avancement par OS
- **Archivage** automatique des anciennes campagnes (+30 jours)

- **Monitoring centralisé** : health-check de tous les bancs en parallèle (online/offline, test en cours)
- **Git pull distant** : synchronisation du code sur un ou plusieurs bancs avec retry automatique
- **Déploiement distant** : workflow complet (sync config → download APK → fermeture app → installation) — adapté par OS (iOS : TestFlight)
- **Lancement de tests distant** : synchronisation de la config + exécution avec les mêmes options qu'en local
- **Pipeline "Run All"** : exécution séquentielle des étapes (pull → deploy → test) sur **tous les bancs en parallèle**
- **Suivi WebSocket** : chaque étape émet des événements pour un suivi temps réel dans l'UI

## **6. Performance & benchmarking**

### **Mesure mémoire**

- **Android** : listener dédié collectant les données mémoire pendant l'exécution
- **iOS** : analyse mémoire post-exécution
- **Windows** : analyse mémoire avec graphiques temporels
- **Graphiques** : génération automatique de courbes mémoire (matplotlib) corrélées au temps de test

### **Mesure temps de chargement des pages (Screen Timing)**

- **Boucle de collecte** : exécution répétée jusqu'à atteindre N itérations cibles (reprise automatique en cas d'échec)
- **Base de données SQLite** : stockage des mesures par version / OS / device
- **Comparaison de versions** : sélection de 2 combos (OS+version) → rapport HTML avec delta par transition d'écran
- **Détection de régressions** : seuil configurable (défaut 10%), alertes sur les écrans dégradés
- **Analyse de tendance** : graphiques multi-versions pour suivre l'évolution dans le temps
- **Gestion des données** : suppression individuelle ou en lot de combos, indicateurs de qualité (nombre d'itérations)

## **7. Reporting & intégrations**

- **Rapports HTML** : génération de rapports Robot Framework consultables via l'UI
- **Allure TestOps** : upload automatique des résultats (avec gestion merge quand rerun)
- **ELK (Elasticsearch)** : envoi des résultats d'exécution et des données de performance
- **Graphiques de timing** : étapes du cas nominal visualisées
- **Liens logs** : accès direct aux rapports (original / fusionné) depuis l'UI

## **8. Gestion du déploiement applicatif**

- **Download** : téléchargement des APK/EXE depuis le registry Nexus
- **Installation** : installation automatique (Windows : MSIX, Android : APK, iOS : TestFlight)
- **Purge** : nettoyage de l'environnement de test (données, cache)
- **Initialisation** : préparation de l'environnement post-install (paramètres, données de base)
- **Fermeture app** : fermeture de l'application Eve avant install (évite le lock de fichier)
- **Workflows composables** : chaîner purge + init + install + tests en un seul clic

## **9. Tags et filtrage intelligent**

- **Catalogue de tags** : extraction automatique depuis tous les fichiers `.robot`
- **Exclusions contextuelles** : calcul automatique des tags à exclure selon l'OS, l'environnement et le banc
- **Tags rftid masqués** : endpoint qui calcule quels tests sont invisibles selon le contexte courant (avec raisons)
- **Comptage de tests** : nombre de tests matchés avant exécution (preview)
- **Dictionnaire de tests** : association test ↔ tags, généré/mis à jour automatiquement

---

## **10. Documentation intégrée**

- **Génération doc Keywords** : libdoc Robot Framework → HTML consultable via l'UI
- **Génération doc Test Suites** : catalogue des suites de tests
- **Fusion de rapports** : outil de merge de rapports XML depuis l'UI

---

## **11. Outils système**

- **Git pull + auto-restart** : synchronisation du repo avec redémarrage automatique de Flask si des fichiers Python ont changé
- **Détection branche Git** : affichée dans le header de l'UI
- **Remote Windows actions** : maximiser fenêtre, basculer clavier FR/US, clic par coordonnées, scroll — utilisable à distance
- **Remote PDF** : récupération du dernier PDF généré par Eve depuis le cache Windows
- **IP courante** : détection du banc de test actif

---

## **12. CI/CD (Concourse)**

- **CI Runner** : script autonome (ci_runner.py) pour les jobs Concourse
- **Pipeline** : download → install → init → tests → reporting, paramétrable via arguments CLI
- **Environnements supportés** : develop, rc, master

---

## **Points forts à valoriser en entretien**

1. **Full-stack solo** : Flask + React + WebSocket, conçu, développé et maintenu par toi seul
2. **Multi-OS, multi-bancs** : pilotage centralisé de 6 machines physiques hétérogènes
3. **Orchestration parallèle** : déploiement et tests sur tous les bancs en simultané
4. **Performance monitoring** : base SQLite, comparaison de versions, détection de régressions
5. **Résilience** : stop signal, retry, rerun automatique, cleanup, gestion des conflits multi-utilisateurs
6. **DevOps intégré** : git pull distant, auto-restart, CI Concourse, Allure, ELK
7. **UX** : wizard de configuration, logs temps réel, statut d'exécution live, navigation fluide sur ~35 écrans

**Backend (Flask + SocketIO)** :

- 7 blueprints : config, tests, utils, campaigns, orchestration, performance, robot_listener
- 11 domaines de services : campaigns/, execution/, reporting/, tags/, versioning/, orchestration/, performance/, configuration/, devices/, documentation/, utils/
- WebSocket temps réel pour le suivi d'exécution
- Orchestrateur : deploy → download → install → init → tests → rerun → merge → report → allure → ELK

**Frontend (React)** :

- 42 pages : wizard config, menu, sélection tags, campagnes, monitoring bancs, options d'exécution, suivi en cours, comparaison de versions, analyse de tendances
- Utilisable par toute l'équipe sans compétence technique
- 
- Un **frontend React** (42 pages, ~24 000 lignes) avec wizard de configuration, sélection de tests par tags, suivi d'exécution temps réel (WebSocket), monitoring des bancs, comparaison de versions et analyse de tendances
- Un **backend Flask** (7 routes, 55 modules de services, ~16 000 lignes) qui orchestre le cycle complet : déploiement de l'app sur les bancs → téléchargement depuis le registry Nexus → installation → initialisation → exécution des tests → re-run automatique des échecs → fusion des résultats → génération de rapports → upload Allure TestOps → envoi ELK
- Le **re-run intelligent** : les tests échoués sont automatiquement extraits du XML, rejoués, et les résultats fusionnés

### **🏗️ Axe 3 — Bancs de test et orchestration multi-machines**

- 6 bancs physiques en réseau (3 Win desktop, 1 Win+Android, 1 Mac+iPhone, 1 Mac+iPad)
- Config centralisée dans bench_config.py : IPs, capacités, OS supportés, tags d'exclusion automatique par banc
- Pilotage distant : health check parallèle, sync config, deploy, lancement de tests — le tout depuis l'UI React
- Exclusion contextuelle de tags par OS/banc/environnement (tests Windows-only ne tournent pas sur Mac, etc.)
- 
- Une **configuration centralisée des bancs** (IPs, capacités, OS supportés, tags d'exclusion par banc) : un test tagué `android_only` ne sera jamais envoyé sur un banc Windows
- La **discovery automatique des environnements** depuis le registry Nexus (~20 environnements : testeurs, RC, develop, master, branches de dev) avec détection de version, téléchargement et installation automatisés
- Un **runner CI dédié** (Concourse) pour les branches develop/rc/master : à chaque merge, les tests se lancent automatiquement
- **9 listeners Robot Framework** instrumentent chaque exécution : logs UI temps réel, mesure mémoire par OS (psutil/dumpsys/devicectl), timing des keywords, timing des écrans, signal d'arrêt propre
- Reporting centralisé : **Allure TestOps** (résultats de tests), **ELK** (métriques de performance + résultats), graphiques mémoire générés par OS

### **📊 Axe 4 — CI/CD et reporting**

- **CI Concourse** : runner Python dédié (ci_runner.py), exécution auto sur develop/rc/master
- **Re-run automatique** : extraction des tests échoués depuis l'XML → rejeu → merge des résultats → Les tests échouant 2 fois sont analysés en priorité
- **Allure TestOps** : upload automatique des résultats
- **ELK** : envoi des résultats de tests + données de performance (mémoire, timing)
- **Listeners Robot Framework** (7) : instrumentation transparente pendant l'exécution
- Site interne pour centraliser les rapports

### **🚀 Axe 5 — Injection API + gestion des environnements**

- Module GenZLibrary/api/ : 14 sous-modules, flux complet YAML → mapping → payloads → domains → API REST
- Domaines couverts : patient, AMO, AMC, AT, CVV, prescription, planification, facturation, prescripteurs, référentiels, model user
- Discovery dynamique des environnements depuis le registry Nexus (~20 envs : testeurs, rc, develop, master, branches de dev)
- Détection de version, téléchargement, installation automatisés
- 
- Un **module d'injection API complet** (14 domaines, ~5 000 lignes Python) qui reproduit en quelques secondes ce qu'un utilisateur fait en 5 minutes dans l'app
- Le flux : un fichier YAML décrit un cas de test → le mapping Python traduit en payloads API → l'injection crée patient, droits AMO/AMC, prescripteur, prescription, planification, séances

---

## **💡 Points forts à faire passer**

1. **"Je n'écris pas juste des tests, j'ai construit la plateforme"** — framework + backend + frontend + bancs + CI/CD + reporting
2. **"350 tests sur 4 OS, exécutés chaque nuit"** — c'est du concret, pas du POC
3. **"Validation release : 1 semaine → 24-36h"** — impact business mesurable
4. **"Utilisable par l'équipe"** — pas un outil de niche que toi seul comprends
5. **"Architecture propre"** — 11 domaines de services, séparation des responsabilités, pas un monolithe
6. **"Détection proactive de bugs"** — fuite mémoire détectée par les tests auto, confirmée en rejouant sur différents environnements

### **"Connaissez-vous Postman ?"**

> *"Oui, je l'utilise pour explorer et débugger les API REST. Dans mon framework actuel, j'ai poussé le concept plus loin : au lieu de tester manuellement dans Postman, j'ai développé une couche Python complète qui fait les mêmes appels de manière programmatique, ce qui permet d'injecter des scénarios de test complets via API en quelques secondes."*
> 

### **❓ "Connaissez-vous Symfony / Angular ?"**

> 
> 
> 
> *"Symfony non, mais côté frontend JavaScript, j'ai développé moi-même une application React complète — 42 pages — qui sert d'interface de pilotage pour ma plateforme de tests. React et Angular, c'est le même paradigme : des composants, du state management, des appels API REST vers un backend. D'ailleurs mon backend c'est du Flask en Python, qui est très proche de Symfony dans l'approche : des routes, des contrôleurs, une logique métier séparée en services.*
> 
> *Et surtout, en tant qu'ingénieur QA, ce qui compte c'est de comprendre l'architecture de l'application pour écrire des tests pertinents. Là-dessus j'ai l'habitude : actuellement je teste une app MAUI/.NET avec un backend API REST, donc m'adapter à Symfony/Angular ne me pose aucune inquiétude."*
> 

### **❓ "Comment travaillez-vous avec les développeurs ?"**

> *"En mode agile. Je participe aux sprints, je définis les stratégies de test en amont, et je collabore avec les devs pour identifier les zones de risque, anticiper les prochains changement dans l’interface UI de l’app*
> 

### **❓ "Quelle est votre approche pour mettre en place l'automatisation from scratch ?"**

> *"Je procède par étapes :
1. Audit de l'existant : comprendre la stack, les flux critiques, ce qui est déjà testé manuellement
2. Choix du framework et de l'architecture (Robot Framework est déjà identifié ici, c'est mon outil quotidien)
3. Premiers tests smoke sur les parcours critiques (Un cas nominal) — quick wins pour montrer la valeur
4. Couche d'abstraction (Page Objects / keywords) pour rendre les tests maintenables
5. Intégration CI/CD pour que les tests tournent à chaque merge/déploiement
6. Montée en charge progressive : Mise en place d’une plateforme de pilotage de tests"*
> 

### **❓ "Prétentions salariales ?"**

Tu t'es positionné à **48k**. Reste ferme :

> *"Comme je vous l'ai indiqué, je me positionne autour de 48k, ce qui est cohérent avec mon niveau d'expérience et le périmètre du poste "*
> 

### **❓ "Utilisez-vous l'IA ?"**

> 
> 
> 
> > ***J'utilise l'IA comme un coéquipier de développement au quotidien depuis plus de deux ans**. Ce n'est pas du copier-coller de ChatGPT — c'est un vrai workflow intégré dans mon IDE.*
> > 
> 
> > *Concrètement, voici comment je m'en sers :*
> > 
> 
> > ***1. Écriture et debug de code** J'utilise un assistant IA directement dans mon éditeur (Windsurf/Devin). Il a accès à mon codebase, comprend l'architecture du projet, et je lui donne des instructions précises. Il propose du code, je review, je valide ou je corrige. C'est du pair programming augmenté.*
> > 
> 
> > ***2. Automatisation de tests** Mon projet principal, c'est un framework de test Robot Framework + Appium pour une application mobile de santé. L'IA m'aide à écrire les tests, générer les données de test, mapper des payloads API complexes, et debugger quand un test échoue , y compris en analysant les logs.*
> > 
> 
> > ***3. Capitalisation des connaissances** J'ai mis en place un système de "mémoires" et de "lessons learned" que l'IA consulte à chaque session. Les règles métier, les pièges connus, les conventions du projet, tout est documenté et l'IA les respecte automatiquement. Ça évite de répéter les mêmes erreurs.*
> > 
> 
> > ***4. Extraction et analyse de données** J'ai utilisé l'IA pour analyser des exports JIRA de milliers de tickets, en extraire les règles métier actionnables, et les documenter proprement. Ce qui aurait pris des semaines à la main s'est fait en quelques sessions.*
> > 
> 
> > ***5. Cadrage et discipline** L'IA ne fait pas n'importe quoi. J'ai défini des workflows, des règles strictes (diff minimal, pas de code spéculatif, vérification dans le code avant toute hypothèse), et des conventions d'architecture. **C'est moi qui pilote, l'IA exécute dans un cadre que j'ai défini.***
> > 
> 
> > *Ce que ça change concrètement :
> • **Vélocité** : je livre plus vite, surtout sur les tâches répétitives ou à forte complexité technique.
> • **Qualité** : l'IA me force à formaliser mes règles métier et mes conventions — le projet est mieux documenté qu'il ne l'aurait été sans.
> • **Apprentissage** : quand l'IA se trompe, je comprends pourquoi et j'affine mes instructions. Ça m'a rendu meilleur en architecture et en expression de besoin.*
> > 
> 
> > ***En résumé** : l'IA ne me remplace pas, elle amplifie ce que je sais déjà faire. Et la compétence clé, c'est de savoir la cadrer, lui donner le bon contexte, les bonnes contraintes, et savoir quand ne pas la suivre.*
> > 

---

## **4. Tes questions à poser**

1. **"Quel est le produit de votre client ?"** — tu dois comprendre le domaine métier
2. **"Quelle est la volumétrie utilisateur ?"** — elle a mentionné "forte volumétrie"
3. **"Les 2 testeurs font du test manuel ou déjà un peu d'automatisation ?"** — savoir d'où tu pars
4. **"Le responsable QA est-il plutôt technique ou plutôt management ?"** — comprendre ton N+1
5. **"Quel est le process de recrutement côté client ?"** — combien d'étretiens, test technique ?
6. **"Le télétravail, avez-vous pu avoir la réponse ?"** — info clé pour toi
7. **"Y a-t-il une raison particulière pour laquelle ils ont choisi Robot Framework ?"** — montre ta curiosité

**Ne pose PAS** : des questions sur les avantages/RTT/CE à ce stade. Trop tôt.

---

## **5. Points de vigilance**

- **C'est une recruteuse externe**, pas le client. Elle évalue ta motivation, ta cohérence, et ta communication. Le test technique viendra plus tard.
- **Ne rentre pas dans le détail technique extrême** (pas de "PUT /api/acteseance" ni de "dataInputSource"). Reste sur les concepts.
- **Montre de l'enthousiasme** pour le fait de "mettre en place from scratch". C'est LE point du poste.
- **Lattes = Montpellier**. Si tu es en remote, clarifie ta situation géographique.
- **48k dans la fourchette 42-50k** : tu es dans le haut. Justifie par le niveau d'autonomie attendu (mise en place, pas simple exécution).

## **Aide-mémoire chiffré (à avoir sous les yeux)**

| **Indicateur** | **Chiffre** |
| --- | --- |
| Tests automatisés | **~350** |
| OS supportés | **4** (Windows, Android, iPhone, iPad) |
| Fichiers .robot (suites de test) | **70** |
| Keywords Robot Framework (.resource) | **~50 fichiers** |
| TestObjects (XPath/locators) | **15 fichiers** |
| Fichiers de données de test | **73** |
| Backend Flask — domaines de service | **11** (+ 7 blueprints API) |
| Frontend React — pages | **42** |
| Bancs de test | **6 machines** (+ 2 dev perso) |
| Listeners Robot Framework | **7** (timing, mémoire ×3 OS, screen timing, logs UI, stop signal) |
| Couche API Python — domaines | **14 modules** (mapping, payloads, domains) |
| Règles métier documentées | **~50** |
| Réduction temps validation release | **de ~1 semaine → 24-36h** |
| Injection API vs UI | **3-4 min → 10 sec** par scénario |
| Environnements testables | **~20** (Nexus registry, discovery dynamique) |

---

## 

*En un peu plus de 3 ans, j'ai construit une **plateforme d'automatisation complète** — pas juste des tests, mais tout l'écosystème autour. Je vais résumer en 5 axes.*

***Le framework de test lui-même***

*J'ai écrit l'intégralité du code pour **Android**, **Windows et iOS**, et aujourd'hui on a ~350 tests automatisés, exécutés sur 4 OS — Windows, Android, iPhone et iPad.*

*La couverture va bien au-delà des tests de certification qui sont obligatoire pour ce genre d’application de santé
(on couvre la facturation, les prescriptions, le planning, les cumuls de majorations, les remplaçants, les rétrocessions, la roadmap, les rendez-vous patients, les fuites mémoire, la vérification de PDF).
C'est du Robot Framework + Appium + Python, avec une bibliothèque Python structurée par domaines — une vraie lib, avec des sous-modules pour chaque OS et chaque fonctionnalité. Des fichiers de ressources et des fichiers d’object model.*

***L'application de pilotage (RF-EM)** Pour gérer tout ça*

*J'ai développé une application complète : un **backend Flask** avec 7 blueprints d'API REST et **11 domaines de services** (campagnes, exécution, reporting, tags, versioning, orchestration, performance, configuration, devices, documentation…), plus un **frontend React** avec 42 pages. 
**Ça permet à n'importe qui dans l'équipe de sélectionner des tests, configurer l'environnement, lancer une exécution, suivre le résultat en temps réel — sans toucher à une ligne de commande.** 
J'ai ajouté un wizard de configuration, un mode campagne de test avec suivi de progression par OS, et un écran de monitoring des bancs de test.*

***3 — Les bancs de test et le pilotage multi-machines** J'ai mis en place un banc de **6 machines** — 3 PC Windows, 1 pour Android, 2 Mac (iPhone + iPad) — avec un système d'**orchestration multi-bancs** : depuis mon poste, je vois l'état de chaque machine en temps réel, je peux synchroniser la config, déployer et lancer des tests à distance, en parallèle sur les 4 OS simultanément. Résultat : **la validation d'une release est passée de quasi une semaine à 24-36h**. a été divisé par 5 tout en augmentant la couverture des tests.*

***4 — La chaîne CI/CD et le reporting** J'ai mis en place un pipeline CI via Concourse qui exécute les tests automatiquement sur develop, rc et master. Les résultats remontent dans **Allure TestOps** et **ELK** (Elasticsearch/Kibana). J'ai aussi le re-run automatique des tests échoués avec merge des résultats — on priorise l'analyse sur les tests qui échouent 2 fois de suite. Et j'ai monté un site interne qui centralise les rapports.*

***5 — L'injection API et la gestion des environnements** Plus récemment, j'ai développé un système d'injection de données via l'API de l'application. Au lieu de passer 3-4 minutes à créer un patient, une prescription et une planification via l'UI, ça se fait en 10 secondes par API. C'est un module Python complet : les données de test sont en YAML, une couche de mapping les transforme en payloads API, et des domaines métier gèrent la logique (patient, AMO, AMC, prescription, planification, CVV…). En parallèle, j'ai revu la gestion des environnements pour pouvoir tester sur n'importe lequel des ~20 environnements disponibles dans le registre Nexus — y compris les branches de dev — ce qui permet de distinguer rapidement les problèmes d'environnement des vrais bugs applicatifs."*