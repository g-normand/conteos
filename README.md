

Utilisation de Bottle (https://bottlepy.org/docs/dev/)

Tout passe par le WSGI
Pour Alwaysdata, c'est dans /admin/config/uwsgi
```
chdir = /home/conteos/www
wsgi-file = /home/conteos/www/wsgi.py

## Install:


Pour l'installation:
```
$ git clone git@github.com:g-normand/conteos.git
$ cd conteos
$ make install
``` 
ou
``` 

make install_alwaysdata
``` 

Sinon faire:
```
make serve
```


## Deployer:

    make deploy
