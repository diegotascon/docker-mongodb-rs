# Replica Set de 3 nodos de MongoDB con docker-compose

[Versió en català](READMEcat.md)
[English version](READMEen.md)

En este mini proyecto dejo cómo he montado un Replica Set de MongoDB usando docker-compose.
Está inspirado en https://gist.github.com/harveyconnor/518e088bad23a273cae6ba7fc4643549, https://github.com/msound/localmongo y otros.

Lo único que tiene de especial respecto a lo que he encontrado en varias búsquedas es que activa la autenticación del Replica Set (--auth).

Características
---------------
Con estos ficheros podrás levantar un Replica Set de 3 nodos de MongoDB 4.2.6 (imagen mongo:4.2.6-bionic) en 3 contenedores de la misma máquina. En mi caso se trata de una máquina virtual con Ubuntu 20.04 en un Virtual Box 6.1.6 sobre Windows 10 (lo poco que he probado de Hyper-V no me ha convencido. Quedará para más adelante).

Me hubiese gustado tener todos los datos en el sistema de archivos de Windows, pero MongoDB requiere ciertas características de Linux. Así que a cada contenedor le comparto dos volúmenes:
- Uno propio residente en la máquina virtual Linux para los datos (/data/db)
- Otro compartido también residente en la máquina virtual para la clave de encriptación (/data/pki)

Más adelante compartiré un tercero para las copias de seguridad, que será en realidad una carpeta de Windows montada en la máquina virtual Linux compartida como volumen al contenedor donde haga las copias de seguridad.

De todo lo que he encontrado buscando algo así, en ningún caso se activaba la autenticación. Incluso había una issue al respecto, pero he perdido la referencia (será una de éstas: https://github.com/docker-library/mongo/issues?q=is%3Aissue+is%3Aclosed+MONGO_INITDB_ROOT_USERNAME).

Así que si has caído aquí, es probable que hayas visto ya otras soluciones, probablemente mejores. Pero yo no encontré una adaptada a mis necesidades. Espero que te sea de utilidad.

Puesta en marcha
----------------
Para crear el Replica Set solo hay que ejecutar MongoSetup.sh. Recuerda adecuar las rutas, el usuario y la contraseña a lo que necesites antes de ejecutarlo.

Una vez creado el Replica Set, solo te hace falta controlarlo mediante docker-compose:

~~~
docker-compose stop
docker-compose start
~~~
