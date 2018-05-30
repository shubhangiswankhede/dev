#!/bin/bash	

declare -r CUR_DIR="SE-CI/"
declare IP_LIST=""
declare -r SETTINGS='settings'
declare TRIGGER_PROPERTIES="paramaterizedTrigger.properties"
source $CUR_DIR/ci_functions.sh

get_dependencies(){
    local json=$1; shift
    local diff_file=$1; shift
    local deps_file=$1; shift
    local deps="diff_${json/.json/}"
    echo "------------------------------"
    echo "Working on $json"
    [[ -f nodes/${json} ]] && rm -f nodes/${json}
    ln $CUR_DIR/../jsons/$json nodes/${json}
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
    
    #local deps_file="dependencies"
    if [ -z "${JOB_LIST_TO_RUN}" ]
    then
        echo "Nothing to run. List of jobs to run is empty."
        exit 0 
    else
        echo "Provided list of jobs to run:"
        echo "$JOB_LIST_TO_RUN"
    fi
    
    #save parameters for downstream jobs to the trigger file
    #downstream jobs will use cookbooks_url to download cookbooks
    local url="COOKBOOKS_URL=${HUDSON_URL}/job/${JOB_NAME}/ws/${cookbooks}"
    echo $url >> $TRIGGER_PROPERTIES
    #save run list into file
    echo "JOB_LIST_TO_RUN=$JOB_LIST_TO_RUN" >> $TRIGGER_PROPERTIES
    
    #clean up workspace from tmp files
    rm -rf diff_*
}
main "$@"
