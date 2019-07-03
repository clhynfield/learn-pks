#!/bin/sh

gcloud services enable compute.googleapis.com \
    --project "$GCP_PROJECT_ID"

gcloud compute instances create 'jbox-pks' \
    --image-project 'ubuntu-os-cloud' \
    --image-family 'ubuntu-1804-lts' \
    --boot-disk-size '200' \
    --machine-type='g1-small' \
    --project "$GCP_PROJECT_ID" \
    --zone "$GCP_ZONE" \
    --tags "jbox-pks"
