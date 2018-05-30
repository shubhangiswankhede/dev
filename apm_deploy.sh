#!/bin/bash

source ci_functions.sh
declare -r SETTINGS='settings'
declare -r CUR_DIR=`dirname "${BASH_SOURCE[0]}"`

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

get_latest_good_artifact() {
    local job_name=$1; shift
    local dest_dir=$1; shift
    local chefdir="apm"
    local archive="APM-Agent-Byte-Buddy-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    local archive2="APM-Agent-Byte-Buddy-Bootstrap-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    local url="http://esu2v286:8080/job/APM-Agent-Byte-Buddy-Refactor/"
    local url2="http://esu2v286:8080/job/APM-Agent-Byte-Buddy-Bootstrap/"
    local url+="${version}/artifact/target/${archive}"
    local url2+="${version2}/artifact/target/${archive2}"
    wget -O /tmp/${chefdir}/${archive} ${url}
    wget -O /tmp/${chefdir}/${archive2} ${url2} 
}

main(){
    
    local chefdir="apm"
    local chefuser="chefsolo"
    local archive="APM-Agent-Byte-Buddy-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    local archive2="APM-Agent-Byte-Buddy-Bootstrap-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    local url="http://esu2v286:8080/job/APM-Agent-Byte-Buddy-Refactor/"
    local url2="http://esu2v286:8080/job/APM-Agent-Byte-Buddy-Bootstrap/"
    local url+="${version}/artifact/target/${archive}"
    local url2+="${version2}/artifact/target/${archive2}"

    rm -rf "/tmp/${chefdir}"
    mkdir  "/tmp/${chefdir}"

    if [ -z "${version}" ]
    then
         echo "APM JAR version is not provided."
         echo "Please provide APM JAR version you want to deploy and re-run job"
         exit 1
    else
         echo "-----------------------------------------------------------"
         echo "Deploying APM JAR with version: $version"
         echo "-----------------------------------------------------------"
         get_latest_good_artifact
    fi 
     
    local vm_ip=${IP}
    local vm_host=$(dig +short -x ${vm_ip}|cut -d '.' -f1)
    echo "  -> vm   ip: ${vm_ip}"
    echo "  -> vm host: ${vm_host}"
   
      
    echo "User loggin in is ${USERNAME}" 
    
    echo "checking if node is up"
    #wait 300 sec for node booting
    check_node_is_up $vm_ip 300  
  
    echo "Uploading ssh keys"
    upload_ssh_key $vm_ip
    
    echo "Moving the artifacts"

      # Extract and start deployemnt 
    rsync -e "ssh -t -o StrictHostKeyChecking=no"\
        -lrp --delete /tmp/$chefdir ${USERNAME}@${vm_ip}:
    [[ $? != 0 ]] && exit 1

    ## Copying apm from User home folder to chefsolo home folder
    #if [ ${USERNAME} != ${chefuser} ]
    #then
        ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
        cp -R /home/${USERNAME}/${chefdir} /tmp/
        [[ $? != 0 ]] && exit 1
    #fi

    #echo "Changing the ownership to chefsolo user"
    # Changing ownership to chefsolo user
    #ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
    #chown ${chefuser}:${chefuser} /tmp/${chefuser}
    #[[ $? != 0 ]] && exit 1

     echo "Chef run complete"

}

main "$@"