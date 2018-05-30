#!/bin/bash

function destroy_vm {
    local vm_id=$1
    #destroy vm
    echo "Cleaning up VM"
    "lc-node-do" -i $vm_id destroy
    if [ $? -ne 0 ]; then
        echo "VM deletion failed!"
        return 1
    fi
}

#from ci_save_template
function save_template {
    node_id=$1
    template_name=$2
    lc-mst-image-save -i $node_id -n $template_name
    if (($?==0));then
        echo "$vapp_template_id"
        echo "vAppTemplate_id=$vapp_template_id" >> paramaterizedTrigger.properties
    else
        return 1
    fi
}

function del_template {
    local vapp_id=$1
    echo "Cleaning up Template $vapp_id"
    lc-mst-template-delete -i $vapp_id

    if (($?==0));then
        echo "SUCCESS!"
    else
        return 1
    fi
}

#from ci_deploy.sh
function lookup_vm {
    vapp_name=$1
    for retry in 1 2 3 4 5; do
        echo "Lookup template: Attempt # ${retry}"
        vapp_template_id=$(lc-image-list | grep "${vapp_name}"| sed -re 's/.* (.*)\)/\1/')
        if [ $? -eq 0 ]; then
            echo "$vapp_template_id"
            return 0
        fi
        NUMBER=$[ ( $RANDOM % 15 )  + 1 ]
        sleep $NUMBER
    done
    echo "Lookup template failed!"
    return 1
}

function provision_vm {
    local vapp_template_id=$1
    local vapp_node_size=$2
    local vapp_network_id=$3
    local vapp_storage_profile=$4
    local vm_name=$5
    local channel_code=$6
    local application_code=$7
    local org_code=$8
    local group_code=$9
    local username=${10}
    local email=${11}

    echo "Vapp Template ID: ${vapp_template_id}"
    echo "Node size: ${vapp_node_size}"
    echo "Network ID: ${vapp_network_id}"
    echo "Storage Profile: ${vapp_storage_profile}"
    echo "Channel Code: ${channel_code}"
    echo "Application Code: ${application_code}"
    echo "Organization Code: ${org_code}"
    echo "Group Code: ${group_code}"
    echo "Username: ${username}"

    for retry in 1 2 3 4 5; do
        echo "Provisioning VM: Attempt # ${retry}"
        vmstr=`lc-node-add -i ${vapp_template_id} -t "${vapp_network_id}" -s ${vapp_node_size} -n "${vm_name}" -b ${vapp_storage_profile} -h ${channel_code}\
            -d ${application_code} -g ${org_code} -w "${group_code}" -e "${email}" -u "${email}" -q "${username}"\
            -f "${username}" -m 7200 ex_bridged=true`
        if [ $? -eq 0 ]; then
            return 0 
        fi
        NUMBER=$[ ( $RANDOM % 15 )  + 1 ]
        sleep $NUMBER
    done
    echo "VM allocation failed!"
    return 1
}

function expect_password {
    expect -c "\
    set timeout 90
    set env(TERM) xterm-256color
    spawn $1
    expect \"password:\"
    send \"$2\r\"
    expect eof
  "
}
