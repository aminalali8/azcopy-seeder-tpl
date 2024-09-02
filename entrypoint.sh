#!/bin/bash

# Check if required environment variables are set
if [ -z "$AZURE_STORAGE_ACCOUNT" ] || [ -z "$AZURE_SAS_TOKEN" ] || [ -z "$CONTAINER_NAME" ]; then
  echo "AZURE_STORAGE_ACCOUNT, AZURE_SAS_TOKEN, and CONTAINER_NAME must be set."
  exit 1
fi

# Loop through the arguments and download each folder
for folder in "$@"
do
  echo "Downloading folder: $folder"
  azcopy copy "https://${AZURE_STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/${folder}/*?${AZURE_SAS_TOKEN}" "./${folder}" --recursive
done