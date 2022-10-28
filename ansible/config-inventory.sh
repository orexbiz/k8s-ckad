#!/bin/bash

set -e

INVENTORY_FILE="inventory.ansible.yaml"
INVENTORY_TEMPLATE_FILE="./templates/inventory.ansible.yaml"
INFRA_DIR="../iac-for-labs"

function configure_inventory {
    cp ${INVENTORY_TEMPLATE_FILE} ${INVENTORY_FILE}
    cd ${INFRA_DIR}

    local TF_OUTPUT_CP_IP_NAME="$1"
    local CP_IP=$( terraform output -raw ${TF_OUTPUT_CP_IP_NAME})

    local TF_OUTPUT_WKN_IP_NAME="$2"
    local WK_IP=$( terraform output -raw ${TF_OUTPUT_WKN_IP_NAME})

    cd -

    echo "usr: $3"
    echo "pass: $4"
    echo "cp_ip: ${CP_IP}"
    echo "wk_ip: ${WK_IP}"

    local _USR_="$3"
    local _PASSWD_="$4"
    sed -i s/_CONTROL_NODE_IP_/${CP_IP}/g   ${INVENTORY_FILE}
    sed -i s/_WORKER_NODE_IP_/${WK_IP}/g    ${INVENTORY_FILE}
    sed -i s/_USER_NAME_/${_USR_}/g         ${INVENTORY_FILE}
    sed -i s/_USER_PASSWD_/${_PASSWD_}/g    ${INVENTORY_FILE}

    ansible-inventory -i ${INVENTORY_FILE} --list
}

#---------------------------
cd "$( dirname ${BASH_SOURCE[0]})"

if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    echo "[ERROR]: missing argument"
    exit 1
fi

configure_inventory "$1" "$2" "$3" "$4"
