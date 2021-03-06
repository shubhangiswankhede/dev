#!/bin/bash

source ci_functions.sh
declare -r SETTINGS='settings'
declare -r CUR_DIR=$(dirname "${BASH_SOURCE[0]}")

check_node_is_up(){
    local ip=$1; shift
    local -i seconds=$1; shift
    local -i sleep_time=5
    local -i retries=$((seconds/sleep_time))
    local port="22"
    local i=0
    while sleep $sleep_time
    do
        i=$((i+1))
        if ((i>$retries))
        then
            echo "failed after $retries tries"
            exit 1
        fi
        echo "checking if port $port is open on $ip, try: $i/$retries"
        bash -c "exec 3<> /dev/tcp/${ip}/${port}" && {
            echo "successfully connected to port $port"
            break
        }
    done
}

upload_ssh_key() {
    #USERNAME and PASSWORD should be set in a jenkins job configuration
    local ip=$1; shift
    # Allow jenkins key-based ssh
    ssh-keyscan -t rsa ${ip} >> $HOME/.ssh/known_hosts
    if ! ssh -t -o PasswordAuthentication=no ${USERNAME}@$ip 'exit 0'
    then
        local pwdfile=`mktemp`
        #escape special bash symbols and save to the pwdfile
        python -u escape_bash_spec_chars.py "${PASSWORD}" "$pwdfile"
        local password=`cat ${pwdfile}`
        rm -f ${pwdfile}
        expect_password\
            "ssh-copy-id -i ${HOME}/.ssh/id_rsa.pub ${USERNAME}@${ip}"\
                 "$password"
    fi
}

get_json_name() {
    local tmp_file=$1; shift
    #settings file has records like
    #job_name:json_name
    local job_json=$(grep ${JOB_NAME} ${CUR_DIR}/${SETTINGS})
    local json_name=${job_json#*:}
    echo $json_name > $tmp_file
    [[ -z "$json_name" ]] && { 
        echo "Didn't get json file name. Exiting."
        exit 1 
    }
}

get_latest_good_artifact() {
    local job_name=$1; shift
    local dest_dir=$1; shift
    local archive="archive.zip"
    local url="${HUDSON_URL}/job/${job_name}/"
    local url+="lastSuccessfulBuild/artifact/*zip*/${archive}"

    echo "The Cookbook url is: ${url}"

    rm -f $archive
    rm -rf $dest_dir
    mkdir $dest_dir


    curl -O ${url}
    [[ $? != 0 ]] && exit 1
    unzip -p $archive | tar xz  -C $dest_dir

}

main(){
    local cucumber_job="cucumber_atdd_scripts"
    local cucumber_results="cucumber.json"
    local master_job="_Master_Pipeline"
    local branch_job="_${RELEASE}_Release_Pipeline"
    local chefdir="chef-repo"
    local chefuser="chefsolo"

    #delete previous cucumber results
    rm -f "${cucumber_results}"
    rm -rf "${chefdir}"
    mkdir  "${chefdir}"

  if [ -z "${RELEASE}" ]
    then
        echo "Release is not provided."
        get_latest_good_artifact "${master_job}" "$chefdir" 
   else
        echo "-----------------------------------------------------------"
        echo "Cookbooks Branch: $RELEASE"
        echo "-----------------------------------------------------------"
        get_latest_good_artifact "${branch_job}" "$chefdir"
    fi

   # curl ${COOKBOOKS_URL} | tar xz -C $chefdir
     
    local vm_ip=${IP}
    local vm_host=$(dig +short -x ${vm_ip}|cut -d '.' -f1)
    echo "  -> vm   ip: ${vm_ip}"
    echo "  -> vm host: ${vm_host}"
   
    if [ -z "$JSON_TEMPLATE" ] 
    then
        local tmp_file=`mktemp`
        get_json_name $tmp_file
        JSON_TEMPLATE=`cat $tmp_file`
        rm -f $tmp_file
    fi   
    
    echo "json file name is ${JSON_TEMPLATE}.json"
    echo "User loggin in is ${USERNAME}" 
    # Generate customized json
    IP_ADDRESS=$vm_ip HOSTNAME=$vm_host\
         perl -pe 's/%%(.*?)%%/defined $ENV{$1} ? $ENV{$1} : $&/eg'\
         cookbooks/jsons/${JSON_TEMPLATE}.json > $chefdir/nodes/node.json
 
    #wait 300 sec for node booting
    check_node_is_up $vm_ip 300  
  
    upload_ssh_key $vm_ip
    
    # Extract and start deployemnt 
    rsync -e "ssh -t -o StrictHostKeyChecking=no"\
        -lrp --delete $chefdir ${USERNAME}@${vm_ip}:
    [[ $? != 0 ]] && exit 1

    # Copying chef-repo from User home folder to chefsolo home folder
    if [ ${USERNAME} != ${chefuser} ]
    then
        ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
        "sudo su - ${chefuser} bash -c \"sudo cp -R /home/${USERNAME}/${chefdir} /home/${chefuser}\""
        [[ $? != 0 ]] && exit 1
    fi

    # Changing ownership to chefsolo user
    ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
    "sudo su - ${chefuser} bash -c \"sudo chown -R ${chefuser}:${chefuser} /home/${chefuser}\""
    [[ $? != 0 ]] && exit 1

    # Executing the cookbook
    ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
    "sudo su - ${chefuser} bash -c \"cd /home/${chefuser}/${chefdir};sudo chef-solo -j nodes/node.json -c solo.rb -Fdoc\""
    [[ $? != 0 ]] && exit 1
    
    echo "Chef run complete"
    
}

main "$@"