#!/bin/sh

gcloud compute instances delete 'jbox-pks' \
    --project "$GCP_PROJECT_ID" \
    --zone "$GCP_ZONE" \
    --delete-disks 'all' \
    --quiet
