#!/bin/bash
#title           : CHef HA Server Build Automation
#description     : Script is used for setting up an entire Chef HA Cluster for any environment
#author          : ifs_ecom_automation@macys.com
#date            : 2016.07.14
#version         : 0.1
#usage           : chef_ha_setup.sh
#==============================================================================

bkend_list="$BACKEND_LIST"
frend_list="$FRONTEND_LIST"

bkend_url="$BACKEND_URL"
frend_url="$FRONTEND_URL"

usrname="$USERNAME"
usrpass="$PASSWORD"
usrans="yes"
install_dir="~/chef-ha"

# Ensure that all servers are accessible from the jenkins server or jumpbox before execution of script

key_copy() {
	# Copy keys from Jenkins server to all servers on list
/usr/bin/expect <<EOF
   set timeout -1
   spawn ssh-copy-id ${usrname}@${serv} 
   expect "yes/no" { send "${usrans}\r" }
   expect "ssword:" { send "${usrpass}\r" }
   expect "\$ " { send "exit\r" }
EOF

   # Copy keys from leader to all other servers
/usr/bin/expect <<EOF
   set timeout -1
   spawn ssh -o StrictHostKeyChecking=no ${usrname}@${bkendl}
   expect "yes/no" { send "${usrans}\r" }
   expect "ssword:" { send "${usrpass}\r" }
   expect "\$ " { send "ssh-copy-id ${username}@${serv}\r" }
   expect "yes/no" { send "${usrans}\r" }
   expect "ssword:" { send "${usrpass}\r" }
   expect "\$ " { send "exit\r" }
EOF

}


ha_bk_setup() {

# Install and setup the backend servers
# Setting up backend Leader

for bkendl in `echo $bkend_list | awk '{print $1}'`; do
	#getting the IP address of the backend node
	ip_bkendl="`nslookup $bkendl | grep -Ai1 name | grep -i address | cut -d":" -f2`"
	pkg_name="`echo $bkend_url | awk -F / '{print $NF}'`"

	echo -e "Setting up backend node \"$bkendl\"."
/usr/bin/expect <<EOF
   	set timeout -1
   	spawn ssh ${usrname}@${bkendl}
   	expect "\$ " { send "mkdir ${install_dir}; cd ${install_dir}\r" }
   	expect "\$ " { send "curl -LkO ${bkend_url}\r" }
   	expect "\$ " { send "sudo rpm -ivh ${pkg_name}\r" }
   	expect "\$ " { send "sudo echo "publish_address '$ip_bkendl'" >> /etc/chef-backend/chef-backend.rb\r" }
   	expect "\$ " { send "sudo chef-backend-ctl create-cluster\r" }
   	expect "\$ " { send "for serv in `echo $bkend_list | awk '{$1=""; print}'`; do sudo rsync -avzh /etc/chef-backend/chef-backend-secrets.json ${usrname}@${serv}:${install_dir}; done\r" }
   	expect "\$ " { send "for serv in $frend_list; do sudo chef-backend-ctl gen-server-config ${serv} -f chef-server.rb.${serv}; done\r" }
   	expect "\$ " { send "for serv in $frend_list; do sudo rsync -avzh chef-server.rb.* ${usrname}@${serv}:${install_dir}; rm -rf chef-server.rb.*; done\r" }
   	expect "\$ " { send "exit\r" }
EOF
done


# Setting up backend Followers

for bkendf in `echo $bkend_list | awk '{$1=""; print}'`; do
	#getting the IP address of the backend node
	ip_bkendf="`nslookup $bkendf | grep -Ai1 name | grep -i address | cut -d":" -f2`"
	pkg_name="`echo $bkend_url | awk -F / '{print $NF}'`"

	echo -e "Setting up backend node \"$bkendf\"."
	ssh
/usr/bin/expect <<EOF
   	set timeout -1
   	spawn ssh ${usrname}@${bkendf}
   	expect "\$ " { send "mkdir ${install_dir}; cd ${install_dir}\r" }
   	expect "\$ " { send "curl -LkO ${bkend_url}\r" }
   	expect "\$ " { send "sudo rpm -ivh ${pkg_name}\r" }
	expect "\$ " { send "sudo chef-backend-ctl join-cluster ${ip_bkendl} -s ${install_dir}/chef-backend-secrets.json\r"}
	expect "continue." { send "\r" }
    send "\r"
    expect ":" { send "q" }
    expect "cancel: " { send "yes\r" }
    expect ": " { send "1\r" }
	expect "\$ " { send "rm -rf ${install_dir}/chef-backend-secrets.json\r" }
	expect "\$ " { send "sudo chef-backend-ctl reconfigure\r" }
	expect "\$ " { send "exit\r" }
EOF
done

}


