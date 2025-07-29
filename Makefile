# Makefile

# Silence any make output to avoid interfere with manifests apply.
MAKEFLAGS += -s

# General variables:
ACTIVATE = $(VENV)/bin/activate
PIP = $(VENV)/bin/pip
PYTHON3 = /usr/bin/python3.12
VENV = ./venv

# ---------------------------------------------------------
# Utility targets
# ---------------------------------------------------------

.PHONY: .confirm_clean
.confirm_clean:
	@echo "NOTE: In order to run additional make commands you will need to execute 'make init' beforehand."
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

.PHONY: .confirm_vms_remove
.confirm_vms_remove:
	@echo "DANGER: Removing these VMs is a destructive act and may result in a permanent loss of work."
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo -n "Please verify your choice? [y/N] " && read ans && [ $${ans:-N} = y ]

# ---------------------------------------------------------
# General targets
# ---------------------------------------------------------

default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -/]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
 
.PHONY: init
init: | venv-create ansible-requirements ansible-inventory # Initializes the automation environment.

.PHONY: create
create: | ansible-vms-create # Creates and starts VMs.

.PHONY: provision
provision: | ansible-vms-provision # Provisions the VMs.

.PHONY: clean
clean: | .confirm_clean venv-remove # Cleans up the automation environment.

# ---------------------------------------------------------
# Ansible targets
# ---------------------------------------------------------

.PHONY: ansible-inventory
ansible-inventory: # Generates the Ansible inventory file.
	@echo ">>> Running Ansible inventory generation"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/ansible-inventory.yml

.PHONY: ansible-lint
ansible-lint: # Runs the Ansible linter.
	@echo ">>> Running Ansible lint"
	. $(ACTIVATE); ansible-lint --force-color --profile=production $(CURDIR)

.PHONY: ansible-pingtest
ansible-pingtest: # Runs a ping test on each of the hosts in the Ansible inventory.
	@echo ">>> Running Ansible ping test"
	. $(ACTIVATE); ansible all -m ping

.PHONY: ansible-requirements
ansible-requirements: # Installs required Ansible Galaxy collections, etc.
	@echo ">>> Running Ansible Galaxy to install required collections, etc."
	. $(ACTIVATE); ansible-galaxy install -vvv -r $(CURDIR)/requirements.yml

.PHONY: ansible-vms-create
ansible-vms-create: # Creates and starts the VMs.
	@echo ">>> Running the VMs creation"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-create.yml

.PHONY: ansible-vms-remove-dev
ansible-vms-remove-dev: # Removes the development VMs.
	@echo ">>> Running the development VMs removal"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-remove-dev.yml

.PHONY: ansible-vms-remove-prod
ansible-vms-remove-prod: | .confirm_vms_remove # Removes the production VMs.
	@echo ">>> Running the production VMs removal"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-remove-prod.yml

.PHONY: ansible-vms-remove-test
ansible-vms-remove-test: | .confirm_vms_remove # Removes the test VMs.
	@echo ">>> Running the test VMs removal"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-remove-test.yml

.PHONY: ansible-vms-provision
ansible-vms-provision: | .confirm_vms_remove # Provisions the VMs.
	@echo ">>> Running the VMs provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml

# ---------------------------------------------------------
# venv targets
# ---------------------------------------------------------

.PHONY: venv-create
venv-create: # Creates a virtual Python interpreter with Ansible.
	@echo ">>> Creating venv at $(VENV)."
	$(PYTHON3) -m venv $(VENV) || (echo "> SUGGESTION: Check that the required $(PYTHON3) is installed."; exit 1)
	$(PIP) install -U pip
	@echo ">>> Installing requirements for Ansible"
	$(PIP) install -r ./requirements.txt

.PHONY: venv-remove
venv-remove: # Removes the virtual Python interpreter.
	@echo ">>> Removing virtual env"
	/usr/bin/rm -rf $(VENV)
