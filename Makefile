# Makefile

# Silence any make output to avoid interfere with manifests apply.
MAKEFLAGS += -s

# General variables:
ACTIVATE = $(VENV)/bin/activate
NDP_ANSIBLE_LIMIT ?=                            # same syntax as --limit
NDP_ENVS := dev test prod
PIP = $(VENV)/bin/pip
PYTHON3 = /usr/bin/python3.12
VENV = ./venv

# Exported variables:
export ANSIBLE_INVENTORY ?= ./inventories/dev
export ANSIBLE_RUN_TAGS := "bootstrap"          # "auth", "bootstrap", "docker", "fail2ban", "firewall", "logging", "snaps", "tanium"

# ---------------------------------------------------------
# Utility targets
# ---------------------------------------------------------

.PHONY: .confirm_clean
.confirm_clean:
	@echo "NOTE: In order to run additional make commands you will need to execute 'make init' beforehand."
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

.PHONY: .envcheck
.envcheck:
	@echo ">>> Displaying associated environmental variables"
	(env | grep ^ANSIBLE_*) || true
	(env | grep ^NDP_*) || true

# ---------------------------------------------------------
# General targets
# ---------------------------------------------------------

default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -/]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
 
.PHONY: init
init: | .envcheck venv-create ansible-requirements-install ansible-inventory # Initializes the automation environment.

.PHONY: create
create: | .envcheck ansible-vms-create # Creates and starts VMs.

.PHONY: provision
provision: | .envcheck ansible-vms-provision # Provisions the VMs.

.PHONY: clean
clean: | .confirm_clean venv-remove # Cleans up the automation environment.

# ---------------------------------------------------------
# Ansible targets
# ---------------------------------------------------------

.PHONY: ansible-inventory-graph
ansible-inventory-graph: | .envcheck # Graphing the Ansible inventory.
	@echo ">>> Graphing the Ansible inventories"
	. $(ACTIVATE); ansible-inventory --graph

.PHONY: ansible-lint
ansible-lint: # Runs the Ansible linter.
	@echo ">>> Running Ansible lint"
	. $(ACTIVATE); ansible-lint --force-color --profile=production $(CURDIR)

.PHONY: ansible-pingtest
ansible-pingtest: | .envcheck # Runs a ping test on each of the hosts in the Ansible inventory.
	@echo ">>> Running Ansible ping test"
	. $(ACTIVATE); ansible all -m ping

.PHONY: ansible-requirements-install
ansible-requirements-install: # Installs required Ansible Galaxy collections, etc.
	@echo ">>> Running Ansible Galaxy to install required collections, etc."
	. $(ACTIVATE); ansible-galaxy install -vvv -r $(CURDIR)/requirements.yml

.PHONY: ansible-vms-create
ansible-vms-create: # Creates and starts the VMs.
	@echo ">>> Running the VMs creation"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-create.yml --extra-vars "ndp_ansible_limit='$(NDP_ANSIBLE_LIMIT)'"	

.PHONY: ansible-vms-provision
ansible-vms-provision: # Provisions the VMs. Use Ansible tags to filter tasks.
	@echo ">>> Running the VMs provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml --tags bootstrap --limit '$(NDP_ANSIBLE_LIMIT)'

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
