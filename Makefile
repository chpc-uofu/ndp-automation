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

.PHONY: ansible-vms-firewall
ansible-vms-firewall: # Provisions the VM firewalls.
	@echo ">>> Running the VM firewalls provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml --tags firewall

.PHONY: ansible-vms-logging
ansible-vms-logging: # Provisions the VM logging configurations.
	@echo ">>> Running the VM logging provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml --tags logging

.PHONY: ansible-vms-provision
ansible-vms-provision: # Provisions the VMs.
	@echo ">>> Running the VMs provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml --tags bootstrap

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
