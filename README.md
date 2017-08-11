# emu-cloud

**This repository is in alpha stage.**

The EMU Speech Database Management System is built for analyzing research data in phonetics (or more broadly, linguistics). This repository contains all components necessary to run the EMU-SDMS in a private cloud (e.g. to be hosted by a university) using Docker.

This will include three Docker images:

- The backend for the EMU-webApp WebSocket protocol
- The backend for the emuDB Manager API
- git-http-backend

The repository also includes a sample ```docker-compose.yml``` that may be used to install all images at once, making sure they share the same data area.
