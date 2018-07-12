# emu-cloud

**This repository is in alpha stage.**

The EMU Speech Database Management System is built for analyzing research data in phonetics (or more broadly, linguistics). This repository contains all components necessary to run the EMU-SDMS in a private cloud (e.g. to be hosted by a university) using Docker.

In this repository, you will find

- Dockerfiles to build images for the EMU-SDMS components
- a docker-compose.yml that helps you run the EMU-SDMS components along with third-party software (Keycloak, PostgreSQL)
- configuration files for the docker-compose setup

## Installation

**Work in progress**

This is a step-by-step guide for installing the proposed setup (which includes Keycloak and PostgreSQL). It is possible to swap individual components, e.g. use a database server that you are running already instead of starting a new Postgres instance, but this is not covered in this guide.

1. Clone this repository
2. Adjust the configuration:
   1. Change default passwords in docker-compose.yml: KEYCLOAK\_PASSWORD and POSTGRES\_PASSWORD
   2. (Optional) If you don't like the default storage location /var/emu-cloud, change all instances of it in docker-compose.yml
   3. (Optional) If you don't like the default ports 6500, 6510, 6520 and 17890, change them in docker-compose.yml
   4. In config/emudb-manager.config.php,
      1. in $openIdUserinfoEndpoint, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
      2. change $dbPassword to the POSTGRES\_PASSWORD you set in step 2.1
   5. In config/websocket\_server\_config.json, in openIdConnect.openIdProvider, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
   6. (Optional) In manager-api/Dockerfile, in git config user.email, adjust the mail address (which will appear in git commits made by the system).
   7. In manager-frontend/app.config.ts,
      1. in openIdConnect.providerurl, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
      2. in urls.managerAPIBackend, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
3. Run ```docker-compose up```
