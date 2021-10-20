SHELL := /bin/bash
VERSION ?= ""
COMMIT ?= $(shell git log -1 --format=%h)

APP_VERSION = ${VERSION}-${COMMIT}
APP_NAME = nappemy-api
ORGANISATION_NAME = smodou

IMAGE_NAME = ${ORGANISATION_NAME}/${APP_NAME}
IMAGE_NAME_TAG = ${IMAGE_NAME}:${APP_VERSION}

mvn_build:
	@echo "Build mvn application"
	mvn package

build_image_dev:
	@echo "Build docker image dev"
	docker build --build-arg VERSION=${APP_VERSION} --build-arg GIT_COMMIT_ID=${COMMIT} --no-cache -t ${IMAGE_NAME_TAG} .
	docker tag ${IMAGE_NAME_TAG} ${IMAGE_NAME}:latest

push_image_dev:
	@echo "Push docker image dev"
	docker push ${IMAGE_NAME_TAG}
	docker rmi -f ${IMAGE_NAME_TAG} || true
	docker rmi -f $(docker images -q --filter "dangling=true") || true