ha_fr_setup() {

# Setting up the Frontend servers

for frendl in `echo $frend_list | awk '{print $1}'`; do
	# getting the IP address of the backend node
	ip_frendl="`nslookup $frendl | grep -Ai1 name | grep -i address | cut -d":" -f2`"
	pkg_name="`echo $frend_url | awk -F / '{print $NF}'`"

	echo -e "Setting up Frontend node \"$frendl\"."
/usr/bin/expect <<EOF
   	set timeout -1
   	spawn ssh ${usrname}@${frendl}
   	expect "\$ " { send "mkdir ${install_dir}; cd ${install_dir}\r" }
   	expect "\$ " { send "curl -LkO ${frend_url}\r" }
   	expect "\$ " { send "sudo rpm -ivh ${pkg_name}\r" }
   	expect "\$ " { send "sudo cp chef-server.rb.${frendl} /etc/opscode/chef-server.rb\r" }
   	expect "\$ " { send "for serv in `echo $frend_list	| awk '{$1=""; print}'`; do cd /etc/opscode; sudo rsync -avzh *.pem private-*.json ${usrname}@${serv}:${install_dir}; done\r" }
   	expect "\$ " { send "for serv in `echo $frend_list	| awk '{$1=""; print}'`; do sudo rsync -avzh /var/opt/opscode/upgrades/migration-level ${usrname}@${serv}:${install_dir}; done\r" }
   	expect "\$ " { send "sudo chef-server-ctl reconfigure\r" }
   	expect "\$ " { send "sudo chef-server-ctl install chef-manage\r" }
   	expect "\$ " { send "sudo chef-server-ctl reconfigure\r" }
   	expect "\$ " { send "sudo chef-manage-ctl reconfigure\r" }
  	expect "\$ " { send "exit\r" }
EOF


for frendf in `echo $frend_list	| awk '{$1=""; print}'`; do
	# getting the IP address of the backend node
	ip_frendf="`nslookup $frendf | grep -Ai1 name | grep -i address | cut -d":" -f2`"
	pkg_name="`echo $frend_url | awk -F / '{print $NF}'`"

	echo -e "Setting up Frontend node \"$frendf\"."
/usr/bin/expect <<EOF
   	set timeout -1
   	spawn ssh ${usrname}@${frendf}
   	expect "\$ " { send "mkdir ${install_dir}; cd ${install_dir}\r" }
   	expect "\$ " { send "curl -LkO ${frend_url}\r" }
   	expect "\$ " { send "sudo rpm -ivh ${pkg_name}\r" }
   	expect "\$ " { send "sudo cp chef-server.rb.${frendf} /etc/opscode/chef-server.rb\r" }
   	expect "\$ " { send "sudo mkdir -p /var/opt/opscode/upgrades/\r" }
   	expect "\$ " { send "sudo cp migration-level /var/opt/opscode/upgrades/\r" }
   	expect "\$ " { send "sudo touch /var/opt/opscode/bootstrapped\r" }
   	expect "\$ " { send "sudo chef-server-ctl reconfigure\r" }
   	expect "\$ " { send "sudo chef-server-ctl install chef-manage\r" }
   	expect "\$ " { send "sudo chef-server-ctl reconfigure\r" }
   	expect "\$ " { send "sudo chef-manage-ctl reconfigure\r" }
	expect "\$ " { send "exit\r" }
EOF

}


#ha_wk_setup() {

# Not in scope. Can be added on demand

#}


# Verifying and setting up authentication methods for the servers

for serv in $bkend_list $frend_list; do
	echo -e "Verifying access to \"$serv\"."
	if [ `ssh -o PasswordAuthentication=no ${usrname}@${serv} "hostname"` = "$serv" ]; then
		echo "	--> Authentication to node $serv is Successful."
	else
		echo "	--> Setting up authentication methods ..... WAIT"
		key_copy
		sleep 2
		echo "	--> Authentication to node $serv is Successful."
	fi
done

# Calling the functions to perform the taks for the list of servers

echo -n " Setting up Backend Cluster ................. "; ha_bk_setup; echo " COMPLETED."
echo -n " Setting up Frontend Cluster ................. "; ha_fr_setup; echo " COMPLETED."
