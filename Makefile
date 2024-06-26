### Configure paths. ###
PROJECT_PATH := $(CURDIR)
APP_PATH := $(CURDIR)/conteos
ENV_PATH := $(CURDIR)/conteos_env
PYTHON := $(ENV_PATH)/bin/python3.9
TAG_NAME := DEPLOY
TAG_DATE := $(TAG_NAME)_$(shell date -u "+%Y_%m_%d_%H_%M_%S")

### Shell configure. ###
# For shell to bash to be able to use source.
SHELL = /bin/bash

# Shortcut to set env command before each python cmd.
VENV = source $(ENV_PATH)/bin/activate

# Config is based on two environment files, initalized here.
virtualenv: $(ENV_PATH)/bin/activate

$(ENV_PATH)/bin/activate:
	virtualenv -p /usr/bin/python3.9 $(ENV_PATH)

### Manage project installation. ###
# Install python requirements.
pip: virtualenv
	$(VENV) && cd $(APP_PATH) && pip3 install -r $(APP_PATH)/requirements.txt;

clean:
	find . -name '*.pyc' -delete

### Misc. ###
shell:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py shell

deploy: clean
	rsync -r conteos/* --exclude conteos/staticfiles/ conteosec@ssh-conteosec.alwaysdata.net:/home/conteosec/www/conteos_db/conteos/
	rsync Makefile conteosec@ssh-conteosec.alwaysdata.net:/home/conteosec/www/conteos_db/
	git tag $(TAG_DATE); git push origin $(TAG_DATE) --no-verify
	echo "Now please restart on AlwaysData"

collectstatic:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py collectstatic

migrate: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py migrate

migrations: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py makemigrations

### Serving. ###
serve: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py runserver

