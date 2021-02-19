#!/bin/bash

set -x

# --
export MAVEN_VERSION=${MAVEN_VERSION:-"3.6.3"}
export OPENJDK_VERSION=${OPENJDK_VERSION:-"11.0.3"}
export OCI_REPOSITORY_ORG=${OCI_REPOSITORY_ORG:-"docker.io/graviteeio"}
export OCI_REPOSITORY_NAME=${OCI_REPOSITORY_NAME:-"cicd-maven"}


export GITHUB_ORG=${GITHUB_ORG:-"gravitee-io"}
export OCI_VENDOR=gravitee.io
export CCI_USER_UID=$(id -u)
export CCI_USER_GID=$(id -g)
# [runMavenShellScript] - Will Run Maven Shell Script with CCI_USER_UID=[1001]
# [runMavenShellScript] - Will Run Maven Shell Script with CCI_USER_GID=[1002]
# export CCI_USER_UID=1001
# export CCI_USER_GID=1002
export NON_ROOT_USER_UID=${CCI_USER_UID}
export NON_ROOT_USER_NAME=$(whoami)
export NON_ROOT_USER_GID=${CCI_USER_GID}
export NON_ROOT_USER_GRP=${NON_ROOT_USER_NAME}


# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #
# -----------                         DOCKER PUSH                        --------- #
# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #
# -----------                  COCKPIT MAVEN DOCKER IMAGE                --------- #
# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #

# checking docker image built in previous step is there
docker images

export DESIRED_DOCKER_TAG="${MAVEN_VERSION}-openjdk-${OPENJDK_VERSION}"

# [gravitee-lab/cicd-maven/staging/docker/quay/botuser/username]
# and
# [gravitee-lab/cicd-maven/staging/docker/quay/botoken/token]
# --> are to be set with secrethub cli, and 2 Circle CI Env. Var. have to
# be set for [Secrethub CLI Auth], at project, or context level
export SECRETHUB_ORG=${SECRETHUB_ORG:-"graviteeio"}
export SECRETHUB_REPO=${SECRETHUB_REPO:-"cicd"}

export DOCKERHUB_BOT_USER_NAME=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/dockerhub-user-name")
export DOCKERHUB_BOT_USER_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/dockerhub-user-token")

docker login --username="${DOCKERHUB_BOT_USER_NAME}" -p="${DOCKERHUB_BOT_USER_TOKEN}"

echo "checking [date time] (sometimes data time in Circle CI pipelines is wrong, so that Container registry rejects the [docker push]...)"
date

export IMAGE_TAG_LABEL=$(docker inspect --format '{{ index .Config.Labels "oci.image.tag"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")
export IMAGE_FROM_LABEL=$(docker inspect --format '{{ index .Config.Labels "oci.image.from"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")
export GH_ORG_LABEL=$(docker inspect --format '{{ index .Config.Labels "cicd.github.org"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")
export GIO_PRODUCT_NAME_LABEL=$(docker inspect --format '{{ index .Config.Labels "io.gravitee.product.name"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")
export NON_ROOT_USER_NAME_LABEL=$(docker inspect --format '{{ index .Config.Labels "oci.image.nonroot.user.name"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")
export NON_ROOT_USER_GRP_LABEL=$(docker inspect --format '{{ index .Config.Labels "oci.image.nonroot.user.group"}}' "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}")

echo " IMAGE_TAG_LABEL=[${IMAGE_TAG_LABEL}]"
echo " IMAGE_FROM_LABEL=[${IMAGE_FROM_LABEL}]"
echo " GH_ORG_LABEL=[${GH_ORG_LABEL}]"
echo " GIO_PRODUCT_NAME_LABEL=[${GIO_PRODUCT_NAME_LABEL}]"
echo " NON_ROOT_USER_NAME_LABEL=[${NON_ROOT_USER_NAME_LABEL}]"
echo " NON_ROOT_USER_GRP_LABEL=[${NON_ROOT_USER_GRP_LABEL}]"

docker push "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}"
# docker push "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:stable-latest"
docker push "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:latest"
