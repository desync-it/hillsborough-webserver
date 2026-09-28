REGISTRY   ?= quay.io/desync
IMAGE_NAME ?= hillsborough-webserver
IMAGE_TAG  ?= v1.0

IMAGE := $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
LATEST := $(REGISTRY)/$(IMAGE_NAME):latest

.PHONY: all build push clean

all: build push clean

build:
	podman build     \
	  --no-cache     \
	  --squash-all . \
	  -t $(IMAGE)    \
	  -t $(LATEST)

push:
	podman push $(IMAGE) \
	&& \
	podman push $(LATEST)

clean:
	@printf "\033[0;91m==> Removing $(IMAGE) and $(LATEST)\033[0m\n"
	podman rmi -f $(IMAGE) -f $(LATEST) || true
