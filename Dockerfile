# Define a variable for the Rocky Linux version
ARG ROCKY_VERSION=9

# Use Rocky Linux with the specified version as the base image
FROM rockylinux:${ROCKY_VERSION}

# Update all packages and install necessary tools
RUN dnf -y update && \
    dnf -y install yum-utils dnf-plugins-core curl gnupg2 --allowerasing && \ 
    dnf clean all  # Clean up cached data to reduce image size

# Add NVIDIA GPG key for CUDA repository
RUN NVIDIA_GPGKEY_SUM=d0664fbbdb8c32356d45de36c5984617217b2d0bef41b93ccecd326ba3b80c87 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/D42D0685.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

# Copy the Kubernetes repository configuration file into the container
COPY repos/*.repo /etc/yum.repos.d/

# Set the working directory for subsequent commands
WORKDIR /rpm-downloads

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Specify the entrypoint script to be executed when the container starts
ENTRYPOINT ["/entrypoint.sh"]