#!/bin/bash

as_root() {
    if [[ "$EUID" -ne 0 ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

## GCloud

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | as_root tee /etc/apt/sources.list.d/google-cloud-sdk.list

as_root apt install apt-transport-https ca-certificates

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | as_root apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

as_root apt update && as_root apt install google-cloud-sdk

gcloud init

