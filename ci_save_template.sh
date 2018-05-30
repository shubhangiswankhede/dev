#!/bin/bash
source scripts/ci_functions.sh

lc-node-list > VMs

vms=( $(cat VMs | grep "pipeline-$CHEF_REPO_VERSION" | cut -d$'\t' -f 1) )
name=( $(cat VMs |grep "pipeline-$CHEF_REPO_VERSION" | sed -re 's/.*jenkins-(\S*).*/\1/' ) )
echo "----- names ----- ${name[@]}"
echo "----- vms ----- ${vms[@]}"
date
echo "-------Saving templates------"
for x in $(seq 0 "$((${#vms[@]}-1))")
do
    echo "Saving ${name[$x]} ${vms[$x]}"
	save_template ${vms[$x]} ${name[$x]}

done
echo "----------------"
date
echo "-----Destroying VMs-------"

for x in $(seq 0 "$((${#vms[@]}-1))")
do
    echo "Deleting ${vms[$x]}"
	destroy_vm ${vms[$x]}
done
echo "---------------"
date
echo "-----Cleaning up old templates-----"

lc-image-list | grep "pipeline-" > IMs

#1 variable, space separated, 3 colmns, name #, vapptemplateid
ims=( $(cat IMs | sed -re 's/((.*)\.(.*)\.(.*))/\1 \2 \3 \4/'| sort -k 2n -k 3n -k 4n|cut -d ' ' -f1) )

pipelines=( $(cat IMs | grep "pipeline-" | cut -d '-' -f 1 |sort -u | cut -d' ' -f 2) )

for pipeline in "${pipelines[@]}"
do

num_of_templates=2
#check if name occurs more than 3 times, delete if it does.
delete_vapp_id=( $(cat IMs |grep "${pipeline}"|sed -re 's/(.*)-(([0-9]*)\.([0-9]*)\.([0-9]*)).*\(id= (.*)\)/\3 \4 \5 \1 \2 \6/'|sort -k 1n -k 2n -k 3n | cut -d ' ' -f 4-|head -n -$num_of_templates|cut -d ' ' -f2 | cut -c0-49 ) )
    for vapp_id in "${delete_vapp_id[@]}"
    do
    del_template ${vapp_id}
    done
done
date
#cat IMs | grep "pipeline-" | cut -d' ' -f 1
#name_pre=$( echo ${name[$x]} | cut -d'-' -f1 )
#saved_name="${name_pre}-$CHEF_REPO_VERSION"