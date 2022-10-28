.PHONY: build-infra configure-infra destroy-infra

#.EXPORT_ALL_VARIABLES:
INFRA_DIR = ./iac-for-labs
TF_OUTPUT_CONTROL_PLANE_IP_NAME = vm1-ip
TF_OUTPUT_WORKER_NODE_IP_NAME = vm2-ip
TF_VM_USER ?= k8slab_2VMS
TF_VM_USER_PASSWD ?= k8slab_2VMS_576

LF_USER_NAME ?= LFtraining
LF_USER_PASSWORD ?= Penguin2014

.ONESHELL:
--all: build-infra configure-infra
	@echo "---------------------------------"

build-infra:
	@echo "---------------------------------"
	@set -e
	@cd "${INFRA_DIR}"
	@terraform init
	@terraform validate
	@terraform apply -var username="${TF_VM_USER}" -var password="${TF_VM_USER_PASSWD}" --auto-approve
	@terraform refresh

configure-infra:
	@echo "---------------------------------"
	@set -e
	@cd ansible
	@./config.sh ${TF_OUTPUT_CONTROL_PLANE_IP_NAME} ${TF_OUTPUT_WORKER_NODE_IP_NAME} ${TF_VM_USER} ${TF_VM_USER_PASSWD}
	@./play.sh ${LF_USER_NAME} ${LF_USER_PASSWORD}
	@if [ -f "/tmp/join-command.sh" ]; then rm /tmp/join-command.sh; fi

destroy-infra:
	@echo "---------------------------------"
	@set -e
	@cd "${INFRA_DIR}"
	@terraform destroy --auto-approve
