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

# Migrate database.
migrate: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py migrate

migrations: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py makemigrations

# Show migrations state of the db
showmigrations: virtualenv
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py showmigrations

# Install pre-push hook.
GITHOOK_DIR=$(shell git rev-parse --git-dir)/hooks/

$(GITHOOK_DIR)pre-push:
	cp .pre-push.template $@

install: psql pip migrate $(GITHOOK_DIR)pre-push

### Check that daemons are running. ###
# Archlinux uses systemctl, this has to be adapted for cross platform.
SYSCTL = systemctl

# Warning: In shell, 0 is succes, <0 is failure, so double check your bool logic.
# Test logic: if daemon check is not possible on platfom, should return 0, not to
# execute further tests. Otherwise return 1, to continue.
CHECK_SYSCTL = !($(SYSCTL) >> /dev/null || (echo -e "${ORANGE}Systemctl is not supported by your platform.${NC} Please update makefile or check yourself that daemons are running." && exit 1))

# Check that postgresql is up and running.
psql:
	@$(CHECK_SYSCTL) || ($(SYSCTL) status postgresql >> /dev/null || (echo -e "${RED}Postgresql does not seem to be up.${NC}" && exit 1))

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

### Misc. ###
# Set a terminal in case user did not.
CONSOLE ?= xterm

shell:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py shell

create:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py startapp sites

createsuperuser:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py createsuperuser

deploy:
	scp -r * guiguide@ssh-guiguide.alwaysdata.net:/home/guiguide/www/conteos/

### Serving. ###
serve:
	$(VENV) && $(PYTHON) $(APP_PATH)/manage.py runserver

