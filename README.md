# AZCopy Seeder Template

## Overview
The **AZCopy Seeder Template** is designed to automate the process of downloading data from **Azure Storage File Shares** into a specified target directory using **AZCopy**. This template is intended to be used within the **Bunnyshell platform** to seed file shares from an Azure Storage account efficiently. However, for **manual use**, instructions are provided below.

### Key Features
- Downloads **all file shares** from an Azure Storage account.
- Utilizes **AZCopy** to efficiently handle file transfers.
- Requires minimal setup with just three template variables.

## Prerequisites
- **Azure Storage Account**: The storage account where the file shares are located.
- **SAS Token**: A **Shared Access Signature (SAS)** token with sufficient permissions (read, list) to access the storage account.
- **AZCopy**: The template uses AZCopy v10.26, a command-line tool that enables fast data transfer to and from Azure.

## Template Variables
This template requires the following variables:

| Variable               | Description                                                                 | Type   |
| ---------------------- | --------------------------------------------------------------------------- | ------ |
| `AZURE_STORAGE_ACCOUNT` | The name of the Azure storage account that hosts the file shares            | string |
| `AZURE_SAS_TOKEN`       | A valid SAS token to authenticate and authorize access to the storage account | string |
| `DOWNLOAD_PATH`         | The target path where all file shares and their contents will be downloaded  | string |

## Usage

### Usage with Bunnyshell
This template is intended for use with the **Bunnyshell platform**. Bunnyshell users can integrate this template into their environments to automatically seed data from Azure Storage File Shares. By providing the necessary variables (Azure Storage Account, SAS Token, and Download Path), the template will handle the file transfer from Azure to the specified target directory within the Bunnyshell environment.

### Manual Usage
For users who wish to manually use this template in a Docker environment, follow the steps below to download all file shares from your Azure Storage account.

#### 1. Build the Docker Image
First, build the Docker image from the provided Dockerfile. You will need to pass the `AZURE_STORAGE_ACCOUNT` and `AZURE_SAS_TOKEN` variables at build time.

```bash
docker build --build-arg AZURE_STORAGE_ACCOUNT="<your-storage-account>" \
             --build-arg AZURE_SAS_TOKEN="<your-sas-token>" \
             -t azcopy-file-share-seeder .
```

2. Run the Docker Container

Next, run the Docker container, passing the AZURE_STORAGE_ACCOUNT, AZURE_SAS_TOKEN, and mounting the directory where you want the file shares to be downloaded.
```bash
docker run -e AZURE_STORAGE_ACCOUNT="<your-storage-account>" \
           -e AZURE_SAS_TOKEN="<your-sas-token>" \
           -v <local-download-path>:/data azcopy-file-share-seeder /data
```

Environment Variables:

	•	AZURE_STORAGE_ACCOUNT: Your Azure Storage Account name (where the file shares reside).
	•	AZURE_SAS_TOKEN: A SAS token with appropriate permissions for accessing the file shares.
	•	DOWNLOAD_PATH: The target directory where all file shares will be downloaded (this is passed as the container argument /data).

Example:
```bash
docker run -e AZURE_STORAGE_ACCOUNT="mystorageaccount" \
           -e AZURE_SAS_TOKEN="your-sas-token" \
           -v $(pwd)/downloads:/data azcopy-file-share-seeder /data
```

This will download all file shares from the Azure Storage account mystorageaccount and save them into the downloads/ directory on your local machine.

AZCopy Version

	•	AZCopy: Version 10.26 is used for fast, reliable data transfer.

Notes:

	•	Make sure the SAS token has the following permissions:
	•	r (read): Required to read the files.
	•	l (list): Required to list the file shares in the storage account.
	•	The target directory (specified in DOWNLOAD_PATH) will contain a folder for each file share.

Permissions Required for SAS Token:
```
r (read), l (list)
```
