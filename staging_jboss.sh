#!/bin/bash	

declare -r CUR_DIR=`dirname "${BASH_SOURCE[0]}"`
declare IP_LIST=""
declare -r SETTINGS='settings_jboss'
declare TRIGGER_PROPERTIES="paramaterizedTrigger.properties"
source ${CUR_DIR}/ci_functions.sh

get_dependencies(){
    local json=$1; shift
    local diff_file=$1; shift
    local deps_file=$1; shift
    local deps="diff_${json/.json/}"
    echo "------------------------------"
    echo "Working on $json"
    [[ -f nodes/${json} ]] && rm -f nodes/${json}
    ln $CUR_DIR/jsons/$json nodes/${json}
    knife deps nodes/${json} > ${deps}
    #exclude readme files and save found depedencies 
    echo `grep -Ff "${deps}" < "${diff_file}"`|grep -vi readme  > $deps_file
    if [ ! -z "`cat $deps_file`" ]
    then
        echo "Recent commits affected:"
        cat $deps_file
    fi
}

add_job_to_runlist(){
    local json=$1; shift
    #settings file has records like
    #job_name:json_name
    local job_json=`grep ${json/.json/} ${CUR_DIR}/${SETTINGS}`
    local job_name=${job_json%:*}
    if [  -z "$job_name" ]
    then
        echo "No recond for the $json in the $SETTINGS file" 
    else
        JOB_LIST_TO_RUN+="${job_name} "
        echo "Assigned $job_name jenkins job for the $json"
        echo "Added $job_name to the run list"
        echo "Run list is consist of: ${JOB_LIST_TO_RUN}"
    fi
}

get_param_value_from_settings() {
    local param=$1; shift
    local tmp_file=$1; shift
    local param_value=`grep ${param} ${CUR_DIR}/${SETTINGS}`
    local value=${param_value#*=}
    echo ${value} > $tmp_file
}

create_vm_for_jobs(){
    local tmp_file=`mktemp`
    get_param_value_from_settings "vapp_jboss_template_id" "$tmp_file"
    local vapp_template_id=`cat $tmp_file`
    get_param_value_from_settings "vapp_node_size" "$tmp_file"
    local vapp_node_size=`cat $tmp_file`
    get_param_value_from_settings "vapp_network_id" "$tmp_file"
    local vapp_network_id=`cat $tmp_file`
    get_param_value_from_settings "vapp_storage_profile" "$tmp_file"
    local vapp_storage_profile=`cat $tmp_file`
    get_param_value_from_settings "channel_code" "$tmp_file"
    local channel_code=`cat $tmp_file`
    get_param_value_from_settings "application_code" "$tmp_file"
    local application_code=`cat $tmp_file`
    get_param_value_from_settings "org_code" "$tmp_file"
    local org_code=`cat $tmp_file`
    get_param_value_from_settings "group_code" "$tmp_file"
    local group_code=`cat $tmp_file`
    
    local jobs=($1); shift
    local i=0;
    for ((i=0; i<${#jobs[*]}; i++))
    do
        echo "Creating node for the ${jobs[$i]}"
        #FIXME: don't use undeclared global variable in a function
        provision_vm "$vapp_template_id" "$vapp_node_size" "$vapp_network_id" "$vapp_storage_profile"\
            "${jobs[$i]}@${JOB_NAME}_${BUILD_NUMBER}" "$channel_code" "$application_code" "$org_code" "$group_code" || { exit 1; }
        vm=($vmstr)
        vm_id=${vm[0]}
        vm_name=${vm[1]}
        vm_ip=${vm[2]}
        echo "  -> vm   id: ${vm_id}"
        echo "  -> vm name: ${vm_name}"
        echo "  -> vm   ip: ${vm_ip}"
        IP_LIST+="$vm_ip "
    done
}

main(){
    local previous_version=`thor version:current`
    echo "Current cookbooks version is ${previous_version}"
    local diff_file="diff_$previous_version"
    
    #clean up workspace
    rm -f diff_*
    rm -f $TRIGGER_PROPERTIES
    rm -f cookbooks-*.tar.gz

    cookbooks="cookbooks-${BUILD_NUMBER}.tar.gz"
    #Create archive of cookbooks. Jenkins will save it as build artifact
    git archive --format tar HEAD | gzip > $cookbooks
    
    local deps_file="dependencies"
    if [ -z "${JOB_LIST_TO_RUN}" ]
    then
        #and will be used for downstream test jobs
        git diff $previous_version HEAD --name-only > $diff_file
        echo "Looking for changes"
        for json in `ls ${CUR_DIR}/jsons/`
        do
            get_dependencies $json $diff_file $deps_file
            if [ -z "`cat ${deps_file}`" ]
            then
                echo "No changes for the ${json}"
            else
                add_job_to_runlist $json
            fi
        done
        if [ -z "$JOB_LIST_TO_RUN" ]
        then
            echo "Nothing to run. List of jobs to run is empty."
            exit 0 
        else
            echo "Generated list of jobs to run:"
            echo "$JOB_LIST_TO_RUN"
        fi
    else
        echo "Provided list of jobs to run:"
        echo "$JOB_LIST_TO_RUN"
    fi
    create_vm_for_jobs "${JOB_LIST_TO_RUN}"
    
    #save parameters for downstream jobs to the trigger file
    #downstream jobs will use cookbooks_url to download cookbooks
    local url="COOKBOOKS_URL=${HUDSON_URL}/job/${JOB_NAME}/ws/${cookbooks}"
    echo $url >> $TRIGGER_PROPERTIES
    #save run list into file
    echo "JOB_LIST_TO_RUN=$JOB_LIST_TO_RUN" >> $TRIGGER_PROPERTIES
    echo "IP_LIST=$IP_LIST" >> $TRIGGER_PROPERTIES
    #clean up workspace from tmp files
    rm -rf diff_*
}
main "$@"
