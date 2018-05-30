#!/bin/bash

## check is jq is installed
if [[ -f /usr/bin/jq ]]; then
	echo "jq is installed. Thanks."
else
	echo "jq is not installed. Please install jq."
	exit 0
fi


## Static Variables

project_is=$1
migration_dir="repo_migration"
server_01_url="segitlab.cistages.fds"
server_01_token="i_kAQAhjxZ_ikkKvWaKP"

server_02_url="code-dev.devops.fds.com"
server_02_token="23h4gVRpexTqYnPHeZq6"

proj_file_se="projects_se.json"
proj_file_dev="projects_dev.json"

labels_file="labels-se.json"
cl_issues_file="issues_cl.json"
op_issues_file="issues_op.json"
merge_file="merge_req.json"
name_label="name-se-label.txt"
color_label="color-se-label.txt"
label_join="labels.txt"
cl_issues="closed_issues.txt"
cl_iss_mer="closed_issues_merged.txt"
op_issues="opened_issues.txt"
op_iss_mer="opened_issues_merged.txt"
aut_issue="author_username.txt"
ass_issue="assignee_username.txt"
lab_issue="label_issues.txt"
title_issue="title_issues.txt"
desc_issue="description_issues.txt"
cl_issues_id="closed_issues_id.txt"
cl_issues_num="closed_issues_num.txt"
op_issues_id="opened_issues_id.txt"


# Check if repo migration dir exits
cd ~

if [[ -d "repo_migration" ]]; then
	echo "Directory for repository migration exits. Thanks."
	cd $migration_dir
else
	echo -n "Directory for repository migration does not exist. Creating Directory ......... "; mkdir repo_migration; sleep 2; 	echo "COMPLETED."
	cd $migration_dir
fi



## Source the project ID that is to be worked on

curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects > ${proj_file_se}

curl -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects > ${proj_file_dev}

## Project specific data

project_id_se=`cat ${proj_file_se} | jq -r "." | grep -iB3 "/${project_is}\"\,$" | grep -i id | sed -e 's/^[ \t]*//' | tr "," ' ' | awk '{print $2}'`

project_id_dev=`cat ${proj_file_dev} | jq -r "." | grep -iB3 "/${project_is}\"\,$" | grep -i id | sed -e 's/^[ \t]*//' | tr "," ' ' | awk '{print $2}'`



## Script to migrate labels, issues and merge requests between gitlab servers


migrate_labels() {
## Grab the JSON file for all the labels and parse it appropriately to pre for injection via API

  curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects/${project_id_se}/labels > ${labels_file}

  cat ${labels_file} | jq -r ".[].name" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > ${name_label}

  cat ${labels_file} | jq -r ".[].color" > ${color_label}

## Create the merged labels file

  paste ${name_label} ${color_label} | awk '{print "name="$1"&color="$2}' > ${label_join}


## inserting labels into the new server

  for i in `cat ${label_join}`; do
    curl --data "$i" -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects/${project_id_dev}/labels
  done
}



migrate_closed_issues() {

## Grab project ID's for all closed projects

  curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects/${project_id_se}/issues?state=closed | jq -r ".[].id" > $cl_issues_id

## Grab the JSON file for all the closed issues and parse it appropriately to pre for injection via API
for cl_iss_id in `cat $cl_issues_id`; do

  curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects/${project_id_se}/issues/${cl_iss_id} > $cl_issues_file

## Split the issue json file into components to create the insert lines

  cat ${cl_issues_file} | jq -r ".author.username" > ${aut_issue}
  cat ${cl_issues_file} | jq -r ".assignee.name" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > $ass_issue
  cat ${cl_issues_file} | jq -r ".labels" | tr '"' ' ' | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' | xargs | sed -e 's/ //g' > $lab_issue
  cat ${cl_issues_file} | jq -r ".title" | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > $title_issue
  cat ${cl_issues_file} | jq -r ".description" | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > $desc_issue

  # merging all files together

  paste ${aut_issue} ${ass_issue} ${lab_issue} ${title_issue} ${desc_issue} > ${cl_issues}

  cat ${cl_issues} | awk '{print "author.username="$1"&assignee.username="$2"&labels="$3"&title="$4"&description="$5}' > ${cl_iss_mer}

  # Insert entries

  for issue_entry in `cat ${cl_iss_mer}`; do
    curl --data "${issue_entry}" -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects/${project_id_dev}/issues
  done
done
}



mark_closed_issues() {

  curl -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects/${project_id_dev}/issues?state=opened | jq -r ".[].id" > ${cl_issues_num}

    for issue_id in `cat ${cl_issues_num}`; do
    	curl -X PUT -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects/${project_id_dev}/issues/${issue_id}?state_event=close
    done
}



migrate_opened_issues() {

## Grab project ID's for all closed projects

  curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects/${project_id_se}/issues?state=opened | jq -r ".[].id" > $op_issues_id

## Grab the JSON file for all the opened issues and parse it appropriately to pre for injection via API

for op_iss_id in `cat $op_issues_id`; do

  curl -H "PRIVATE-TOKEN: ${server_01_token}" http://${server_01_url}/api/v3/projects/${project_id_se}/issues/${op_iss_id} > ${op_issues_file}

## Split the issue json file into components to create the insert lines

  cat ${op_issues_file} | jq -r ".author.username" > ${aut_issue}
  cat ${op_issues_file} | jq -r ".assignee.name" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > ${ass_issue}
  cat ${op_issues_file} | jq -r ".labels" | tr '"' ' ' | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' | xargs | sed -e 's/ //g' > ${lab_issue}
  cat ${op_issues_file} | jq -r ".title" | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > ${title_issue}
  cat ${op_issues_file} | jq -r ".description" | sed -e 's/\[\|\]//g' | sed -e 's/^[ \t]*//' | grep -v "^$" | sed -e 's/ /\%20/g' -e 's/\%20$//g' > ${desc_issue}

  # merging all files together

  paste ${aut_issue} ${ass_issue} ${lab_issue} ${title_issue} ${desc_issue} > ${op_issues}

  cat ${op_issues} | awk '{print "author.username="$1"&assignee.username="$2"&labels="$3"&title="$4"&description="$5}' > ${op_iss_mer}

  # Insert entries

  for issue_entry in `cat ${op_iss_mer}`; do
    curl --data "${issue_entry}" -H "PRIVATE-TOKEN: ${server_02_token}" https://${server_02_url}/api/v3/projects/${project_id_dev}/issues
  done
done
}


##### MAKE THE CALLS TO PERFORM THE MAGICARY #####

migrate_labels
migrate_closed_issues
mark_closed_issues
migrate_opened_issues
