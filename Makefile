.PHONY: init plan apply destroy

init:
	./scripts/setup-0_init.sh || (echo "Init stage failed"; exit 0)

plan:
	./scripts/setup-4_plan.sh || (echo "Plan stage failed"; exit 0)

apply:
	./scripts/setup-6_apply.sh || (echo "Apply stage failed"; exit 0)

destroy:
	./scripts/setup-7_destroy.sh || (echo "Destroy stage failed"; exit 0)
