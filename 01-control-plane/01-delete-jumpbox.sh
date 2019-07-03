#!/bin/sh

jumpbox_exists() {
    gcloud compute instances list \
        --project "$GCP_PROJECT_ID" \
        --filter "name=('jbox-pks') AND zone:('$GCP_ZONE')" \
        | grep 'jbox-pks.*RUNNING' \
        >/dev/null 2>&1
}

if jumpbox_exists; then
    gcloud compute instances delete 'jbox-pks' \
        --project "$GCP_PROJECT_ID" \
        --zone "$GCP_ZONE" \
        --delete-disks 'all' \
        --quiet
fi
