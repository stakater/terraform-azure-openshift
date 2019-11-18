#!/bin/bash

export LANG=C
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORKS=5
export ANSIBLE_PIPELINING=True

ansible-playbook --private-key=openshift.key -i $HOME/inventory.yaml $HOME/node-config-playbook.yaml || { echo "Error on register repos" ; exit 1 ; }
