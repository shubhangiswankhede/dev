#!/bin/bash

# Fail on error
set -e
set -x 

function expect_password {
    expect -c "\
    set timeout 90
    set env(TERM)
    spawn $1
    expect \"password:\"
    send \"$2\r\"
    expect eof
  "
}

# ARG parsing
user=$(cut -d '@' -f1 <<<$1)
remote_location=$(cut -d '@' -f2 <<<$1)
chef_repo_version=$2
json_template=$3

# if starts with a number then it's an ip
if [[ $remote_location = [0123456789]* ]];then
    vm_ip=$remote_location
    vm_host=$(dig +short -x $vm_ip|cut -d '.' -f1)
  else
    vm_host=$remote_location
    vm_ip=$(dig +short +search $vm_host)
fi

# Download and extract chef-repo
rm -rf chef-repo
mkdir chef-repo
curl ${COOKBOOKS_URL} | tar xz --strip-components=1 -C chef-repo

# Generate customized json
IP_ADDRESS=$vm_ip HOSTNAME=$vm_host\
     perl -pe 's/%%(.*?)%%/defined $ENV{$1} ? $ENV{$1} : $&/eg'\
     jsons/${json_template}.json > chef-repo/nodes/node.json

# FIXME: This will be backed into OS+CHEF in the future
# Allow jenkins key-based ssh
ssh-keygen -r ${vm_ip}
ssh-keygen -r ${vm_host}
ssh-keyscan -t rsa ${vm_ip} >> $HOME/.ssh/known_hosts
ssh-keyscan -t rsa ${vm_host} >> $HOME/.ssh/known_hosts

# If we can't ssh in, install key using chefsolo default pass 
#(this code will allow this script to rerun against same host)
if ! ssh -o PasswordAuthentication=no $user@$VM_IP 'exit 0'
then
    pwdfile="tmp_pwd_file"
    python -u escape_bash_spec_chars.py "${PASSWORD}" "$pwdfile"
    password=`cat ${pwdfile}`
    expect_password\
        "ssh-copy-id -i $HOME/.ssh/id_rsa.pub $user@${vm_ip}" $password
    rm -f ${pwdfile}
fi

# Extract and execute cookbook
rsync -e "ssh -o StrictHostKeyChecking=no"\
    -lrp --delete chef-repo $user@${vm_ip}:
ssh -o 'StrictHostKeyChecking=no' $user@${vm_ip} -- \
    'cd chef-repo; sudo chef-solo -j nodes/node.json -c solo.rb -Fdoc'

echo "Chef run complete"

pushd chef-repo/cucumber
    [[ $JENKINS_URL ]] && cucumber_opts="-f json -o ../../cucumber.json"
    env_ip=$vm_ip env_user=$user env_pass=$password\
        cucumber -t "@$json_template" $cucumber_opts
popd

echo "ATDD run complete"
