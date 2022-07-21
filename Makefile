.PHONY: init plan apply destroy

init:
	./scripts/setup-0_init.sh || (echo "Init failed"; exit 0)

plan:
	${TF} -chdir=./terraform plan ${TFVAR}

apply:
	${TF} -chdir=./terraform apply ${TFVAR} -auto-approve

destroy:
	${TF} -chdir=./terraform destroy ${TFVAR} -auto-approve