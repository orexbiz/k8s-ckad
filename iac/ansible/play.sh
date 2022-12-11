#!/bin/bash

set -e

INVENTORY_FILE="inventory.ansible.yaml"
PLAYBOOK_FILE="playbook.ansible.yaml"
IAC_DIR="../iac-for-labs"

if [ ! -f "${INVENTORY_FILE}" -o ! -f "${PLAYBOOK_FILE}" ]; then
    echo "[ERROR]: missing inventory file"
    exit 1
fi

cd "$( dirname ${BASH_SOURCE[0]})"
ansible-playbook -vv -i ${INVENTORY_FILE} ${PLAYBOOK_FILE} --extra-vars "NAME=$1" --extra-vars "PASSWD=$2"
