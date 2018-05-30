#!/bin/bash

# Description: Checks for duplicate role json file names and if role file name matches role value names.
# Version : 0.1.0
# Author : SE CD team  (Bhavya Sharma, Lucas Pessoa)


####################################################################################################################
#########################OUTPUTS DUPLICATE ROLE NAMES AND THROWS AN ERROR IF ONE IS FOUND###########################
####################################################################################################################
echo ""
echo ""
echo ""
echo "***************************************************************************************"
echo "Searching For Duplicate Roles"
echo "***************************************************************************************"
#cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
#cd $cwd
cd cookbooks
find roles -name "*.json" -printf "%f\n" > scripts/role_file_names.txt

error_value="0"
duplicate_count=$(sort scripts/role_file_names.txt | uniq -cd)
if ! [ -z $duplicate_count ]; then
    echo ""
    echo "List of duplicate roles found."
    echo ""
    echo "$duplicate_count"
    error_value="1"
fi  
echo ""


####################################################################################################################
####################################CHECKS IF FILENAME MATCHES ROLENAME#############################################
####################################################################################################################
echo "***************************************************************************************"
echo "Checking if any role file name does not match its Role value name."
echo "***************************************************************************************"
echo ""
echo "Please wait. This may take a few minutes..."
echo ""

sed -i "s/.json//g" scripts/role_file_names.txt
for FILE in $(find roles -type f -name "*.json")
do
head -2 $FILE | grep -oP '\"name\".*' >> scripts/role_value_names.txt
done


sed -i "s/\"name\": \"//g" scripts/role_value_names.txt
sed -i "s/\",//g" scripts/role_value_names.txt

echo "List of role file names that do not match their role value name."
echo ""
echo "***************************************************************************************"
echo "Left: Role File Name                                          | Right : Role Value Name"
echo "***************************************************************************************"
diff -a -b --suppress-common-lines -y scripts/role_file_names.txt scripts/role_value_names.txt > scripts/role_name_difference.log
if [ -s scripts/role_name_difference.log ]; then    
    
    cat scripts/role_name_difference.log
    if [ $error_value == "1" ]; then 
        error_value="3"
    else 
        error_value="2"
    fi
fi
echo ""


####################################################################################################################
#######################################FINAL STEPS##################################################################
####################################################################################################################
echo "***************************************************************************************"
echo "Script Results."
echo "***************************************************************************************"
echo ""

rm -rf scripts/role_file_names.txt
rm -rf scripts/role_value_names.txt
rm -rf scripts/role_name_difference.log

if [ $error_value == "1" ]; then
    echo "ERROR: Duplicate role file names found!"
    echo "***************************************************************************************"
    echo ""
    echo ""
    echo ""
    cd ..
    exit 1
elif [ $error_value == "2" ]; then
    echo "ERROR: Role file names that do not match their role value name found!"
    echo "Note: Please make sure the \"name:\" field is on the second line of the role json."
    echo "***************************************************************************************"
    echo ""
    echo ""
    echo ""
    cd ..
    exit 1
elif [ $error_value == "3" ]; then
    echo "ERROR: Duplicate role file names found!"
    echo ""
    echo "ERROR: Role file names that do not match their role value name found!"
    echo "Note: Please make sure the \"name:\" field is on the second line of the role json."
    echo "***************************************************************************************"
    echo ""
    echo ""
    echo ""
    cd ..
    exit 1
else 
    echo "role_name_checks.sh ran Successfully!"
    echo "No duplicate roles found."
    echo "All role file names match their role value names."
    echo "***************************************************************************************"
    echo ""
    echo ""
    echo ""
    cd ..
fi