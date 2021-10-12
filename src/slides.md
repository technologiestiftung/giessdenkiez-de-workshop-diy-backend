<img src="./assets/images/logo.svg" width="800px">

* Building the Backend
* 20.10.2021

<aside class="notes">
Shhh, these are your private notes 📝
</aside>

---

## Fabian Morón Zirfas


* Senior Creative Technologist
* @Ideation & Prototyping Lab
* @Technologiestiftung Berlin

<aside class="notes">

Jack of all Trades Master of None.

Ganz offiziel bin ich Kommunikations Designer & Kaufmann, bin aber im Laufe meine
Karriere immer weiter in die Bereiche Dev Ops und Full Stack eingetaucht.

</aside>


# T.O.C.

* [Backend Überblick](#backend-überblick)
* [Software + Services](#vorraussetzungen)
* [Wo ist der Sourcecode?](#wo-ist-der-sourcecode)
* [Wie fange ich an?](#wie-fange-ich-an)
* [<s>Beispiel DB & API in 6 Schritten</s>](#beispiel-db-api-in-6-schritten)
* [Q & A](#q-a)


<aside class="notes">
Wenn ich zu schnell bin sagen sie mir Bescheid oder wenn ich etwas anders erklären soll.
Eine Diskussion können wir gerne im QA führen.

Die Präsentation finden Sie auch online hinter diesem Link.

https://technologiestiftung.github.io/giessdenkiez-de-workshop-diy-backend/

</aside>


# Backend Überblick

<aside class="notes">
Zuallerserst möchte ich einen Überblick über die Applikation im gesamten geben.
</aside>

---

![](https://raw.githubusercontent.com/wiki/technologiestiftung/giessdenkiez-de/assets/images/stack@2x.png)

<aside class="notes">
* User lädt die seite -> mapbox + S3
* User klickt Baum
* User erstellt Accout
* User adoptiert Baum
* User wässert Baum
* User löscht Account
* Täglich DWD
* Wöchentlich OSM
* Developer Push zu Repo Frontend + Backend
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

<aside class="notes">
Dies sind die Software tools die wir verwenden.
</aside>



## Wo ist der Sourcecode?



| Provider | Infrastruktur             | Repository (https://github.com/technologiestiftung/) |
| -------- | ------------------------- | ---------------------------------------------------- |
| Mapbox   | Karten                    |                                                      |
| Auth0    | Autentifiziereng          |                                                      |
| GitHub   | Versionskontrolle & CI/CD |                                                      |
| ~~AWS~~  | ~~Datenbank~~             | giessdenkiez-de-aws-rds-terraform                    |
| AWS      | Datei Speicherung         | giessdenkiez-de-aws-s3-terraform                     |
| DWD      | Regendaten                | giessdenkiez-de-dwd-harvester                        |
| OSM      | Wasserpumpendaten         | giessdenkiez-de-osm-pumpen-harvester                 |
| Vercel   | Backend Hosting           | tsb-trees-api-user-management                        |
| Vercel   | Backend Hosting           | giessdenkiez-de-postgres-api                         |
| Netlify  | Frontend Hosting          | giessdenkiez-de                                      |

<aside class="notes">
Dies sind die Software Tools die wir verwenden.
</aside>

# Wie fange ich an?

<aside class="notes">
Der beste Platz um zu starten ist unser Wiki im Hauptrepo. Wenn es trotzdem Unklarheiten geben sollte, könnt ihr uns GitHub Issues/Discussions schreiben.
</aside>

## [▶▶ ▶ Zum Wiki ▶ ▶▶](https://github.com/technologiestiftung/giessdenkiez-de/wiki)

# Beispiel DB & API in 6 Schritten

<aside class="notes">
Ich werde jetzt versuchen 2½ Komponenten der Applikation zu deployen. 

1. Die Datenbank
2. Die API
2 ½. Dem Auth0 Service

</aside>

## 🚨 Achtung 🚨 

Hier könnten Drachen hausen!

## 1. Datenbank Erzeugen

<aside class="notes">
Beginnen wir mit der Datenbank.
</aside>

## AWS oder nicht?


-------

<aside class="notes">
Aktuell läft unsere Datenbank auf AWS (wie ich breits erwähnt habe). Wir benutzen Terraform um AWS
irgendwie unter Kontrolle zu halten. Für euren Geistesfrieden, rate ich euch erstmal davon ab AWS zu nutzen.
</aside>

![](./assets/images/Down_the_Rabbit_Hole.png)

-------

## [Render.com](http://render.com)

<aside class="notes">
Was ist die Alternative? Der IMO aktuell einfachste Service ist render.com. Mit einem klick erhalten wir eine Datenbank.
</aside>

---

* Username
* Passwort
* Host
* Port
* Datenbank Name

<aside class="notes">
Folgende Variablen benötigen wir.
</aside>

---

## Als `postgresql` Connection String

<aside class="notes">
Wir benötigen die gleichen Variablen ebenfalls as connection string.
Ja. Das ist redundant und wir haben bereits ein Ticket dafür. GDK-137
</aside>

---

```bash
postgresql://[USER]:[PASSWORD]@[HOST]:[PORT]/[DATABASE]?schema=[SCHEMA]
```

---

## 2. Auth0.com API

<aside class="notes">
Das nächste was wir machen müssen ist unsere API in Auth0.com anlegen.
</aside>

---


* Audience
* Issuer
* JWKSUri


<aside class="notes">
Wir benötigen von dort die folgenden Informationen.
</aside>

## 3. Quellcode

<aside class="notes">
Nun können wir uns den Sourcecode für die API abholen.
</aside>

```bash
git clone https://github.com/technologiestiftung/giessdenkiez-de-postgres-api.git gdk-api
cd gdk-api
npm ci
```

## 3.1 Environment Variablen

```bash
cp .env.sample .env
```

<aside class="notes">
Zum testen schreiben wir uns unsere Variablen in die dotenv Datei. Diese Datei sollte NICHT in die
Versionskontrolle gehen. 
</aside>
---



in `.env`

```bash
 # this is for the local dev environmet
 port=5432
 user=fangorn
 database=trees
 password=ent
 host=localhost
 # this is for prisma - the pattern is
 # postgresql://USER:PASSWORD@HOST:PORT/DATABASE?schema=SCHEMA
 DATABASE_URL="postgresql://fangorn:ent@localhost:5432/trees?schema=public"
 # you will find these in auth0.com
 jwksuri=https://your-fancy-tenant.eu.auth0.com/.well-known/jwks.json
 audience=your-audience
 issuer=https://your-fancy-tenant.eu.auth0.com/
```


## 4. Tabellen & Daten

<aside class="notes">
Jetzt können wir unsere Datenbankschema aufsetzten und die DB mit test Daten befüllen.

</aside>

```bash
npx prisma db push --preview-feature --skip-generate
npx prisma db seed --preview-feature
```

## 5. Deploy

```bash
npx vercel
```

## 5.1 Environment Variablen

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

## 5.2 Deploy

```bash
npx vercel --prod
```


## 🚀


<aside class="notes">
Die API sollte jetzt deployed sein. Mit den URLs aus der Shell können wir das überprüfen.
</aside>


## 6. Test

```bash
code --install-extension humao.rest-client
code docs/api.http
```

<aside class="notes">
Wenn ihr VSCode benutzt könnt ihr mit dem Befehl oben eine Erweiterung 
installieren die es erlaubt HTTP requests direkt as dem Editor zu machen.
</aside>


## 6.1 Test Auth

<aside class="notes">
Um zu testen ob unsere Authentifizierung funktioniert müssen wir zurück zu Auth0
</aside>

## 6.1.1 Auth0 Application

<aside class="notes">
Mit dem erstelen der API wurde auch direkt eine Machine 2 Machine Applikation erstellt.
Diese können wir nutzen um tests gegen unsere API laufen zu lassen.
</aside>

## 6.1.2 Environment Variablen

in `.env`

```bash
# These can be obtained from Auth0 if you create a new machine to machine
# application that has access to your API
client_id=abc123
client_secret=abc123
```


## 6.1.3 Token holen


```bash
code docs/api.http
```

<aside class="notes">
Sobald die .env eingetragen sind können wir wieder mit dem rest client Anfragen stellen. Dafür brauchen wir einen token
</aside>

## 6.1.4 Authentifizierte Anfrage

in `.env`

```bash
# below varaibles are for testing the api only
# this token can be obtained by running the POST request to
# see docs/api.http for more info
# https://giessdenkiez.eu.auth0.com/oauth/token
token=a.b.c
```

# Q & A

<aside class="notes">
Ja das waren keine 6 Schritte.
</aside>

# Danke

für Ihre Aufmerksamkeit