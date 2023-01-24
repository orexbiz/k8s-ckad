#!/bin/bash

set -e

INVENTORY_FILE="inventory.ansible.yaml"
PLAYBOOK_FILE="playbook.ansible.yaml"

cd "$( dirname ${BASH_SOURCE[0]})"

if [ ! -f "${INVENTORY_FILE}" -o ! -f "${PLAYBOOK_FILE}" ]; then
    echo "[ERROR]: missing usefull files (${INVENTORY_FILE},${PLAYBOOK_FILE})"
    exit 1
fi

ansible-playbook -vvvv -i ${INVENTORY_FILE} ${PLAYBOOK_FILE}  #--extra-vars "NAME=$1" --extra-vars "PASSWD=$2"
