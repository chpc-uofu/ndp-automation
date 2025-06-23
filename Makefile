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
init: | venv-create ansible-requirements ansible-inventory packer-init # Initializes the automation environment.

.PHONY: clone
clone: | ansible-vms-clone # Clones and starts VMs from the VM template.

.PHONY: provision
provision: | ansible-vms-provision # Provisions the VMs.

.PHONY: template
template: | packer-pkrvars-create packer-user-data-create packer-build # Builds the ubuntu-server-noble VM template with HashiCorp Packer.

.PHONY: clean
clean: | .confirm_clean venv-remove packer-pkrvars-remove packer-user-data-remove # Cleans up the automation environment.

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

.PHONY: ansible-vms-clone
ansible-vms-clone: # Clones and starts the VMs.
	@echo ">>> Running the VMs clone"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-clone.yml

.PHONY: ansible-vms-provision
ansible-vms-provision: # Provisions the VMs.
	@echo ">>> Running the VMs provision"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/vms-provision.yml

# ---------------------------------------------------------
# mkosi targets
# ---------------------------------------------------------

.PHONY: mkosi-build
mkosi-build: # Builds the ubuntu-server-noble raw disk image.
	@echo ">>> Building the raw disk image for ubuntu-server-noble"
	@echo $(PWD)
	. $(ACTIVATE); mkosi --directory $(PWD)/mkosi --distribution ubuntu build

# ---------------------------------------------------------
# Packer targets
# ---------------------------------------------------------

.PHONY: packer-build
packer-build: # Builds the ubuntu-server-noble Packer template.
	@echo ">>> Running Packer build for the ubuntu-server-noble template"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/packer-build.yml
#	cd $(CURDIR)/packer/ubuntu-server-noble && packer build -on-error=ask --var-file secrets.pkrvars.hcl .

.PHONY: packer-init
packer-init: # Installs missing Packer plugins or upgrades Packer plugins.
	@echo ">>> Running Packer initialization for the ubuntu-server-noble template"
	cd $(CURDIR)/packer/ubuntu-server-noble && packer init .

.PHONY: packer-validate
packer-validate: # Checks that the ubuntu-server-noble template Packer template is valid.
	@echo ">>> Running Packer validation for the ubuntu-server-noble template"
	cd $(CURDIR)/packer/ubuntu-server-noble && packer validate .

.PHONY: packer-pkrvars-create
packer-pkrvars-create: # Generates the Packer variables file.
	@echo ">>> Running Packer variables file generation"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/packer-vars.yml

.PHONY: packer-pkrvars-remove
packer-pkrvars-remove: # Removes the Packer variables file.
	@echo ">>> Running Packer variables file removal"
	rm -f $(CURDIR)/packer/ubuntu-server-noble/secrets.pkrvars.hcl

.PHONY: packer-user-data-create
packer-user-data-create: # Generates the Packer variables file.
	@echo ">>> Running Packer user-data file generation"
	. $(ACTIVATE); ansible-playbook $(CURDIR)/playbooks/packer-user-data.yml

.PHONY: packer-user-data-remove
packer-user-data-remove: # Removes the Packer user-data file.
	@echo ">>> Running Packer vuser-datariables file removal"
	rm -f $(CURDIR)/packer/ubuntu-server-noble/http/user-data

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
