# Use Alpine Linux with x86_64 architecture as the base image
FROM --platform=linux/amd64 alpine:latest

# Set the maintainer label
LABEL maintainer="amin@bunnyshell.com"

# Set the default working directory
ARG WORKDIR_ARG

# Install required packages: curl for downloading AzCopy and bash for the script
RUN apk add --no-cache curl bash

# Download and install AzCopy
RUN curl -sL https://aka.ms/downloadazcopy-v10-linux | tar -xz && \
    mv ./azcopy_linux_amd64_*/azcopy /usr/local/bin/ && \
    rm -rf ./azcopy_linux_amd64_*

RUN mkdir -p ${WORKDIR_ARG}

# Set the working directory
WORKDIR ${WORKDIR_ARG}



# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["entrypoint.sh"]