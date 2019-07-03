#!/bin/sh

## Test that jumpbox exists

gcloud compute instances list \
    --project "$GCP_PROJECT_ID" \
    --filter "name=('jbox-pks') AND zone:('$GCP_ZONE')" \
    | grep 'jbox-pks.*RUNNING'

if [ $? -ne 0 ]; then
    echo "FAILED: jbox-pks doesn't exist in project $GCP_PROJECT_ID zone $GCP_ZONE" >&2
    exit 1
fi

## Test that jumpxbox is logged in

gcloud compute ssh 'ubuntu@jbox-pks' \
    --project "$GCP_PROJECT_ID" \
    --zone "$GCP_ZONE" \
    --quiet \
    --command '/snap/bin/gcloud auth print-identity-token' \
    >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "FAILED: jbox-pks isn't authorized" >&2
    exit 1
fi

## Test that services are enabled in project

error=0

for service in \
    'iam.googleapis.com' \
    'cloudresourcemanager.googleapis.com' \
    'dns.googleapis.com' \
    'sqladmin.googleapis.com' \
    'sourcerepo.googleapis.com'
do
    if ! gcloud services list --enabled \
        --project "$GCP_PROJECT_ID" \
        --filter "name:('$service')" \
        | grep "$service" \
        >/dev/null 2>&1
    then
        error=1
    fi
done

if [ $error -ne 0 ]; then
    echo "FAILED: not all services are enabled in project" 2>&1
    exit 1
fi

