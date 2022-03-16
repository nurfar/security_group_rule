#!/bin/bash 


if [ $# -ne 2 ]; then echo "Usage: ./$(basename $0) add_or_remove sg_name"; exit 1; fi
add_remove=$1
sg_name=$2

. ./variables.sh
. ./sg_lib.sh 


validate_sg_exist
if [[ $add_remove == 'add' ]]; then  
    add_ip
elif [[ $add_remove == 'remove' ]]; then
    remove_ip
else 
    echo "First arg can be only 'add' or 'remove'. "
    exit 333
fi

# ip_validation

       




# check_ip_in_sg

    