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

get_json_name() {
    local tmp_file=$1; shift
    #settings file has records like
    #job_name:json_name
    local job_json=`grep ${JOB_NAME} ${CUR_DIR}/${SETTINGS}`
    local json_name=${job_json#*:}
    echo $json_name > $tmp_file
    [[ -z "$json_name" ]] && {
        echo "Didn't get json file name. Exiting."
        exit 1
    }
}

get_latest_good_artefact() {
    local job_name=$1; shift
    local dest_dir=$1; shift
    local archive="archive.zip"
    local url="${HUDSON_URL}/job/${job_name}/"
    local url+="lastSuccessfulBuild/artifact/*zip*/${archive}"

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
    local container_job="start_os_pipeline_rhel<version>_iso_<bit number>_bit"
    local chefdir="chef-repo"
    local chefuser="chefsolo"

    #delete previous cucumber results
    rm -f "${cucumber_results}"

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

    #wait 300 sec for node booting
    check_node_is_up $vm_ip 300

    upload_ssh_key $vm_ip

    echo "Getting atdd scripts"
    local cucumber_dir='cucumber'
    rm -rf "${cucumber_dir}"
    get_latest_good_artefact "$cucumber_job" "$cucumber_dir"

    echo "Starting testing"
    pushd ${cucumber_dir}
        [[ $JENKINS_URL ]] && cucumber_opts="-f json -o ../${cucumber_results}"
        env_ip=$vm_ip env_user=$USERNAME env_pass=$PASSWORD\
            cucumber -t "@${JSON_TEMPLATE}" $cucumber_opts
        [[ $? != 0 ]] && {
            echo "Cucumber execution has failed"
            exit 1
        }
    popd

    echo "ATDD run complete"
}

main "$@"
