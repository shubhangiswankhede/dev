#!/bin/bash	

declare TRIGGER_PROPERTIES="paramaterizedTrigger.properties"
source SE-CI/ci_functions.sh

main(){
    local chefdir="all_chefs/"
    
    #clean up workspace
    rm -f $TRIGGER_PROPERTIES
    rm -f cookbooks-*.tar.gz

    # gather and vendor dependencies using berks
    cd $chefdir && berks install && berks update && berks vendor cookbooks && cd ..

    # Create archive of cookbooks. Jenkins will save it as build artifact
    cookbooks="cookbooks-${COOKBOOKS_BRANCH}-${BUILD_NUMBER}.tar.gz"
    cd $chefdir && tar -zcf ../$cookbooks * && cd ..
    
}
main "$@"
