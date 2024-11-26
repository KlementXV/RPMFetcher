#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the 'arch' variable is set, if not, determine the architecture using 'uname -m'
if [ -z "$arch" ]; then
    arch=$(uname -m)
    echo "[INFO] 'arch' variable not set. Using default architecture: $arch"
else
    echo "[INFO] Specified architecture found: $arch"
fi

# Function to download RPM packages
function download_packages() {
    # Ensure at least one package name is provided
    if [ "$#" -lt 1 ]; then
        echo "[ERROR] Usage: $0 download <package-name> [additional-packages...]"
        exit 1
    fi
    
    # Inform the user that the download process is starting
    echo "[Starting Download] Preparing to download the following RPM packages: $@"

    # Loop through each package and download it
    for package in "$@"; do
        echo "[Downloading] Downloading package: $package for architecture $arch..."
        # Use dnf to download the package, resolving dependencies, to the specified directory
        dnf download --resolve --alldeps --destdir=/rpm-downloads --forcearch=$arch "$package" --arch $arch
        echo "[Success] Package $package downloaded successfully."
    done

    # Inform the user that the download process is complete
    echo "[Download Complete] All requested packages have been downloaded. The RPM files are available in the directory: /rpm-downloads"
}

# Function to list information about RPM packages
function list_packages() {
    # Ensure at least one package name is provided
    if [ "$#" -lt 1 ]; then
        echo "[ERROR] Usage: $0 list <package-name> [additional-packages...]"
        exit 1
    fi

    # Inform the user that the listing process is starting
    echo "[Listing Packages] Displaying information for packages: $@"

    # Loop through each package and list its information
    for package in "$@"; do
        echo "[Info] Retrieving information for package: $package"
        # Use dnf to list package information, showing duplicates
        dnf list "$package" --showduplicates
    done

    # Inform the user that the listing process is complete
    echo "[Listing Complete] All requested information has been displayed."
}

# Ensure the script is called with at least two arguments
if [ "$#" -lt 2 ]; then
    echo "[ERROR] Usage: $0 <download|list> <package-name> [additional-packages...]"
    exit 1
fi

# Determine the action to perform (download or list)
action="$1"
shift

# Perform the action based on user input
case "$action" in
    download)
        download_packages "$@"
        ;;
    list)
        list_packages "$@"
        ;;
    *)
        # Handle unrecognized actions
        echo "[ERROR] Unrecognized action: $action"
        echo "[ERROR] Usage: $0 <download|list> <package-name> [additional-packages...]"
        exit 1
        ;;
esac