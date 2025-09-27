# ORBAI Core — CAP + PostgreSQL Dienst

Version: 1.0.1
Datum: 2025-09-27
Autor: ORBAICODER
ALLE INHALTE VON KI GENERIERT, BITTE SORGFÄLTIG PRÜFEN
---

Dieses Projekt basiert auf SAP CAP (Cloud Application Programming Model) mit PostgreSQL und stellt OData-V4-Services für Reise- und Rechnungsmanagement bereit. Es umfasst Domänen wie Projekte, Reiseeinträge, Rechnungen und Buchungsregeln. Mit dem Ein-Klick-Startskript kannst du den Service lokal schnell starten und überprüfen.

- Basis-URL (lokales Beispiel): http://localhost:4004
- Services: /travel (Reisedomäne), /trbooking (Buchungsregel-Domäne)
- API-Details: Siehe API_Documentation.md im Repository-Stamm

## Inhaltsverzeichnis
- Technologiestack
- Repository-Struktur
- Schnellstart
- Start & gängige Skripte
- Umgebungsvariablen & Sicherheit
- API & Tests
- Deployment-Empfehlungen
- FAQ
- Lizenz & Maintainer

## Technologiestack
- Node.js >= 18
- SAP CAP (@sap/cds 9.x)
- PostgreSQL (über den Treiber @cap-js/postgres)
- Express + CORS (in server.js integriert)

