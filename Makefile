pwd = $(shell pwd)

test: docs
	bash script/test

docs: USAGE.md
USAGE.md: .terraform-docs.yml variables.tf outputs.tf main.tf
	docker run -w $(pwd) -v $(pwd):$(pwd) quay.io/terraform-docs/terraform-docs:0.12.1 markdown . > USAGE.md