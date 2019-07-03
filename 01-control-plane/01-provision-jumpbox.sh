#!/bin/sh

gcloud services enable compute.googleapis.com \
    --project "$GCP_PROJECT_ID"

jumpbox_exists() {
    gcloud compute instances list \
        --project "$GCP_PROJECT_ID" \
        --filter "name=('jbox-pks') AND zone:('$GCP_ZONE')" \
        | grep 'jbox-pks.*RUNNING' \
        >/dev/null 2>&1
}

## Create a jumpbox

if ! jumpbox_exists; then
    gcloud compute instances create 'jbox-pks' \
        --image-project 'ubuntu-os-cloud' \
        --image-family 'ubuntu-1804-lts' \
        --boot-disk-size '200' \
        --machine-type='g1-small' \
        --project "$GCP_PROJECT_ID" \
        --zone "$GCP_ZONE" \
        --tags "jbox-pks"
fi

## Configure the jumpbox

jumpbox_authorized() {
    gcloud compute ssh 'ubuntu@jbox-pks' \
        --project "$GCP_PROJECT_ID" \
        --zone "$GCP_ZONE" \
        --quiet \
        --command '/snap/bin/gcloud auth print-identity-token' \
        >/dev/null 2>&1
}

if ! jumpbox_authorized; then
    gcloud compute ssh 'ubuntu@jbox-pks' \
        --project "$GCP_PROJECT_ID" \
        --zone "$GCP_ZONE" \
        --quiet \
        --command '/snap/bin/gcloud auth login --quiet'
fi
