#!/bin/bash
source scripts/ci_functions.sh

#CHEF_REPO_VERSION="0.0.241"

lc-node-list | grep "pipeline-" > VMs
echo "---------------- VMs -----------------"
cat VMs
echo "--------------------------------------"

vms=( $(cat VMs | grep "pipeline-$CHEF_REPO_VERSION" | cut -d$'\t' -f 1) )

for vm in "${vms[@]}"
do
        echo "destroying $vm"
        destroy_vm $vm
done