## Repository-Struktur (Auszug)
- /db/schema.cds: Domänenmodell (Entitäten auf vorhandene PostgreSQL-Tabellen gemappt)
- /srv/*.cds, /srv/*.js: Service-Definition und Implementierung
- /server.js: CAP-Bootstrap (.env-Laden, CORS usw.)
- /start.sh: Ein-Klick-Starter (unterstützt start/watch, Profile, Port; gibt den effektiven Port beim Start aus)
- /API_Documentation.md: OData-API-Beschreibungen
- /test_case.txt: Verifizierte Action-/Function-Aufrufe und Beispiele
- /.cdsrc.json: CAP-Laufzeitkonfiguration (requires/db, Authentifizierung usw.)
- /.env.example: Vorlage für Umgebungsvariablen (als .env kopieren und mit echten Werten füllen)

## Schnellstart
1) Umgebung vorbereiten
- Node.js 18+ und npm installieren
- Eine erreichbare PostgreSQL-Datenbank bereitstellen (Beispielname: ORBAICORE)

2) Abhängigkeiten installieren
- npm ci oder npm install

3) Umgebungsvariablen konfigurieren
- .env.example nach .env kopieren und Datenbankinformationen eintragen (PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE)
- Für Produktion BASIC_ADMIN_PASSWORD und BASIC_VIEWER_PASSWORD setzen (für Basic Auth in server.js)

4) Service starten (eine Option wählen)
- Mit Skript: ./start.sh start --profile development --port 4004
- Entwicklung/watch: ./start.sh watch --profile development --port 4004

> Tipp: start.sh lädt .env automatisch; der Port ist anpassbar. Ohne Angabe wird 4004 verwendet und im Log ausgegeben.

## Start & gängige Skripte
- Ein-Klick-Skript
  - ./start.sh start --profile production --port 4004
  - ./start.sh watch --profile development --port 4004
- npm-Skripte
  - npm run start (node server.js)
  - npm run serve (cds serve)
  - npm run build (cds build)
  - npm run deploy (cds deploy)
  - npm run dev (cds watch --with-mocks --in-memory)

### Drei Wege, den Port zu ändern
- CLI-Parameter: ./start.sh start --port 5000 oder ./start.sh watch --port 5000
- Umgebungsvariable: PORT=5000 in .env oder CI setzen
- cds-Konfiguration: Port in .cdsrc.json "server" oder entsprechender Einstellung definieren (falls aktiv)

## Umgebungsvariablen & Sicherheit
- .env nicht committen; .gitignore schließt .env und andere sensible/generierte Dateien aus
- Empfehlung: .env oder CI/CD-Secrets zur Übergabe von DB- und Auth-Daten nutzen
- Erwäge, Klartext-Geheimnisse aus .cdsrc.json in Umgebungsvariablen zu verschieben (Refactoring auf Anfrage möglich)

## API & Tests
- API-Dokumentation: siehe API_Documentation.md (Entitäten, Aktionen, Funktionen, Beispiel-curl)
- Verifizierte Testfälle: siehe test_case.txt (erfolgreiche ActionImports/FunctionImports)
- Metadaten: /travel/$metadata, /trbooking/$metadata

Beispiele (lokaler Standardport 4004):
- GET http://localhost:4004/travel/invoices
- POST http://localhost:4004/travel/createInvoice
- GET http://localhost:4004/trbooking/getbookingrule()

## Deployment-Empfehlungen
- Produktion: ./start.sh start --profile production und Produktionsdatenbank konfigurieren
- Basic Auth nutzen (oder stärkeres Identity-System integrieren); Passwörter per Umgebungsvariablen injizieren
- Branch-Schutz, PR-Review und erforderliche Statusprüfungen in GitHub aktivieren

## FAQ
- Datenbankverbindung schlägt fehl: PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE in .env prüfen; Erreichbarkeit der DB sicherstellen
- 401/403: In Produktionsprofil BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD setzen oder auf Entwicklungsprofil mit Mock-Auth wechseln
- Portkonflikt: Alternativen Port mit --port (z.B. 5886) wählen

## Lizenz & Maintainer
- Lizenz: ISC (siehe package.json)
- Maintainer: ORBAICODER

---

## Schritt-für-Schritt-Einrichtungsanleitung

1) Voraussetzungen
- Node.js ≥ 18 & npm (nvm empfohlen)
- PostgreSQL (≥ 13) und psql-Client oder Docker
- curl/Postman oder VSCode REST Client für API-Tests

2) Datenbank einrichten
- Option A: Lokales PostgreSQL (psql)
  - Datenbank und App-Benutzer anlegen (Platzhalter ersetzen, keine Klartext-Passwörter im Repo)
    - CREATE DATABASE ORBAICORE;
    - CREATE USER app_user WITH PASSWORD '<DEIN_DB_PASSWORT>';
    - GRANT ALL PRIVILEGES ON DATABASE ORBAICORE TO app_user;
- Option B: Docker-Schnellstart (Beispiel)
  - docker run --name orbaicore-postgres -e POSTGRES_PASSWORD=<DEIN_DB_PASSWORT> -e POSTGRES_DB=ORBAICORE -p 8579:5432 -d postgres:16
  - Hinweis: Portweiterleitung 8579→5432 ist ein Beispiel; bei Bedarf anpassen. Passwörter nicht im Repo hardcoden.

3) Umgebungsvariablen
- .env.example nach .env kopieren und reale Werte einsetzen (Beispiel unten, mit eigenen Werten ersetzen)
  - PGHOST=localhost
  - PGPORT=8579
  - PGUSER=app_user
  - PGPASSWORD=<DEIN_DB_PASSWORT>
  - PGDATABASE=ORBAICORE
  - PORT=4004
  - BASIC_ADMIN_PASSWORD=<IN_PRODUKTION_SETZEN>
  - BASIC_VIEWER_PASSWORD=<IN_PRODUKTION_SETZEN>
- Entwicklung nutzt Mock-Auth (.cdsrc.json); Produktion empfiehlt Basic Auth mit via Umgebungsvariablen injizierten Secrets.

4) Abhängigkeiten installieren
- npm ci (bevorzugt) oder npm install

5) Struktur & Beispieldaten initialisieren (optional)
- Option A: CAP-Deployment (für neue DB/Prototyping)
  - npm run deploy (oder cds deploy)
- Option B: Repository-CSV-Beispiele importieren (Demo für Projekte, Buchungsregeln, Reiseeinträge, Rechnungen)
  - psql-Importbeispiele (lokale CSV-Pfade sicherstellen; Pfade/Anführungen unter Windows beachten):
    - \COPY public.a_tr_cn_t_project(projectid,customerid,description) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_project.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_c_bookingrule(code,description,textelementapp,textelementid) FROM 'backups/postgres/2025-09-27/a_tr_cn_c_bookingrule.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_travelentry(travelid,userid,fromdate,todate,destination,projectid) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_travelentry.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_invoices(invoiceno,travelid,userid,invoicedate,totalnetamount,taxamount,grossamount,bookingcode) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_invoices.csv' WITH (FORMAT csv, HEADER true)

6) Service starten
- Skript (empfohlen):
  - ./start.sh start --profile development --port 4004
  - ./start.sh watch --profile development --port 4004
- Oder via npm:
  - npm run start (node server.js)
  - npm run serve (cds serve)

7) Validieren & Testen
- Metadaten:
  - GET http://localhost:4004/travel/$metadata
  - GET http://localhost:4004/trbooking/$metadata
- Lese-/Schreibbeispiele:
  - GET http://localhost:4004/travel/invoices?$top=3
  - POST http://localhost:4004/travel/createInvoice (Beispiel-Body in API_Documentation.md)
  - GET http://localhost:4004/trbooking/getbookingrule()
- Empfehlung: Postman/VSCode REST Client mit Beispielen aus API_Documentation.md nutzen oder curl direkt.

8) Fehlerbehebung
- DB-Konnektivität: PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE in .env prüfen; Erreichbarkeit von DB und Firewall sicherstellen
- 401/403: In der Entwicklung Mock-Auth nutzen; in Produktion BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD setzen oder stärkere Auth wählen
- Portkonflikte: Mit --port oder PORT ändern; effektiver Port wird beim Start angezeigt

9) Produktionstipps
- ./start.sh start --profile production verwenden und produktionsreife DB & Auth bereitstellen
- Secrets in Umgebungsvariablen oder Secret-Manager speichern; Klartext in Konfigurationen vermeiden
- In GitHub Branch-Schutz, PR-Reviews und erforderliche Checks aktivieren

10) Referenzen
- API-Dokumentation: API_Documentation.md im Root
- Beispiel-Backups: backups/postgres/2025-09-27/ (CSV für vier Tabellen)
