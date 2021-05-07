---
title: Giessdenkiez.de
subtitle: Building the Backend
author: Fabian Morón Zirfas
date: 12.05.2021
---

<img src="./assets/images/logo.svg" width="800px">


<aside class="notes">
Shhh, these are your private notes 📝
</aside>


# Backend Überblick

<aside class="notes">
Zuallerserst möchte ich einen Überblick über die Applikation im gesamten geben.
</aside>

---

![](https://raw.githubusercontent.com/wiki/technologiestiftung/giessdenkiez-de/assets/images/stack@2x.png)

<aside class="notes">
User lädt die seite -> mapbox + S3
User klickt Baum
User erstellt Accout
User adoptiert Baum
User wässert Baum
User löscht Account

Täglich DWD
Wöchentlich OSM

Developer Pusht zu Repo Frontend + Backen
</aside>
---



## Vorraussetzungen

| Tool                                        | Kommentar                         |
| ------------------------------------------- | --------------------------------- |
| [nvm](https://github.com/nvm-sh/nvm)        | Verwaltung von Node.js Versionen  |
| [asdf](https://asdf-vm.com/#/)              | Verwaltung von CLI Versionen      |
| [Git](https://git-scm.com/)                 | Versionskontrolle                 |
| [Node.js](https://nodejs.org/en/)           | Ausführung                        |
| [AWS CLI](https://aws.amazon.com/cli/)      | Abhängigkeit für Terraform        |
| [Terraform](https://www.terraform.io/)      | Erzeugung von Infrastruktur       |
| [auth0.com](https://auth0.com/) Account     | Auth Provider                     |
| [vercel.com](https://vercel.com/) Account   | Hosting Provider                  |
| [netlify.com](https://netlify.com/) Account | Hosting Provider                  |
| [mapbox.com](https://mapbox.com/) Account   | Karten Provider                   |
| [AWS](https://aws.amazon.com/) Account      | DB und Datei Speicherung Provider |
| [GitHub](https://github.com) Account        | VCS + CI/CD                       |

## Wo ist der Sourcecode?

| Provider | Infrastruktur             | Repository (https://github.com/technologiestiftung/) |
| -------- | ------------------------- | ---------------------------------------------------- |
| Mapbox   | Karten                    |                                                      |
| Auth0    | Autentifiziereng          |                                                      |
| GitHub   | Versionskontrolle & CI/CD |                                                      |
| AWS      | Datenbank                 | giessdenkiez-de-aws-rds-terraform                    |
| AWS      | Datei Speicherung         | giessdenkiez-de-aws-s3-terraform                     |
| DWD      | Regendaten                | giessdenkiez-de-dwd-harvester                        |
| OSM      | Wasserpumpendaten         | giessdenkiez-de-osm-pumpen-harvester                 |
| Vercel   | Backend Hosting           | tsb-trees-api-user-management                        |
| Vercel   | Backend Hosting           | giessdenkiez-de-postgres-api                         |
| Netlify  | Frontend Hosting          | giessdenkiez-de                                      |


# Wie fange ich an?

## [▶▶ ▶ Zum Wiki ▶ ▶▶](https://github.com/technologiestiftung/giessdenkiez-de/wiki)

# Beispiel DB & API

## 1. Datenbank Erzeugen

## AWS oder nicht?

-------

![](./assets/images/Down_the_Rabbit_Hole.png)

-------

## [Render.com](http://render.com)

---

* Username
* Passwort
* Host
* Port
* Datenbank Name

---

## Als Connection String

---

```bash
postgresql://[USER]:[PASSWORD]@[HOST]:[PORT]/[DATABASE]?schema=[SCHEMA]
```

---

## 2. Auth0.com API


---


* Audience
* Issuer
* JWKSUri

## 3. Quellcode

```bash
git clone https://github.com/technologiestiftung/giessdenkiez-de-postgres-api.git gdk-api
cd gdk-api
npm ci
```

## 3.1 Environment Variablen

```bash
cp .env.sample .env
```

---

in `.env`

```bash
 # this is for the local dev environmet
 port=5432
 user=fangorn
 database=trees
 password=ent
 host=localhost
 # this is for prisma the pattern is
 # postgresql://USER:PASSWORD@HOST:PORT/DATABASE?schema=SCHEMA
 DATABASE_URL="postgresql://fangorn:ent@localhost:5432/trees?schema=public"
 # you will find these in auth0.com
 jwksuri=https://your-fancy-tenant.eu.auth0.com/.well-known/jwks.json
 audience=your-audience
 issuer=https://your-fancy-tenant.eu.auth0.com/
```


## 3.2 Tabellen & Daten

```bash
npx prisma db push --preview-feature --skip-generate
npx prisma db seed --preview-feature
```

## 4. Deploy

```bash
npx vercel
```

## 4.1 Environment Variablen

```bash
# the user for the postgres db
npx vercel env add user
# the database name
npx vercel env add database
# the database password
npx vercel env add password
# the host of the db, aws? render.com? localhost?
npx vercel env add host
# defaults to 5432
npx vercel env add port
# below are all taken from auth0.com
npx vercel env add jwksuri
npx vercel env add audience
npx vercel env add issuer
```

## 4.2 Deploy 

## 🚀


<aside class="notes">
This should now be deployed. Check the URLs from the shell
</aside>


## 5. Test

```bash
code --install-extension humao.rest-client
code docs/api.http
```

<aside class="notes">
Wenn ihr VSCode benutzt könnt ihr mit dem Befehl oben eine Erweiterung 
installieren die es erlaubt HTTP requests direkt as dem Editor zu machen.
</aside>


## 5.1 Test Auth

<aside class="notes">
Um zu testen ob unsere Authentifizierung funktioniert müssen wir zurück zu Auth0
</aside>

## 5.1.1 Auth0 Application

<aside class="notes">
Mit dem erstelen der API wurde auch direkt eine Machine 2 Machine Applikation erstellt.
Diese können wir nutzen um tests gegen unsere API laufen zu lassen.
</aside>

## 5.1.2 Environment Variablen

in `.env`

```bash
# These can be obtained from Auth0 if you create a new machine to machine
# application that has access to your API
client_id=abc123
client_secret=abc123
```


## 5.1.3 Token holen


```bash
code docs/api.http
```

<aside class="notes">
Sobald die .env eingetragen sind können wir wieder mit dem rest client Anfragen stellen. Dafür brauchen wir einen token
</aside>

## 5.1.4 Authentifizierte Anfrage

in `.env`

```bash
# below varaibles are for testing the api only
# this token can be obtained by running the POST request to
# see docs/api.http for more info
# https://giessdenkiez.eu.auth0.com/oauth/token
token=a.b.c
```
