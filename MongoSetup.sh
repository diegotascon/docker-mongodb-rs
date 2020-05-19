#!/usr/bin/bash

# ES - Script de creación de un Replica Set de MongoDB con docker-compose
# CAT - Script de creació d'un Replica Set de MongoDB amb docker docker-compose
# EN - Script to create a MongoDB Replica Set with docker-compose

# ES - Se crean los directorios donde residirán los datos de los 3 nodos del Replica Set
# CAT- Es creen els directoris on s'ubicaran les dades dels 3 nodes del Replica Set
# EN - Creation of the directories where data of the 3 Replica Set nodes will be held
echo --------------------------------------------------------------------------
echo Preparando directorios para los nodos del ReplicaSet
sudo rm -fr /home/diego/LlevAPP/MongoDB/mongo1/data/
sudo rm -fr /home/diego/LlevAPP/MongoDB/mongo2/data/
sudo rm -fr /home/diego/LlevAPP/MongoDB/mongo3/data/
mkdir -p $HOME/LlevAPP/mongo1/data
mkdir -p $HOME/LlevAPP/mongo2/data
mkdir -p $HOME/LlevAPP/mongo3/data

# ES - Configuración de las copias de seguridad pendiente
# CAT - Configuració de les còpies de seguretat pendent
# EN - Backup configuration pending

# ES - Se programa el crontab de backup sobre el nodo mongo2
#      --archive permite escribir en stdout
# docker exec mongo2 sh -c 'exec mongodump --archive' > /home/diego/Formacion/20200512-LlevAPP/MongoDB/Backups

# ES - Se generan las claves para encriptar la comunicación entre los nodos del Replica Set
# CAT - Es generen les claus per encriptar la comunicació entre els nodes del Replica Set
# EN - Creating the keys to encrypt communications between the Replica Set nodes
echo --------------------------------------------------------------------------
echo Creando las claves de comunicación
sudo rm -fr /home/diego/LlevAPP/MongoDB/pki
sudo mkdir -p /home/diego/LlevAPP/MongoDB/pki
# ES - La redirección simple a stdout da error de permisos: no entra en el sudo.
#      Por ello ejecuto también la redirección bajo sudo mediante un sh -c:
sudo sh -c 'openssl rand -base64 741 > /home/diego/LlevAPP/MongoDB/pki/rs0-keyfile'

# ES - Imprescindible restringir los permisos. Si no se hace, mongod no se levanta
sudo chmod 400 /home/diego/LlevAPP/MongoDB/pki/rs0-keyfile

# ES - Se levanta por primera vez el Replica Set
# CAT - S'aixeca per primer cop el Replica Set
# EN - Starting up the Replica Set for the first time
echo --------------------------------------------------------------------------
echo Levantando el Replica Set
docker-compose up -d

# ES - Se inicia el Replica Set. Se dejan unos segundos desde que se levantan
#      los contenedores para dar tiempo a que mongod abra el puerto
# CAT - S'inicia el Replica Set. Es deixen uns segons des de que s'aixequen els
#       contenidors per donar temps a mongod a obrir el port
# EN - The Replica Set gets initiated. Some seconds are waited from the start of
#      containers to let mongod open then port
echo --------------------------------------------------------------------------
echo Iniciando el Replica Set en el primer nodo
sleep 5
docker container exec mongo1 mongo --port 27017 --eval '
rs.initiate()
'

# ES - Se añade el usuario root en el primer nodo
# CAT - S'afegeix l'usuari root al primer node
# EN - root user is created on the first node
echo --------------------------------------------------------------------------
echo Anyadiendo usuario root en el primer nodo - espero unos segundos
sleep 5
docker container exec mongo1 mongo --port 27017 --eval '
db = db.getSiblingDB("admin")
db.createUser({user:"root", pwd:"mongopass", roles:[{role:"root", db:"admin"}]})
'

# ES - Se añaden el resto de nodos al Replica Set
# CAT - S'afegeixen la resta de nodes al Replica Set
# EN - The rest of the nodes are added to the Replica Set
echo --------------------------------------------------------------------------
echo Anyadiendo el resto de nodos al Replica Set
sleep 2
# ES - Se podría hacer en la ejecución anterior como db.auth("root", "mongopass"), pero
#      así se ve un ejemplo de cómo conectar con mongo
docker container exec mongo1 mongo --host 'rs0/mongo1:27017' -u root -p mongopass --eval '
rs.add("mongo2:27017")
rs.add("mongo3:27017")
'

# echo --------------------------------------------------------------------------
# echo Comprobaciones
# docker container exec -it mongo1 bash
