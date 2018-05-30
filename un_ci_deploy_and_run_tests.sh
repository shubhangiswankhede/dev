#!/bin/bash

declare -r SETTINGS='settings'
source SE-CI/ci_functions.sh
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
        python -u SE-CI/escape_bash_spec_chars.py "${PASSWORD}" "$pwdfile"
        local password=`cat ${pwdfile}`
        rm -f ${pwdfile}
        expect_password\
            "ssh-copy-id -i ${HOME}/.ssh/id_rsa.pub ${USERNAME}@${ip}"\
                 "$password"
    fi
}

main(){

  local chefdir=$COOKBOOK
  local chefuser="chefsolo"

  echo "-----------------------------------------------------------"
  if [ -z "${COOKBOOKS_URL}" ]
  then
       echo "Cookbooks URL is not provided."
       echo "Using local chef repo."
  else
       echo "Cookbooks URL: $COOKBOOKS_URL"
       curl ${COOKBOOKS_URL} | tar xz -C $chefdir
  fi
  echo "-----------------------------------------------------------"

  local vm_ip=${IP}
  local vm_host=$(dig +short -x ${vm_ip}|cut -d '.' -f1)
  echo "  -> vm   ip: ${vm_ip}"
  echo "  -> vm host: ${vm_host}"

  #wait 300 sec for node booting
  check_node_is_up $vm_ip 300

  upload_ssh_key $vm_ip

  # Deploy and run test.sh
  chmod -R 777 $chefdir
  rsync -e "ssh -t -o StrictHostKeyChecking=no"\
    -lrp --delete $chefdir ${USERNAME}@${vm_ip}:~
    [[ $? != 0 ]] && exit 1

  ssh -t -t -o 'StrictHostKeyChecking=no' ${USERNAME}@${vm_ip} -- \
    "cd ~/${chefdir} && berks install && ./test.sh"
    [[ $? != 0 ]] && exit 1

  exit 0
}

main "$@"
