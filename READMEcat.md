# Replica Set de 3 nodes de MongoDB amb docker-compose

- [Versión en castellano](README.md)
- [English version](READMEen.md)

En aquest mini projecte deixo com he muntat un Replica Set de MongoDB amb docker-compose.
Està inspirat en https://gist.github.com/harveyconnor/518e088bad23a273cae6ba7fc4643549, https://github.com/msound/localmongo i d'altres.

Només té d'especial respecte del que he trobat en diverses cerques que activa l'autenticació del Replica Set (--auth).

Característiques
----------------
Amb aquests fitxers podràs aixecar un Replica Set de 3 nodes de MongoDB 4.2.6 (imatge mongo:4.2.6-bionic) en 3 contenidors a la mateixa màquina. En el meu cas es tracta d'una màquina virtual amb Ubuntu 20.04 en un Virtual Box 6.1.6 sobre Windows 10 (he probat una mica Hyper-V i no m'ha acabat de convèncer. Quedarà per més endavant).

M'hagués agradat tenir totes les dades del Replica Set en arxius de Windows, però MongoDB requereix certes característiques de Linux. Així que a cada contenidor li comparteixo dos volums:
- Un propi de cada contenidor per les dades (/data/db)
- Un altre compartit entre tots els contenidors per la clau d'encriptació (/data/pki)

Més endavant compartiré un tercer per les còpies de seguretat. Vull que sigui una carpeta de Windows montada a la màquina virtual Linux i compartida com volum al contenidor on es facin les còpies de seguretat.


De tot el que he trobat buscant una solució similar, en cap cas s'activava l'autenticació. Fins i tot hi havia una issue al respecte, però he perdut la referència (serà una d'aquetes: https://github.com/docker-library/mongo/issues?q=is%3Aissue+is%3Aclosed+MONGO_INITDB_ROOT_USERNAME).

Així que si has caigut aquí, és probable que hagis vist ja d'altres solucions, amb números de ser millors. Però jo no vaig trobar una adaptada a les meves necessitats. Espero que et sigui d'utilitat.

Posada en marxa
---------------
Per crear el Replica Set només cal executar
~~~
MongoSetup.sh
~~~
Recorda adequar les rutes, l'usuari i la contrasenya al que necessitis abans d'executar-lo.

Un cop creat el Replica Set, només cal controlar-lo mitjançant docker-compose:
~~~
docker-compose stop
docker-compose start
~~~

