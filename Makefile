# Copyright SecureKey Technologies Inc.
#
# SPDX-License-Identifier: Apache-2.0

DID_REST_PATH=cmd/did-rest

# Namespace for the agent images
DOCKER_OUTPUT_NS                    ?= ghcr.io
DID_REST_IMAGE_NAME                 ?= trustbloc/did-resolver

# Tool commands (overridable)
ALPINE_VER ?= 3.15
GO_VER ?= 1.17

.PHONY: all
all: checks unit-test

.PHONY: checks
checks: license lint

.PHONY: lint
lint:
	@scripts/check_lint.sh

.PHONY: license
license:
	@scripts/check_license.sh

.PHONY: did-rest
did-rest:
	@echo "Building did-rest"
	@mkdir -p ./.build/bin
	@cd ${DID_REST_PATH} && go build -o ../../.build/bin/did-rest main.go

.PHONY: did-resolver-docker
did-resolver-docker:
	@echo "Building did rest docker image"
	@docker build -f ./images/did-rest/Dockerfile --no-cache -t $(DOCKER_OUTPUT_NS)/$(DID_REST_IMAGE_NAME):latest \
	--build-arg GO_VER=$(GO_VER) \
	--build-arg ALPINE_VER=$(ALPINE_VER) .

.PHONY: docker
docker: did-resolver-docker

unit-test:
	@scripts/check_unit.sh

.PHONY: clean
clean: clean-build

.PHONY: clean-build
clean-build:
	@rm -Rf ./.build
