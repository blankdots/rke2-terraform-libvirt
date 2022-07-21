.PHONY: init plan apply destroy

init:
	./scripts/setup-0_init.sh || (echo "Init failed"; exit 0)

plan:
	./scripts/setup-4_plan.sh || (echo "Plan failed"; exit 0)

apply:
	./scripts/setup-6_apply.sh || (echo "Apply failed"; exit 0)

destroy:
	./scripts/setup-6_destroy.sh || (echo "Destroy failed"; exit 0)
