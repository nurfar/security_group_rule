#!/bin/bash

validate_sg_exist() {
	if ! [ "$sg_from_sg_object" = "$sg_name" ]; then
    	echo "Entered Security group $sg_name   doesn't exists in AWS. Please input right value of Security group."
    	exit 2
	else
		echo "Entered Security group $sg_name exists in AWS."
	fi
}

add_ip() {
	check_ip_in_sg=$(echo "$list_sg_group" | jq -r  '.SecurityGroups[] | select(.GroupName=="'$sg_name'").IpPermissions[].IpRanges[].CidrIp' | awk -F '/' '{print $1}')
	if  [[ $check_ip_in_sg =~ $public_ip ]]; then
		echo "Brother your IP $check_ip_in_sg address is already present in Sandbox DB Security group $sg_name"
		exit 3
	elif ! [[ $check_ip_in_sg =~ $public_ip ]]; then 
		aws ec2 authorize-security-group-ingress --group-id "$get_sg_id" --protocol tcp --port 1000 --cidr $public_ip/32  >/dev/null 2>&1
		if  [ $? -eq 0 ]; then
			echo "Brother script added your IP $public_ip  address to Sandbox DB Security Group $sg_name"
		fi
	fi
}

remove_ip() {
	check_ip_in_sg=$(echo "$list_sg_group" | jq -r  '.SecurityGroups[] | select(.GroupName=="'$sg_name'").IpPermissions[].IpRanges[].CidrIp'  | awk -F '/' '{print $1}')
	read -p "Please enter IP address: "  ip
	if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Entered IP $ip is valid" 
		aws ec2 revoke-security-group-ingress --group-id $get_sg_id --protocol tcp --port 1000 --cidr $ip/32  >/dev/null 2>&1
		if [ $? -eq 0 ]; then 
			echo "Brother entered IP $ip address removed from $sg_name"
			exit 555
		else 
			echo "Brother entered IP $ip address doens't exists in Sandbox DB Security Group $sg_name"
			exit 77
		fi
	else 
		echo "Entered IP address is invalid"
	fi
}