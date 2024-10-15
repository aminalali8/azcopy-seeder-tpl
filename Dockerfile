# Use a minimal Debian-based image
FROM debian:buster-slim

# Install dependencies: curl, bash, and ca-certificates
RUN apt-get update && \
    apt-get install -y curl bash ca-certificates apt-transport-https gnupg lsb-release && \
    # Add Microsoft GPG key for Azure CLI
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    # Add Azure CLI software repository
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list && \
    # Install Azure CLI
    apt-get update && apt-get install -y azure-cli && \
    # Clean up APT when done
    apt-get clean

# Install azcopy (Fix: Simplified the tar extraction without wildcards)
RUN curl -sL https://aka.ms/downloadazcopy-v10-linux -o azcopy_linux.tar.gz && \
    mkdir -p /azcopy && \
    tar -xzf azcopy_linux.tar.gz -C /azcopy --strip-components=1 && \
    mv /azcopy/azcopy /usr/local/bin/azcopy && \
    rm -rf azcopy_linux.tar.gz /azcopy

# Copy the Bash script to the container
COPY entrypoint.sh /usr/local/bin/download_all_file_shares.sh

# Give the script execution permissions
RUN chmod +x /usr/local/bin/download_all_file_shares.sh

# Set the entry point to the script
ENTRYPOINT ["/usr/local/bin/download_all_file_shares.sh"]