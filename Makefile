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
pip: virtualenv
	$(VENV) && cd $(APP_PATH) && pip3 install -r $(APP_PATH)/requirements.txt;

### Check that daemons are running. ###
### Configure testing. ###
# General testing command.
TEST_CMD = $(PYTHON) $(APP_PATH)/manage.py test

# Launch all tests.
test:
	$(VENV) && export REUSE_DB=0 && $(TEST_CMD) conteos

# Launch a specific test. Please edit this command if you are working
# on one test specifically.
test_unique:
	$(VENV) && export REUSE_DB=0 && $(TEST_CMD) -x -s okocha/accounts/tests.py:OkochaTestCase.test_running_to_training

# Coverage keyword will be recognize by django's manage.py and
# coverage will be processed.
coverage:
	$(VENV) && $(TEST_CMD) conteos

### Code linting. ###
PYLINT := pylint --load-plugins pylint_django $(APP_PATH)/okocha $(APP_PATH)/accounts $(APP_PATH)/strava $(APP_PATH)/sync_processes $(APP_PATH)/championship $(APP_PATH)/public_api $(APP_PATH)/decathlon $(APP_PATH)/monthly_summaries

pylint: virtualenv
	$(VENV) && $(PYLINT) -rn

pylint_full: virtualenv
	$(VENV) && $(PYLINT) -ry

clean:
	find . -name '*.pyc' -delete

deploy: clean
	rsync -r conteos/* guiguide@ssh-guiguide.alwaysdata.net:/home/guiguide/www/conteos/conteos/
	scp Makefile guiguide@ssh-guiguide.alwaysdata.net:/home/guiguide/www/conteos/
	echo "make pip"

### Serving. ###
serve:
	$(VENV) && $(PYTHON) -m flask --app conteos/views run --port 8000 --debug

serve_prod:
	$(VENV) && $(PYTHON) conteos/wsgi.py

