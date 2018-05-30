#!/bin/bash

check_job_is_not_running() {
    local job=$1; shift
    local build_number=$1; shift
    local tmp_file=`mktemp` || exit 1 
    get_build_status "$job" "$build_number" "${tmp_file}"
    local status=`cat ${tmp_file}`
    while [ "$status" == "true" ]
    do
        echo "$job job is running. Waiting 30 sec for completion."
        sleep 30
        get_build_status "$job" "$build_number" "${tmp_file}"
        status=`cat ${tmp_file}`
    done
    rm -f ${tmp_file}
    echo "${job} job is not running"
}

start_job_building() {
    local job=$1; shift
    local cookbooks_url=$1; shift
    local seci_branch=$1; shift
    local cookbooks_branch=$1; shift
    local url="${HUDSON_URL}/job/${job}/buildWithParameters"
    url+="?token=ABCD12345"
    url+="&COOKBOOKS_URL=${cookbooks_url}"
    url+="&SECI_BRANCH=${seci_branch}"
    url+="&COOKBOOKS_BRANCH=${cookbooks_branch}"

    echo $url

    local res=`curl -s -w %{http_code} $url`
    if [ "$res" == "302" ] || [ "$res" == "200" ] || [ "$res" == "201" ]
    then
        echo "Started $job job"
    else
        echo "Jenkins returns $res http code of build starting. Exiting."
        exit 1
    fi
}

get_build_status(){
    local job=$1; shift
    local build_number=$1; shift
    local tmp_file=$1; shift
    #save xml element value into $tmp_file
    get_xml_element_value $job $build_number "building" $tmp_file
}

get_xml_element_value(){
    local job=$1; shift
    local build_number=$1; shift
    local var=$1; shift
    local tmp_file=$1; shift

    local url="${HUDSON_URL}/job/${job}/${build_number}/"
    url+="api/xml?xpath=/*/$var"
    local var_xml=`curl -s "$url"`
    local exit_code=$?
    if [ $exit_code != 0 ]
    then
        echo "curl exit code is $exit_code. Exiting."
        exit 1
    fi
    local value=`echo $var_xml | \
        sed -e "s/<${var}>//g" -e "s/<\/${var}>//g"`
    if [ -z "$value" ]
    then
        echo "Xml element <$var> is empty. Exiting."
        exit 1
    else
        echo $value > "$tmp_file"
    fi
}

get_running_build_number(){
    local job=$1; shift
    local build_number=$1; shift
    local tmp_file=$1; shift

    get_build_status $job $build_number $tmp_file
    local status=`cat $tmp_file`
    #wait for 24*5 seconds 
    local i=0
    while [ "$status" != "true" ] && (( $i < 25 ))
    do
        ((i++))
        [[ $i == 24 ]] && { 
            echo "Waited for 2 min. $job job has not been started."
            echo "Or may be started and failed."
        }
        echo "Waiting 5 sec for ${job} job build start"
        sleep 5
        get_build_status $job $build_number $tmp_file
        status=`cat $tmp_file`
    done
    #save build number into $tmp_file
    get_xml_element_value $job $build_number "number" $tmp_file
}

waiting_for_build_completion(){
    local jobs=($1); shift
    local builds=($1); shift
    local length=$1; shift
    local tmp_file=`mktemp` || exit 1 
    local checker=$length
    local i=0
    while [ $checker != 0 ]
    do
        for ((i=0; i<$length; i++))
        do
            get_build_status ${jobs[$i]} ${builds[$i]} "$tmp_file"
            local status=`cat $tmp_file`
            if [ "$status" != "true" ]
            then
                echo "The ${jobs[$i]}/${builds[$i]} is completed."
                ((checker--))
            else
                echo "The ${jobs[$i]}/${builds[$i]} is still running."
            fi
        done
        if [ $checker != 0 ]
        then
            checker=$length
            echo "Waiting 30 seconds for job builds completion."
            sleep 30
        fi
    done
}

get_results(){
    local jobs=($1); shift
    local builds=($1); shift
    local length=$1; shift
    local tmp_file=$1; shift
    local test_results="SUCCESS"
    local i=0
    for ((i=0; i<$length; i++))
    do
        get_xml_element_value ${jobs[$i]} ${builds[$i]} "result" "$tmp_file"
        local result=`cat $tmp_file`
        [[ "$result" != "SUCCESS" ]] && test_results=$result
        echo "${jobs[$i]}/${builds[$i]} result is $result."
    done
    echo $test_results > "$tmp_file"
}


main(){

    local cookbooks_url=${COOKBOOKS_URL}
    local jobs=($JOB_LIST_TO_RUN)
    local seci_branch=($SECI_BRANCH)
    local cookbooks_branch=($COOKBOOKS_BRANCH)
    local -i len_jobs=${#jobs[*]}
    local tmp_file=`mktemp` || exit 1 
  
    local builds=()
    local i=0
    for ((i=0; i<$len_jobs; i++))
    do
        check_job_is_not_running ${jobs[$i]} "lastBuild"
        start_job_building ${jobs[$i]} ${cookbooks_url} ${seci_branch} ${cookbooks_branch}
        get_running_build_number ${jobs[$i]} "lastBuild" ${tmp_file}
        builds[$i]=`cat "${tmp_file}"`
    done
    echo "------------------------------------------------------"
    echo "Jobs are started"
    echo "------------------------------------------------------"
    echo "Waiting for jobs completion"
    waiting_for_build_completion "${jobs[*]}" "${builds[*]}" "$len_jobs"
    echo "------------------------------------------------------"
    echo "Started jobs has completed"
    echo "------------------------------------------------------"
    echo "Getting results"
    get_results "${jobs[*]}" "${builds[*]}" "$len_jobs" "${tmp_file}"
    local results=`cat ${tmp_file}`
    if [ "$results" != "SUCCESS" ]
    then
        echo "Triggered tests have failed tests. Set build status to FAILED."
        exit 1
    else
        echo "Tests passed successfully."
    fi
}

main "$@"
