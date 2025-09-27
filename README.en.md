# ORBAI Core — CAP + PostgreSQL Service

Version: 1.0.1  
Date: 2025-09-27  
Author: ORBAICODER
EVEYRTHING AI GENERATED, BE CAREFUL
---

This project is built on SAP CAP (Cloud Application Programming Model) with PostgreSQL, providing OData V4 services for Travel and Invoice management, including domains like projects, travel entries, invoices, and booking rules. Use the one-command startup script to quickly run and validate locally.

- Base URL (local example): http://localhost:4004
- Services: /travel (travel domain), /trbooking (booking rules domain)
- API details: see API_Documentation.md in repository root

## Table of Contents
- Tech Stack
- Repository Structure
- Quick Start
- Start & Common Scripts
- Environment Variables & Security
- API & Testing
- Deployment Suggestions
- FAQ
- License & Maintainer

## Tech Stack
- Node.js >= 18
- SAP CAP (@sap/cds 9.x)
- PostgreSQL (via @cap-js/postgres driver)
- Express + CORS (integrated in server.js)

## Repository Structure (excerpt)
- /db/schema.cds: domain model (entities mapped to existing PostgreSQL physical tables)
- /srv/*.cds, /srv/*.js: service definition & implementation
- /server.js: CAP bootstrap (.env loading, CORS, etc.)
- /start.sh: one-command starter (supports start/watch, profile, port; prints the effective port at startup)
- /API_Documentation.md: OData API descriptions
- /test_case.txt: verified Action/Function calls and samples
- /.cdsrc.json: CAP runtime configuration (requires/db, auth, etc.)
- /.env.example: environment variable template (copy to .env and fill actual values)

## Quick Start
1) Prepare Environment
- Install Node.js 18+ and npm
- Prepare an accessible PostgreSQL database (example DB name: ORBAICORE)

2) Install Dependencies
- npm ci or npm install

3) Configure Environment Variables
- Copy .env.example to .env and fill database info (PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE)
- For production, set BASIC_ADMIN_PASSWORD and BASIC_VIEWER_PASSWORD (used by server.js for Basic auth)

4) Start Service (choose one)
- With script: ./start.sh start --profile development --port 4004
- Dev/watch: ./start.sh watch --profile development --port 4004

> Tip: start.sh auto-loads .env; port is adjustable. If not set, default is 4004 and the effective port will be printed in logs.

## Start & Common Scripts
- One-command script
  - ./start.sh start --profile production --port 4004
  - ./start.sh watch --profile development --port 4004
- npm scripts
  - npm run start (node server.js)
  - npm run serve (cds serve)
  - npm run build (cds build)
  - npm run deploy (cds deploy)
  - npm run dev (cds watch --with-mocks --in-memory)

### Three Ways to Change Port
- CLI args: ./start.sh start --port 5000 or ./start.sh watch --port 5000
- Environment variable: set PORT=5000 in .env or CI
- cds config: define port in .cdsrc.json "server" or related config (if enabled)

## Environment Variables & Security
- Do not commit .env; .gitignore excludes .env and other secret/generated files
- Recommended: use .env or CI/CD secrets to inject DB and auth credentials
- Consider moving any plain secrets from .cdsrc.json to environment variables (I can refactor upon request)

## API & Testing
- API docs: see API_Documentation.md (entities, actions, functions, sample curls)
- Verified test cases: see test_case.txt (successful ActionImports/FunctionImports calls)
- Metadata: /travel/$metadata, /trbooking/$metadata

Examples (local default port 4004):
- GET http://localhost:4004/travel/invoices
- POST http://localhost:4004/travel/createInvoice
- GET http://localhost:4004/trbooking/getbookingrule()

## Deployment Suggestions
- For production: start.sh start --profile production with production DB
- Use Basic auth (or integrate a stronger identity provider); inject passwords via environment variables
- Enable branch protection, PR review, required status checks on GitHub

## FAQ
- DB connection issues: verify PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE in .env; ensure DB instance is reachable
- 401/403: use mocked auth in development profile; in production set BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD or adopt stronger auth
- Port conflicts: specify another port via --port or PORT; startup logs show effective port

## License & Maintainer
- License: ISC (see package.json)
- Maintainer: ORBAICODER

---

## Step-by-Step Setup Guide

1) Prerequisites
- Node.js ≥ 18 & npm (nvm recommended)
- PostgreSQL (≥ 13) and psql client, or use Docker
- curl/Postman or VSCode REST Client for API tests

2) Database Setup
- Option A: Local PostgreSQL (psql)
  - Create DB and app user (replace placeholders, avoid hardcoding secrets)
    - CREATE DATABASE ORBAICORE;
    - CREATE USER app_user WITH PASSWORD '<YOUR_DB_PASSWORD>';
    - GRANT ALL PRIVILEGES ON DATABASE ORBAICORE TO app_user;
- Option B: Docker quick start (example)
  - docker run --name orbaicore-postgres -e POSTGRES_PASSWORD=<YOUR_DB_PASSWORD> -e POSTGRES_DB=ORBAICORE -p 8579:5432 -d postgres:16
  - Note: port mapping 8579→5432 is just an example; adjust as needed. Do not hardcode passwords in the repo.

3) Environment Variables
- Copy .env.example to .env and fill real values (examples below; replace with yours)
  - PGHOST=localhost
  - PGPORT=8579
  - PGUSER=app_user
  - PGPASSWORD=<YOUR_DB_PASSWORD>
  - PGDATABASE=ORBAICORE
  - PORT=4004
  - BASIC_ADMIN_PASSWORD=<SET_IN_PRODUCTION>
  - BASIC_VIEWER_PASSWORD=<SET_IN_PRODUCTION>
- Development uses mocked auth (.cdsrc.json); production recommends Basic with env-injected secrets.

4) Install Dependencies
- npm ci (preferred) or npm install

5) Initialize Structure & Sample Data (optional)
- Option A: Use CAP deployment (for new DB/prototyping)
  - npm run deploy (or cds deploy)
- Option B: Import repository CSV samples (demo covering projects, booking rules, travel entries, invoices)
  - psql import examples (ensure local CSV paths; mind paths/quotes on Windows):
    - \COPY public.a_tr_cn_t_project(projectid,customerid,description) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_project.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_c_bookingrule(code,description,textelementapp,textelementid) FROM 'backups/postgres/2025-09-27/a_tr_cn_c_bookingrule.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_travelentry(travelid,userid,fromdate,todate,destination,projectid) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_travelentry.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_invoices(invoiceno,travelid,userid,invoicedate,totalnetamount,taxamount,grossamount,bookingcode) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_invoices.csv' WITH (FORMAT csv, HEADER true)

6) Start Service
- Script (recommended):
  - ./start.sh start --profile development --port 4004
  - ./start.sh watch --profile development --port 4004
- Or via npm:
  - npm run start (node server.js)
  - npm run serve (cds serve)

7) Validate & Test
- Metadata:
  - GET http://localhost:4004/travel/$metadata
  - GET http://localhost:4004/trbooking/$metadata
- Read/Write examples:
  - GET http://localhost:4004/travel/invoices?$top=3
  - POST http://localhost:4004/travel/createInvoice (see sample body in API_Documentation.md)
  - GET http://localhost:4004/trbooking/getbookingrule()
- Recommendation: Use Postman/VSCode REST Client with samples from API_Documentation.md, or curl directly.

8) Troubleshooting
- DB connectivity: check PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE in .env; ensure DB and firewall are reachable
- 401/403: use mocked auth in development; in production set BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD or switch to stronger auth
- Port conflicts: change with --port or PORT; effective port is printed at startup

9) Production Notes
- Use ./start.sh start --profile production and provide production-grade DB and auth
- Keep secrets in environment variables or a secret manager; avoid plain text in configs
- On GitHub, enable branch protection, PR reviews, and required checks

10) References
- API docs: API_Documentation.md in root
- Sample backup data: backups/postgres/2025-09-27/ (CSV for four tables)
