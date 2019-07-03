#!/bin/sh

gcloud compute instances list \
    --project "$GCP_PROJECT_ID" \
    --filter "name=('jbox-pks') AND zone:('$GCP_ZONE')" \
    | grep 'jbox-pks.*RUNNING'

exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo "FAILED: jbox-pks doesn't exist in project $GCP_PROJECT_ID zone $GCP_ZONE" >&2
fi

exit $exit_code
