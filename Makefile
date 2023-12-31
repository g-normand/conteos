### Configure paths. ###
PROJECT_PATH := $(CURDIR)
APP_PATH := $(CURDIR)/conteos
ENV_PATH := $(CURDIR)/conteos_env
PYTHON := $(ENV_PATH)/bin/python3.9
TAG_NAME := DEPLOY_CONTEOS
TAG_DATE := $(TAG_NAME)_$(shell date -u "+%Y_%m_%d_%H_%M_%S")

### Shell configure. ###
# For shell to bash to be able to use source.
SHELL = /bin/bash
# Enable colors for ouput. Use echo with -e.
RED=\033[0;31m
ORANGE=\033[0;33m
NC=\033[0m

### Configure virtual environment. ###
# Shortcut to set env command before each python cmd.
VENV = source $(ENV_PATH)/bin/activate

# Config is based on two environment files, initalized here.
virtualenv: $(ENV_PATH)/bin/activate

# Virtualenv file containing python libraries.
$(ENV_PATH)/bin/activate:
	virtualenv -p /usr/bin/python3.9 $(ENV_PATH)

### Manage project installation. ###
# Install python requirements.
install: virtualenv
	$(VENV) && pip3 install -r requirements.txt

install_alwaysdata: virtualenv
	 python -m pip install -r requirements.txt


clean:
	find . -name '*.pyc' -delete

deploy: clean
	rsync -r conteos/* guiguide@ssh-guiguide.alwaysdata.net:/home/guiguide/www/conteos/conteos/
	scp Makefile guiguide@ssh-guiguide.alwaysdata.net:/home/guiguide/www/conteos/
	echo "make pip"

### Serving. ###
serve: virtualenv
	$(VENV) && python start-bottle.py

serve_prod:
	$(VENV) && $(PYTHON) conteos/wsgi.py

