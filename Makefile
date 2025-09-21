TAG ?= 0.15
APP_NAME = greeting-postgres
IMAGE_NAME = arnecdn/$(APP_NAME)

BREW_PACKAGES := cosign tenv terraform-docs tflint checkov trivy

.PHONY: install all build_image deploy clean validate-tag

install:
	brew tap hashicorp/tap
	brew install $(BREW_PACKAGES)

all: build_image deploy

validate-tag:
	@if ! echo $(TAG) | grep -Eq '^[0-9]+\.[0-9]+$$'; then \
		echo "Error: Invalid tag format. Must be in the form of 'X.Y' where X and Y are integers."; \
		exit 1; \
	fi

build_image: validate-tag
	@echo "Building Docker image directly in Minikube..."
	podman image build -t docker.io/"$(IMAGE_NAME):$(TAG)" -f Dockerfile . || { \
		echo "Error: Docker build failed."; \
		exit 1; \
	}

deploy: build_image
	@echo "Applying Kubernetes deployment..."
	podman save docker.io/"$(IMAGE_NAME):$(TAG)" | minikube image load - || { \
		echo "Error: Failed to load image into Minikube."; \
		exit 1; \
	}

tf-apply:
	@echo "Applying Terraform configuration..."
	cd terraform && terraform init && terraform apply -auto-approve || { \
		echo "Error: Terraform apply failed."; \
		exit 1; \
	}

tf-destroy:
	@echo "Destroying Terraform-managed infrastructure..."
	cd terraform && terraform destroy -auto-approve || { \
  		echo "Error: Terraform destroy failed."; \
  		exit 1; \
  			}

clean:
	@echo "Cleaning up..."
	@echo "Removing image from Minikube..."
	minikube image rm docker.io/$(IMAGE_NAME):$(TAG) 2>/dev/null || true
