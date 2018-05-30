#!/bin/bash

declare tempfoo=`basename $0`

main() {
    local ips=(${IP_LIST})
    local vapps=(${VAPP_LIST})
    local node_list=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1

    lc-node-list > $node_list
    echo "$node_list"
    for ((i=0; i<${#vapps[*]}; i++))
    do
        local vm=( $(grep "${vapps[$i]}" $node_list) )
        local vm_id=${vm[0]}
        local vm_name=${vm[1]}
        echo "Deleting VM with id=${vm_id}, name=${vm_name}"
        lc-node-do -i $vm_id destroy
        if [ $? -ne 0 ]
        then
            echo "VM deletion failed!"
            return 1
        else
            echo "Deleted."
        fi
    done
    rm -f $node_list
} 
main "$@"
