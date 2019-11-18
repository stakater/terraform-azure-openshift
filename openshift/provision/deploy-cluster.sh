#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

cd /usr/share/ansible/openshift-ansible
## Step 1
ansible-playbook -vvv --private-key=$HOME/openshift.key -i $HOME/inventory.yaml playbooks/prerequisites.yml || { echo "Error on prerequisites" ; exit 1 ; }
## Step 2
ansible-playbook -vvv --private-key=$HOME/openshift.key -i $HOME/inventory.yaml playbooks/deploy_cluster.yml || { echo "Error on deploying cluster" ; exit 1 ; }

cd ~
ansible-playbook -vvv --private-key=$HOME/openshift.key -i $HOME/inventory.yaml $HOME/openshift-applier/openshift-policies/config.yml || { echo "Error on applier" ; exit 1 ; }