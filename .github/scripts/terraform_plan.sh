#!/usr/bin/env bash

set -euo pipefail

SLICE=${SLICE:-$(git rev-parse --abbrev-ref HEAD)}

docker run --rm --tty \
    --user $(id -u) \
    --volume ${PWD}/${TERRAFORM_DIR}:/app \
    --volume ${PWD}/gcloud.json:/app/gcloud.json \
    --workdir /app \
    --env GOOGLE_CREDENTIALS=/app/gcloud.json \
    --env TF_VAR_slice=${SLICE} \
    hashicorp/terraform:${TERRAFORM_VERSION} \
    plan
