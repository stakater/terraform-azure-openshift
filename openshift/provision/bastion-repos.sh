#!/bin/bash

if [ -z $USE_COMMUNITY ]; then
    echo "It's a OCP"
    sudo subscription-manager register --username=${rhn_username} --password=${rhn_password}
    sudo subscription-manager attach --pool=${rh_subscription_pool_id}
    sudo subscription-manager repos --disable="*"
    sudo subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ansible-2.6-rpms"
    sudo subscription-manager repos --enable="rhel-7-server-ose-${openshift_major_version}-rpms"
    sudo yum -y install ansible openshift-ansible git wget net-tools bind-utils yum-utils bash-completion kexec-tools sos psacct
else
    echo "It's a OKD"
    sudo yum -y install centos-release-ansible26
fi
