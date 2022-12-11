#!/bin/bash

set -e

INVENTORY_FILE="inventory.ansible.yaml"
INVENTORY_TEMPLATE_FILE="./templates/inventory.ansible.yaml"
INFRA_DIR="../iac-for-labs"

function configure_inventory {
    cp ${INVENTORY_TEMPLATE_FILE} ${INVENTORY_FILE}
    cd ${INFRA_DIR}

    local TF_OUTPUT_CP_IP_NAME="$3"
    local CP_IP=$( terraform output -raw ${TF_OUTPUT_CP_IP_NAME})

    local TF_OUTPUT_WKN_IP_NAME="$4"
    local WK_IP=$( terraform output -raw ${TF_OUTPUT_WKN_IP_NAME})

    local TF_OUTPUT_WKN_2_IP_NAME="$5"
    local WK_2_IP=$( terraform output -raw ${TF_OUTPUT_WKN_2_IP_NAME})

    local _USR_="$1"
    local _PASSWD_="$2"

    cd -
    echo "usr: ${_USR_}"
    echo "pass: ${_PASSWD_}"
    echo "cp_ip: ${CP_IP}"
    echo "wk_ip: ${WK_IP}"
    echo "wk_2_ip: ${WK_2_IP}"

    sed -i s/_USER_NAME_/${_USR_}/g             ${INVENTORY_FILE}
    sed -i s/_USER_PASSWD_/${_PASSWD_}/g        ${INVENTORY_FILE}

    sed -i s/_CONTROL_NODE_IP_/${CP_IP}/g       ${INVENTORY_FILE}
    sed -i s/_WORKER_NODE_IP_/${WK_IP}/g        ${INVENTORY_FILE}
    sed -i s/_WORKER_NODE_2_IP_/${WK_2_IP}/g    ${INVENTORY_FILE}

    ansible-inventory -i ${INVENTORY_FILE} --list
}

#---------------------------
cd "$( dirname ${BASH_SOURCE[0]})"

if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$5" ]; then
    echo "[ERROR]: missing argument"
    exit 1
fi

configure_inventory "$1" "$2" "$3" "$4" "$5"
