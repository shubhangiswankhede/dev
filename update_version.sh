#!/bin/bash

main(){
    local trigger_params=${TRIGGER_PARAMS:-"paramaterizedTrigger.properties"}
    thor version:bump patch
    local exit_code=$?
    [[ $exit_code != 0 ]] && {
        echo "ERROR. Thor exited with $exit_code status. Exiting."
        exit 1
    }
    local new_version=`cat VERSION`
    echo "New git tag is ${new_version}."
    mv "cookbooks-${BUILD_NUMBER}.tar.gz" "cookbooks-${COOKBOOKS_BRANCH}-${new_version}.tar.gz"
    echo "Renamed cookbooks tar ball to cookbooks-${COOKBOOKS_BRANCH}-${new_version}.tar.gz"
    echo "VERSION=$new_version" >> $trigger_params
}
main "$@"