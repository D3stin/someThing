#!/bin/bash
#
# Function: Generate a range of IP Addresses
# Version:  1.1
# Author:   sol@subnetzero.org
#
# v1.1
#
# Convention for octets:  A.B.C.D

# Variable setup section...
#
# Split up IP addresses into seperate variables for each octet
IPLO=(`echo "$1" | awk '{split($1,a,"."); print a[1]" "a[2]" "a[3]" "a[4]}'`)
IPHI=(`echo "$2" | awk '{split($1,a,"."); print a[1]" "a[2]" "a[3]" "a[4]}'`)
#
# Put array contents into nicely named vars for less confusion
#
OCTA=${IPLO[0]}
OCTB=${IPLO[1]}
OCTC=${IPLO[2]}
OCTD=${IPLO[3]}
OCTAHI=${IPHI[0]}
OCTBHI=${IPHI[1]}
OCTCHI=${IPHI[2]}
OCTDHI=${IPHI[3]}
OCTDMAX=255             # Max default value for D Octet to loop to
FINISHED=0              # Variable used for loop state checking

# Syntax sanity check; check all vars are populated etc
for i in 0 1 2 3
do
        if [ -z "${IPLO[$i]}" ] || [ -z "${IPHI[$i]}" ]; then
                echo "Usage: $0 [from ip] [to ip]"
                exit 1
        elif [ "${IPLO[$i]}" -gt "255" ] || [ "${IPHI[$i]}" -gt "255" ];then
                echo "One of your values is broken (greater than 255)."
                exit 1
        fi

done

# Until FINISHED variable is set to 1, loop the loop.
# FINISHED var is used to determine when done as the increments
# to the vars in the loop will mean that when we get to the done
# statement, the values won't be the same as printed.
#
# The D Octet loop is the heart of this script, as it's easiest
# to check whether we've reached the target or not from here.
#
until [ "$FINISHED" -eq "1" ];
do
        # If first 3 octets match hi values, use OCTDHI as max value for 4th octet.
        if [ "$OCTA" -eq "$OCTAHI" ] && \
           [ "$OCTB" -eq "$OCTBHI" ] && \
           [ "$OCTC" -eq "$OCTCHI" ]; then
                OCTDMAX=$OCTDHI
        fi

        # Loop octet D up to OCTDMAX 255 unless above criteria satisfied
        while [ "$OCTD" -le "$OCTDMAX" ];
        do
                # Print out current IP
                ip=`printf "$OCTA.$OCTB.$OCTC.$OCTD\n"`
             
	
#################################################################
#
#
# NOT PART OF ORIGINAL SCRIPT
#
#
################################################################
#
# AUTHOR:D3F@ULT
# DESC: CATCH IP'S, SAN FOR OPEN PORTS 22 AND 23
# DATE: 25.11.2016
#
###############################################################

#make save directory
mkdir /tmp/scan
#remove old files
rm -r /tmp/temp.tx
#Start NMAP Scant
  nmap -p 22-23 $ip >> /tmp/temp.txt
#Write Contents to variable
        temp=`cat /tmp/temp.txt`
#echo $temp
#sleep 10

#filtering of offline hosts and closed or filtered ports 22 and 23
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
#write every up and opened host to file
        echo $temp >> /tmp/scan/$line.txt
        fi
        fi
        fi
        fi
        fi
        fi
        fi
        fi
#remove file
rm -r /tmp/temp.txt


##########################################################################
#
#
# RETURN TO ORIGINAL SCRIPT
#
#
##########################################################################






	   # Check if this is the last IP to print
                if [ "$OCTA" -eq "$OCTAHI" ] && \
                   [ "$OCTB" -eq "$OCTBHI" ] && \
                   [ "$OCTC" -eq "$OCTCHI" ] && \
                   [ "$OCTD" -eq "$OCTDHI" ]; then
                        FINISHED=1
                fi
                OCTD=$(( $OCTD + 1 ))
        done

        # Now D loop has completed, set C + 1 and reset D to 0
        OCTC=$(( $OCTC + 1 ))
        OCTD="0"

        # if C is over 255 then set B + 1 and reset C to 0
        if [ "$OCTC" -gt "255" ]; then
                OCTB=$(( $OCTB + 1 ))
                OCTC="0"
        fi

        # If B is over 255 then set A + 1 and reset B to 0
        if [ "$OCTB" -gt "255" ]; then
                OCTA=$(( $OCTA + 1 ))
                OCTB="0"
        fi

        # If A is over 255 for whatever reason then set FINISHED=1
        if [ "$OCTA" -gt "255" ]; then
                FINISHED=1
        fi
done
exit 0
