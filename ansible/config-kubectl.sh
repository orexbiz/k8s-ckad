#!/bin/bash

set -e
IAC_DIR="../iac-for-labs"
K8S_CONF="/tmp/k8s_config"

cd "$( dirname ${BASH_SOURCE[0]})"

if [ ! -f "${HOME}/.kube/config.bkp" -a -f "${HOME}/.kube/config" ]; then 
    cp ${HOME}/.kube/config ${HOME}/.kube/config.bkp
fi

if [ -f ${K8S_CONF} ]; then

    CP_PUBLIC_IP=$( terraform -chdir=${IAC_DIR}   output  -raw $1 )
    CP_PRIVATE_IP=$( terraform -chdir=${IAC_DIR}  output  -raw $2 )

    sed -i s/${CP_PRIVATE_IP}/${CP_PUBLIC_IP}/g ${K8S_CONF}

    cp ${K8S_CONF} ${HOME}/.kube/config
    chmod u+rw,g-rwx,o-rwx ${HOME}/.kube/config

    kubectl config unset clusters.kubernetes.certificate-authority-data
    kubectl config set clusters.kubernetes.insecure-skip-tls-verify true

    rm ${K8S_CONF}
else
    echo "${K8S_CONF} not found"
    exit 1
fi
