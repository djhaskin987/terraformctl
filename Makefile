VERSION=$(shell cat VERSION)
GIT_SHA=$(shell git rev-parse --verify HEAD)

default: compile
all: default install

compile: ## Create the terraformctl executable in the ./bin directory.
	go build -o bin/terraformctl -ldflags "-X github.com/kris-nova/terraformctl/cmd.GitSha=${GIT_SHA} -X github.com/kris-nova/terraformctl/cmd.Version=${VERSION}" main.go

install: ## Create the terraformctl executable in $GOPATH/bin directory.
	install -m 0755 bin/terraformctl ${GOPATH}/bin/terraformctl

proto: ## Generate the gRPC Go code from the protobuf definition in the service directory.
	protoc -I service/ service/terraformctl.proto --go_out=plugins=grpc:service

.PHONY: help
help:  ## Show help messages for make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'