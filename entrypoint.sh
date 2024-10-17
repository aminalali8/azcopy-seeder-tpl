#!/bin/bash

###
# Required environment variables:
# - AZURE_STORAGE_ACCOUNT: The name of the Azure Storage account.
# - AZURE_SAS_TOKEN: The Shared Access Signature (SAS) token for the Azure Storage account.
# - DOWNLOAD_PATH: The path to download the file shares to.
###

# Wait flag raised
if [ -n "$WAIT" ]; then
  echo "Waiting for 3600 seconds..."
  sleep 3600
fi

# Check if required environment variables are set
if [ -z "$AZURE_STORAGE_ACCOUNT" ] || [ -z "$AZURE_SAS_TOKEN" ]; then
  echo "AZURE_STORAGE_ACCOUNT and AZURE_SAS_TOKEN must be set."
  exit 1
fi

# List all file shares in the storage account
file_shares=$(az storage share list --account-name "$AZURE_STORAGE_ACCOUNT" --sas-token "$AZURE_SAS_TOKEN" --query "[].name" -o tsv)

# Loop through all file shares and download each into its own folder
for file_share in $file_shares
do
  echo "Downloading file share: $file_share"
  azcopy copy "https://${AZURE_STORAGE_ACCOUNT}.file.core.windows.net/${file_share}?${AZURE_SAS_TOKEN}" "${DOWNLOAD_PATH}/" --recursive
done

echo "All file shares have been downloaded to ${DOWNLOAD_PATH}."