#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

ansible-playbook --private-key=openshift.key -i $HOME/inventory.yaml $HOME/node-config-playbook.yaml || { echo "Error on register repos" ; exit 1 ; }

cd /usr/share/ansible/openshift-ansible
## Step 1
ansible-playbook -vvv --private-key=$HOME/openshift.key -i $HOME/inventory.yaml playbooks/prerequisites.yml || { echo "Error on prerequisites" ; exit 1 ; }
## Step 2
ansible-playbook -vvv --private-key=$HOME/openshift.key -i $HOME/inventory.yaml playbooks/openshift-node/scaleup.yml || { echo "Error on scaling cluster" ; exit 1 ; }