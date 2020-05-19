# 3 node MongoDB Replica Set with docker-compose

[Versión en castellano](README.md)
[Versió en català](READMEcat.md)

This is just a mini-project showing how I set up a MongoDB Replica Set using docker-compose.
It is inspired by https://gist.github.com/harveyconnor/518e088bad23a273cae6ba7fc4643549, https://github.com/msound/localmongo and others.

The only difference with projects I found in several searches is it activates authentication in the Replica Set (--auth).

Insides
-------
You'll be able to set up a 3 node Replica Set with MongoDB 4.2.6 (mongo:4.2.6-bionic image) running 3 containers in the same host. In my case it's a Ubuntu 20.04 virtual machine on Virtual Box 6.1.6 over Windows 10 (I tried just a bit Hyper-V and it didn't convince me. Perhaps later on time).

I'd prefer to store data in Windows files, but MongoDB requires some Linux features. So data is stored in the Linux virtual machines's file system. To do so, every container has 2 bind mounts:
- One reserved for each container/node for data (/data/db)
- Another shared by all nodes for the key file (/data/pki)

Later I'll add a 3rd one for backups. Actually it will be a Windows folder mounted on the Linux VM shared as a volume to the container in charge of backups.

I searched for an example of a docker-compose file with authentication, but I didn't find it. I remember there was an issue discussing the problem, but I lost its reference (maybe it is one of these: https://github.com/docker-library/mongo/issues?q=is%3Aissue+is%3Aclosed+MONGO_INITDB_ROOT_USERNAME).

So if you are reading this, you have probably seen other (better?) solutions. What perhaps this one is more helpful for you. I hope so.

Set Up
------
To create the Replica Set from scratch, just run MongoSetup.sh. Remember to change the paths, user and password to your needs before running it.

Once the Replica Set is running, you just need to control it with docker-compose:

~~~
docker-compose stop
docker-compose start
~~~

