# ORBAI Core — Service CAP + PostgreSQL

Version : 1.0.1
Date : 2025-09-27
Auteur : ORBAICODER
TOUT CONTENU EST GÉNÉRÉ PAR IA, UTILISATION À VOS RISQUES
---

Ce projet s'appuie sur SAP CAP (Cloud Application Programming Model) avec PostgreSQL pour fournir des services OData V4 dédiés à la gestion des voyages et des factures, couvrant des domaines comme les projets, les entrées de voyage, les factures et les règles de comptabilisation. Un script de démarrage en une commande permet de lancer et valider rapidement l'environnement local.

- URL de base (exemple local) : http://localhost:4004
- Services : /travel (domaine voyage), /trbooking (domaine règles de comptabilisation)
- Détails de l'API : consulter API_Documentation.md à la racine du dépôt

## Table des matières
- Pile technologique
- Structure du dépôt
- Démarrage rapide
- Démarrage & scripts usuels
- Variables d'environnement & sécurité
- API & tests
- Conseils de déploiement
- FAQ
- Licence & mainteneur

## Pile technologique
- Node.js >= 18
- SAP CAP (@sap/cds 9.x)
- PostgreSQL (pilote @cap-js/postgres)
- Express + CORS (intégré dans server.js)

## Structure du dépôt (extrait)
- /db/schema.cds : modèle de domaine (entités reliées aux tables physiques PostgreSQL existantes)
- /srv/*.cds, /srv/*.js : définition et implémentation des services
- /server.js : bootstrap CAP (chargement .env, CORS, etc.)
- /start.sh : démarrage en une commande (supporte start/watch, profile, port ; affiche le port effectif au lancement)
- /API_Documentation.md : description des API OData
- /test_case.txt : appels Action/Function vérifiés avec exemples
- /.cdsrc.json : configuration d'exécution CAP (requires/db, authentification, etc.)
- /.env.example : modèle de variables d'environnement (copier vers .env puis renseigner les valeurs réelles)

## Démarrage rapide
1) Préparer l'environnement
- Installer Node.js 18+ et npm
- Préparer une base PostgreSQL accessible (exemple : ORBAICORE)

2) Installer les dépendances
- npm ci ou npm install

3) Configurer les variables d'environnement
- Copier .env.example vers .env et renseigner les informations DB (PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE)
- En production, définir BASIC_ADMIN_PASSWORD et BASIC_VIEWER_PASSWORD (injectés par server.js pour l'authentification Basic)

4) Lancer le service (choisir une option)
- Via script : ./start.sh start --profile development --port 4004
- Mode dev/watch : ./start.sh watch --profile development --port 4004

> Astuce : start.sh charge automatiquement .env ; le port est personnalisable. Sans valeur fournie, 4004 est utilisé et indiqué dans les logs.

## Démarrage & scripts usuels
- Script tout-en-un
  - ./start.sh start --profile production --port 4004
  - ./start.sh watch --profile development --port 4004
- Scripts npm
  - npm run start (node server.js)
  - npm run serve (cds serve)
  - npm run build (cds build)
  - npm run deploy (cds deploy)
  - npm run dev (cds watch --with-mocks --in-memory)

### Trois manières de changer le port
- Paramètres CLI : ./start.sh start --port 5000 ou ./start.sh watch --port 5000
- Variable d'environnement : définir PORT=5000 dans .env ou en CI
- Configuration cds : définir le port dans "server" de .cdsrc.json (si activé)

## Variables d'environnement & sécurité
- Ne pas committer .env ; .gitignore exclut .env et les fichiers sensibles/générés
- Recommandation : utiliser .env ou les secrets CI/CD pour injecter les identifiants DB et auth
- Envisager de déplacer tout secret en clair de .cdsrc.json vers des variables d'environnement (refactoring possible sur demande)

## API & tests
- Documentation API : voir API_Documentation.md (entités, actions, fonctions, exemples curl)
- Cas de test validés : voir test_case.txt (ActionImports/FunctionImports réussis)
- Métadonnées : /travel/$metadata, /trbooking/$metadata

Exemples (port local par défaut 4004) :
- GET http://localhost:4004/travel/invoices
- POST http://localhost:4004/travel/createInvoice
- GET http://localhost:4004/trbooking/getbookingrule()

## Conseils de déploiement
- Production : ./start.sh start --profile production avec base de données de production
- Utiliser l'authentification Basic (ou un fournisseur plus robuste) ; injecter les mots de passe via variables d'environnement
- Activer la protection de branches, la revue de PR et les vérifications obligatoires sur GitHub

## FAQ
- Connexion DB échouée : vérifier PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE dans .env ; confirmer l'accessibilité de la base
- 401/403 : en production, définir BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD ou basculer sur le profil développement (auth mockée)
- Conflits de port : spécifier un autre port avec --port (ex. 5886)

## Licence & mainteneur
- Licence : ISC (voir package.json)
- Mainteneur : ORBAICODER

---

## Guide d'installation pas à pas

1) Prérequis
- Node.js ≥ 18 & npm (nvm recommandé)
- PostgreSQL (≥ 13) et client psql, ou Docker
- curl/Postman ou VSCode REST Client pour les tests API

2) Préparation de la base de données
- Option A : PostgreSQL local (psql)
  - Créer la base et l'utilisateur applicatif (remplacer les valeurs, ne pas conserver les mots de passe en clair)
    - CREATE DATABASE ORBAICORE;
    - CREATE USER app_user WITH PASSWORD '<MOT_DE_PASSE_DB>';
    - GRANT ALL PRIVILEGES ON DATABASE ORBAICORE TO app_user;
- Option B : démarrage rapide Docker (exemple)
  - docker run --name orbaicore-postgres -e POSTGRES_PASSWORD=<MOT_DE_PASSE_DB> -e POSTGRES_DB=ORBAICORE -p 8579:5432 -d postgres:16
  - Remarque : l'exposition 8579→5432 est un exemple ; ajuster selon les besoins. Ne jamais hardcoder les mots de passe dans le dépôt.

3) Variables d'environnement
- Copier .env.example vers .env et remplir avec vos valeurs (exemple ci-dessous)
  - PGHOST=localhost
  - PGPORT=8579
  - PGUSER=app_user
  - PGPASSWORD=<MOT_DE_PASSE_DB>
  - PGDATABASE=ORBAICORE
  - PORT=4004
  - BASIC_ADMIN_PASSWORD=<DÉFINIR_EN_PRODUCTION>
  - BASIC_VIEWER_PASSWORD=<DÉFINIR_EN_PRODUCTION>
- Le profil développement utilise une authentification mockée (.cdsrc.json) ; en production, privilégier Basic avec secrets injectés.

4) Installer les dépendances
- npm ci (recommandé) ou npm install

5) Initialiser la structure & les données d'exemple (optionnel)
- Option A : déploiement CAP (pour nouvelle base/prototypage)
  - npm run deploy (ou cds deploy)
- Option B : importer les CSV d'exemple du dépôt (projets, règles de comptabilisation, voyages, factures)
  - Exemples d'import psql (vérifier les chemins locaux ; attention aux chemins/quotes sous Windows) :
    - \COPY public.a_tr_cn_t_project(projectid,customerid,description) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_project.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_c_bookingrule(code,description,textelementapp,textelementid) FROM 'backups/postgres/2025-09-27/a_tr_cn_c_bookingrule.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_travelentry(travelid,userid,fromdate,todate,destination,projectid) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_travelentry.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_invoices(invoiceno,travelid,userid,invoicedate,totalnetamount,taxamount,grossamount,bookingcode) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_invoices.csv' WITH (FORMAT csv, HEADER true)

6) Lancer le service
- Script (recommandé) :
  - ./start.sh start --profile development --port 4004
  - ./start.sh watch --profile development --port 4004
- Via npm :
  - npm run start (node server.js)
  - npm run serve (cds serve)

7) Vérifier & tester
- Métadonnées :
  - GET http://localhost:4004/travel/$metadata
  - GET http://localhost:4004/trbooking/$metadata
- Exemples lecture/écriture :
  - GET http://localhost:4004/travel/invoices?$top=3
  - POST http://localhost:4004/travel/createInvoice (corps d'exemple dans API_Documentation.md)
  - GET http://localhost:4004/trbooking/getbookingrule()
- Conseil : utiliser Postman/VSCode REST Client avec les exemples d'API_Documentation.md ou curl.

8) Dépannage
- Connexion DB : vérifier PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE dans .env ; confirmer l'accès réseau
- 401/403 : en dev utiliser l'auth mockée ; en production définir BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD ou passer à une auth plus robuste
- Conflits de port : modifier via --port ou PORT ; le port effectif est indiqué au démarrage

9) Notes pour la production
- Utiliser ./start.sh start --profile production et fournir une DB/identité adaptées
- Stocker les secrets dans des variables d'environnement ou un gestionnaire ; éviter le clair dans les configs
- Sur GitHub, activer protection de branches, revues de PR et vérifications obligatoires

10) Références
- Documentation API : API_Documentation.md à la racine
- Sauvegardes d'exemple : backups/postgres/2025-09-27/ (CSV pour quatre tables)
