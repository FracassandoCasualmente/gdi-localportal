# Local portal: a Proof of Concept implementation

Repository is holding the `docker-compose` environment that configures from scratch the
 - `Localportal` (Molgenis) - to hold the GDI metadata, exposed via various interfaces: web page, FDP, Beacon
 - `REMS` from vanilla environment - for Data access requests, automatically from Localportal > Dataset
 - `Keycloak` - for a central AAI
 - and a `Postgres` instance holding all three databases

System requirements depends on OS, but usually docker host needs at least
 - 2 core and 3 gb or free memory (after OS) during build and spinup of instance
 - and approx. 2 GB of empty disk space for all the images with pre-populated data

Total image build time, spinup time, and the installation of services inside running instances is approx 5 minutes (depends on the system)

## Cloning repository and starting the services

Clone the repository and navigate to proof-of-concept branch

    $ git clone https://github.com/molgenis/gdi-localportal
    $ cd gdi-localportal

Add keycloak to /etc/hosts on the machine the docker compose is running, example

```
    127.0.0.1   localhirods-localost localhost.localdomain localhost4 localhost4.localdomain4 aai-mock keycloak postgres rems localportal
```

Spin up docker compose

    $ docker-compose up -d

(it takes about 4 min on 2 core / 8gb ram /


Ports exposed on the host machine are
 - 3000 rems
 - 5432 postgres
 - 8080 localportal
 - 9000 keycloak

## First use of the Localportal

navigate to Localportal 
 - [Localportal](http://localhost:8080/)
 - use right to site "Sign In" > you will be redirected to [keycloak](http://keycloak:9000)
   - the use username is "lportaluser" and the password "lportalpass"

 - go to [gdiportal](http://localhost:8080/gdiportal/) - it is already pre-populated with example data 
   - check the table [Dataset](http://localhost:8080/gdiportal/tables/#/Dataset)
   - this table's content get replicated to REMS
     - the fields `id` and `title` are automatically synchronized with REMS
   - select one of the Dataset entry and delete it (for example "B1MG-RD-files-ped")
   - create a new entry (click plus sign at the top of the table left of the "id" field), you can fill the following data
     - id: "fastq_samplesX"
     - title: "Assembly of sample fastq file's from the dataset X"
     - tick the checkbox GDI
     - click "Save Ddataset"

Let's navigate to REMS
 - [REMS catalogue](http://localhost:3000/catalogue)
 - click "Login" > your login will be automatically detected (since you just did it in the Localportal)
 - you should be able to see all the datasets except the "B1MG-RD-files-ped" that you deleted
 - the newly created "fastq_samplesX" is available, and it contains the link from REMS to the correct entry form at Localportal

navigate back to Localportal > gportal
    - [gportal](http://localhost:8080/gdiportal/gportal/#/)
docker compose exec localportal bash


where is stored waht
    postgres is permanent in ...

users per service

global shared environment

services are in /opt/{servicename} folders

# Local portal

localhost:8080 > signin
    lportaluser
    lportalpass

localhost:8080/apps/central/#/admin
    admin / admin

Logs for localportal
    docker-compose exec localportal /bin/bash
    localportal # cat /opt/localportal/install.log

# REMS

$ echo VERBOSE=2 >> /opt/rems/synchronization.config
$ /opt/rems/synchronization.sh


# Keycloak

keycloak:9000 (or localhost:9000) > Administration Console > admin:admin > switch realm from master to lportal
    > client > lportalclient >


# Postgres

the data is persistent across the restart of instance. In order to delete all the postgress data and start fresh

    $ sudo rm -rf postgres/psql_data/ ; mkdir postgres/psql_data/


# Shutting down

    $ docker compose down --rmi all -v                                  # shut down and remove all images and volumes
    $ sudo rm -rf postgres/psql_data/; mkdir postgres/psql_data/        # clean all the permanent postgres data
