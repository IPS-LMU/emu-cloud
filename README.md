# emu-cloud

**This repository is in beta stage.**

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
   1. Change default passwords in ```docker-compose.yml```: ```KEYCLOAK\_PASSWORD``` and ```POSTGRES\_PASSWORD``` (also set ```DB\_PASSWORD``` in the keycloack section to the value of ```POSTGRES\_PASSWORD```)
   2. (Optional) If you don't like the default storage location ```/var/emu-cloud```, change all instances of it in ```docker-compose.yml```
   3. (Optional) If you don't like the default ports 5432, 6500, 6510, 6520 and 17890, change them in ```docker-compose.yml```
   4. In ```config/emudb-manager.config.php```,
      1. in ```$openIdUserinfoEndpoint```, change example.com to the host name of your server (adjust the port if you changed it in step 2.3),
      2. change ```$dbPassword``` to the ```POSTGRES\_PASSWORD``` you set in step 2.1,
      3. adjust ```$dbHost``` to database:xxxx if you changed the port in step 2.3), *@todo: not sure if this would work*
      4. there is no need to change host name in ```$dbHost```, as Docker will make sure the database server has the DNS alias ```database``` (within the network of Docker containers).
   5. In ```config/websocket\_server\_config.json```, in ```openIdConnect.openIdProvider```, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
   6. (Optional) In ```manager-api/Dockerfile```, in git config user.email, adjust the mail address (which will appear in git commits made by the system).
   7. In ```manager-frontend/app.config.ts```,
      1. in ```openIdConnect.providerurl```, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
      2. in ```urls.managerAPIBackend```, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
      3. in ```urls.nodeJSServer```, change example.com to the host name of your server (adjust the port if you changed it in step 2.3).
3. Run ```docker-compose up``` (prepend ```sudo``` if appropriate for your system). This will download, install, and compile some stuff. Expect it to take around five minutes.

You are now at a point where your server runs:

- The emuDB-Manager frontend on port 6500
- The emuDB-Manager backend on port 6510
- The EMU-SDMS WebSocket server on port 17890
- Keycloak on port 6520
- PostgreSQL on port 5432

**Note that none of the services is currently protected with TLS, which is unacceptable for production operations.**

If you already had a publicly reachable web server, you could now set up your web server to act as a gateway. This way, you do not need to open up all of these ports in your firewall (NB: the PostgreSQL does not need to be publicly reachable, but all other components do). Also, this might be the easiest way to have the services TLS-encrypted (if your web server has a TLS certificate already).

Note that if you do put the services behind a gateway, you will need to adjust the configuration files again. *@todo: I think what you need to do is - when the services try to talk to each other, they need to address port 80/443 instead of their real port and of course the URLs change to what you set up in your gateway.*

*@todo: not sure if the WebSocket server can be put behind a gateway server can be put behind a gateway*

The next steps will be to feed some initial data into your new services:

1. Configure Keycloak
   1. Keycloak will refuse any non-encrypted connections. For production purposes, this is good, but for testing purposes, change it like this:
      1. You need to connect to the database server. If you have ```psql``` (the PostgreSQL client) installed on a machine that can access port 5432 on your server, you can use that: ```psql  -h hostname-of-your-server -U database-user emu```
      2. Otherwise, you can run this on your server: ```docker run -it --rm postgres psql -h hostname-of-your-server -U database-user emu``` (which will fire up a temporary instance of the psql client. NB you cannot use localhost as the hostname here.)
      3. ```update realm set ssl_required='NONE' where id='master';```
   2. Open up Keycloak at ```http://hostname-of-your-server:6520``` and log into the administration console as ```keycloakadmin``` (you have set the password in ```docker-compose.yml```).
   3. In the clients menu, import a new client (click “Create” and use the import option) using the file in ```initial-setup/emudb-manager.json``` (but first replace all instances of example.com in that file with the host name of your server)
   4. Add a user account for testing and name it ```scientist1```.
2. In the Postgres database server, import the dump from ```initial-setup/emu.sql```. This creates the two tables ```emu.permissions``` and ```emu.projects```, adding the project ```test-project``` and permitting the user ```scientist1``` to access it. The user name is part of the dump. If you add more users, the names have to match the names of Keycloak accounts.
   1. You can do the import by running this on your server: ```docker run -v ${PWD}/initial-setup/emu.sql:/emu.sql -it --rm postgres psql -h HOSTNAME-OF-YOUR-SERVER -U database-user emu -f /emu.sql``` (which will fire up a temporary docker container with only the psql in it and the dump file mounted as ```/emu.sql``` inside the container, such that the argument ```-f /emu.sql``` can be understood by psql).
   2. If you have psql installed on your server, you can simply run ```psql -h localhost -U database-user emu < initial-setup/emu.sql```.
3. In ```/var/emu-cloud/emuDBs```, create a directory ```test-project``` with the subdirectories ```databases```, ```downloads```, and ```uploads```.

You should now be able to visit ```http://yourservershostname.com:6500```. This is the address of the emuDB-Manager frontend, which will redirect you to Keycloak, where you can log in using the ```scientist1``` account. After logging in, you will be redirected back to the emuDB-Manager, where you can choose a project. The list should consist of only one entry, ```test-project```. Choose it and see if you can proceed without errors.

### Known Problems

The websocket server tries to “discover” Keycloak at startup time. However, they both start at virtually the same time, so discovery will fail. Try restarting the websocket server when everything is running already (```(sudo) docker container restart emucloud_websocket-protocol_1```).

If you get to the project list menu in the emuDB Manager but the list is empty, try opening up Keycloak at ```http://hostname-of-your-server:6520``` and siging out from the ```keycloakadmin``` account. Then reload the manager.

When you click the EMU-webApp button in emuDB-Manager before you properly set up TLS/HTTPS, you will receive a misleading error message from EMU-webApp. This is because the EMU-webApp is loaded over HTTPS and then tries to make a WebSocket connection to a non-TLS server, which has been disabled by browser vendors. Do not acknowledged the error dialog, just change the URL from HTTPS to HTTP. This is of course never advisable for production usage.
