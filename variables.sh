#!/usr/bin/env bash

list_sg_group=$(aws ec2 describe-security-groups)  
if [[ -z $list_sg_group ]]; then echo "AWS json variable is empty"; exit 15; fi
public_ip=`curl -s  ifconfig.me`
sg_from_sg_object=$(echo "$list_sg_group" | jq -r '.SecurityGroups[].GroupName' | grep -w "$sg_name")
get_sg_id=$(echo $list_sg_group | jq -r '.SecurityGroups[] | select(.GroupName=="'$sg_name'").GroupId')