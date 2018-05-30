#!/bin/bash

declare tempfoo=`basename $0`

source ci_functions.sh

save_vm_as_template(){
    local ips=($1); shift
    local version=$1; shift
    local vm_names_file=$1; shift
    local node_list=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1

    lc-node-list > $node_list
    [[ $? != 0 ]] && exit 1
    for ((i=0; i<${#ips[*]}; i++))
    do
        local vm=( $(grep "${ips[$i]}" $node_list) )
        local vm_id=${vm[0]}
        local vm_name=${vm[1]}
        #delete all symbols after and with @
        vm_name="${vm_name%-*}"
        echo "Saving VM with id=${vm_id} and name=${vm_name}"
    	save_template ${vm_id} "${vm_name}-${version}"
        [[ $? != 0 ]] && exit 1
        echo "$vm_name" >> "$vm_names_file"
    done
    rm -f $node_list
}

delete_old_images(){
    local vm_names_file=$1; shift
    local version=$1; shift
    local images_number=$1; shift
    local images_list=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
    local tmp_file=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1

    lc-image-list > $images_list
    [[ $? != 0 ]] && exit 1
    for name in `cat $vm_names_file`
    do
        echo "Looking for $name templates."
        local -i amount=`grep "${name}" $images_list | wc -l`
        echo "Found $amount $name templates"
        local -i excess=$((amount - images_number))
        if (( $excess > 0 ))
        then
            grep "${name}" ${images_list} | sort |\
               head -n ${excess} > ${tmp_file}
            echo "$excess template(s) need(s) to be deleted."
            while read -r image
            do
                local id="${image#*id =}"
                #remove last char ")"
                id=${id%)}
                echo "Deleting ${id} VM image of the ${name}."
                del_template ${id}
                [[ $? != 0 ]] && exit 1
            done < ${tmp_file}
        fi
    done
    rm -f $tmp_file
    rm -f $images_file
}

main() {
    local ips=${IP_LIST}
    local version=${VERSION}
    local vm_names_file=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
    local -i images_number=2
    save_vm_as_template "$ips" "$version" "$vm_names_file"
    #delete_old_images "$vm_names_file" "$version" $images_number
    rm -f $vm_names_file
} 
main "$@"
