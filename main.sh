#!/usr/bin/env bash

set -euxo pipefail

# Create a file with the Google Cloud Auth Key File
gcloud auth activate-service-account \
    --key-file - <<< $GCLOUD_KEY_FILE

project_id="$(jq -r .project_id <<< $GCLOUD_KEY_FILE)"

gcloud container clusters get-credentials \
    $GCLOUD_CLUSTER_NAME \
    --region $GCLOUD_REGION \
    --project $project_id

# Push update to application through kubectl
kubectl set image \
    deployments/${CHART_TITLE:-app} \
    ${CHART_TITLE:-app}=$REPO_URL:$REPO_TAG \
    --namespace $KUBE_NAMESPACE
