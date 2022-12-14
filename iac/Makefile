.PHONY: build-infra configure-infra destroy-infra

#.EXPORT_ALL_VARIABLES:
INFRA_DIR = ./terraform
TF_OUTPUT_CONTROL_PLANE_IP_NAME = vm-a-public-ip
TF_OUTPUT_CONTROL_PLANE_PRIVATE_IP_NAME = vm-a-private-ip
TF_OUTPUT_WORKER_NODE_IP_NAME = vm-b-public-ip
TF_OUTPUT_WORKER_NODE_2_IP_NAME = vm-c-public-ip
TF_VM_USER ?= k8slab_2VMS
TF_VM_USER_PASSWD ?= k8slab_2VMS_576

LF_USER_NAME ?= LFtraining
LF_USER_PASSWORD ?= Penguin2014

__help:
	@echo "---------------------------------"
	@echo "Help:"
	@echo "	make <target>"

.ONESHELL:
__all: build-infra configure-infra configure-cluster
	@echo "---------------------------------"

build-infra:
	@echo "---------------------------------"
	@set -e
	@cd "${INFRA_DIR}"
	@terraform init
	@terraform apply -var username="${TF_VM_USER}" -var password="${TF_VM_USER_PASSWD}" --auto-approve
	@terraform refresh

configure-infra:
	@echo "---------------------------------"
	@set -e
	@cd ansible
	@./config-inventory.sh ${TF_VM_USER} ${TF_VM_USER_PASSWD} ${TF_OUTPUT_CONTROL_PLANE_IP_NAME} ${TF_OUTPUT_WORKER_NODE_IP_NAME} ${TF_OUTPUT_WORKER_NODE_2_IP_NAME}
	@./play.sh ${LF_USER_NAME} ${LF_USER_PASSWORD}
	@if [ -f "/tmp/join-command.sh" ]; then rm /tmp/join-command.sh; fi
	@./config-kubectl.sh ${TF_OUTPUT_CONTROL_PLANE_IP_NAME} ${TF_OUTPUT_CONTROL_PLANE_PRIVATE_IP_NAME}
	@echo "run kubectl get nodes"
	@kubectl get nodes

configure-cluster:
	@echo "---------------------------------"
	@set -e
	@echo "make all nodes accept deployment of pods"
	@kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule- || echo ""
	@kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule- || echo ""
	@kubectl describe node | grep -i taint


destroy-infra:
	@echo "---------------------------------"
	@set -e
	@cd "${INFRA_DIR}"
	@terraform destroy --auto-approve
