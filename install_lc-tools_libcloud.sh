#!/bin/bash

prepare_tar_ball() {
    local repo_name=$1;

    echo "repo_name "${repo_name}

    echo "clean up libcloud directory"
    [[ -d "$repo_name" ]] && rm -rf $repo_name


    echo "clean libcloud.tar if it exists"    
    if [ libcloud.tar ]
    then        
        rm -rf libcloud.tar
    fi

    echo "clone libcloud from gitlab"    
    git clone git@segitlab.cistages.fds:devops/${repo_name}.git

    echo "create libcloud.tar file"    
    tar cvf libcloud.tar libcloud
}

install_drivers_in_other_jenkins() {
    local ip=$1;
    echo "processing ip address ${ip}"    
    scp libcloud.tar chefsolo@$ip:~    
    ssh chefsolo@$ip "sudo chown -R chefsolo:chefsolo ~/libcloud"    
    ssh chefsolo@$ip "rm -rf libcloud"    
    ssh chefsolo@$ip "tar -xvf libcloud.tar && rm -rf libcloud.tar"    
    ssh chefsolo@$ip "cd ~/libcloud && sudo python setup.py install && cd ~"
}

install_drivers_in_current_jenkins () {
    echo "Run sudo python setup.py install in current work space"
    echo "Change the current directory to libcloud"
    local_server=`uname -n`    
    scp libcloud.tar chefsolo@$local_server:~    
    ssh chefsolo@$local_server "sudo chown -R chefsolo:chefsolo ~/libcloud"    
    ssh chefsolo@$local_server "rm -rf libcloud"    
    ssh chefsolo@$local_server "tar -xvf libcloud.tar && rm -rf libcloud.tar"        
    ssh chefsolo@$local_server "cd ~/libcloud && sudo python setup.py install && cd ~" 
}


main(){
    local ips=($IP_LIST)
    local -i len_ips=${#ips[*]}
    local i=0

    echo "-----------------------------------------------------------------------"
    echo "Starting to install libcloud on the current Jenkins Server"
    echo "move tar ball to other servers and run install there"
    echo "-----------------------------------------------------------------------"
    prepare_tar_ball $repo_name

    echo "------------------------------------------------------------------------"
    echo "Starting to install libcloud on the current Jenkins Servers"
    echo "move tar ball to other servers and run install there"
    echo "------------------------------------------------------------------------"

    install_drivers_in_other_jenkins ${ips[$i]}

    ####echo "------------------------------------------------------------------"
    ####echo "Starting to install libcloud on other Jenkins Servers"
    ####echo "move tar ball to other servers and run install there"
    ####echo "------------------------------------------------------------------"
    ####for ((i=0; i<$len_ips; i++))
    ####do
    ####    install_drivers_in_other_jenkins ${ips[$i]}
    ####done

    ####install_drivers_in_current_jenkins

    echo "------------------------------------------------------------------"
    echo "install libcloud on Jenkins Servers job has completed"
    echo "------------------------------------------------------------------"
}

main "$@"
