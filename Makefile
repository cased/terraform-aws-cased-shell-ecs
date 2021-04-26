pwd = $(shell pwd)

docs: USAGE.md
USAGE.md: .terraform-docs.yml
	docker run -w $(pwd) -v $(pwd):$(pwd) quay.io/terraform-docs/terraform-docs:0.12.1 markdown . > USAGE.md