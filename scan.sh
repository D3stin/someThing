#!/bin/bash
rm -r /tmp/temp.txt
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "$line"
	nmap -p 22-23 $line >> /tmp/temp.txt
	temp=`cat /tmp/temp.txt`
echo $temp
#sleep 10
	if [[ $temp == *"failed to determine route"* ]]
	then
	echo "error"
	else
	if [[ $temp == *"No targets were specifie"* ]]
	then
	echo "error"
	else
	if [[ $temp == *"0 hosts up"* ]]
	then
	echo "error"
	else
        if [[ $temp == *"0 hosts scanned"* ]]
        then
        echo "error"
        else
	if [[ $temp == *"23/tcp filtered"* ]]
        then
        echo "error"
        else
	if [[ $temp == *"23/tcp closed"* ]]
        then
        echo "error"
        else
	if [[ $temp == *"22/tcp filtered"* ]]
        then
        echo "error"
        else
	if [[ $temp == *"22/tcp closed"* ]]
        then
        echo "error"
        else
	echo $temp >> /tmp/scan/$line.txt
	fi
	fi
	fi
	fi
	fi
	fi
	fi
	fi
rm -r /tmp/temp.txt
done < "$1"
