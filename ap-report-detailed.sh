########################################################
############### SYNGENTA-PATCHING ######################
################ CREATED-BY- DEEPAK.BEHERA@NORDCLOUD.COM
########################################################

#!/bin/bash
echo "Generating the report using Autopatcher CLI - please confirm if you have entered correct vaules in the report.txt file TYPE-y/n:-"
read inp
if [ $inp == "y" ]; then
mkdir report
for i in $(cat report.txt); do
    eid=$(echo $i | cut -d ":" -f 1)
    jid=$(echo $i | cut -d ":" -f 2)
    echo "Searching in eventid $eid ......"
    echo "inserting the data into the file for $jid ......"
    nc-autopatcher-cli event get_report --id $eid | jq -r '.patched_machines | to_entries[] | [.key, .value.name, .value.status, (.value.installed // [] | join(",")), (.value.updated // [] | join(","))] | @csv' >> ./report/$jid.csv &&
    nc-autopatcher-cli event get_report --id $eid | jq -r '.not_patched_machines | to_entries[] | [.key, .value.name, .value.status, (.value.installed // [] | join(",")), (.value.updated // [] | join(","))] | @csv' >> ./report/$jid.csv &&
    echo "Report has been generated for the job name -: $jid" &&
    count=$(cat ./report/$jid.csv | wc -l) &&
    echo -e "\e[1;31m Number of machine in the job name -: $jid is -- $count \e[0m"  &&
    echo "===========================================================================" ; done
else
    echo -e "\e[1;42m You have not created a file named report.txt. hence creating one for you:- Please open the file and mention the Event id in the file \e[0m"
    touch report.txt
fi
