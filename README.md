# RPMFetcher Docker Image

**RPMFetcher** is a Docker image built on `rockylinux:9`, designed to streamline RPM downloads and repository management. By default, it includes the Kubernetes repository, but you can extend it by adding custom `.repo` files to the `/repos` directory. Additionally, RPMFetcher provides two main functions: **`list`** and **`download`** for managing packages.

## Image Availability
The RPMFetcher Docker image is available by default on GitHub Container Registry (GHCR):
ghcr.io/klementxv/rpmfetcher

Pull the image directly with:
```bash
docker pull ghcr.io/klementxv/rpmfetcher:latest
```

## Features

- **Base Image**: `rockylinux:9`
- **Tools Installed**: `yum-utils`, `dnf-plugins-core`, `curl`, `gnupg2`
- **Default Repository**: Kubernetes repository pre-configured in `/etc/yum.repos.d/kubernetes.repo`
- **Custom Repositories**: Extend functionality by placing additional `.repo` files in `/repos`.
- **Functions**:
  - **`list`**: Lists available packages from configured repositories.
  - **`download`**: Downloads specified RPM packages.


## Build & Run

### Build the Image
```bash
docker build -t rpmfetcher:latest .
```
### Run the Container
```bash
docker run --rm -v $(pwd):/rpm-downloads rpmfetcher:latest
```
- Place custom .repo files in /repos before building the image to include additional repositories.

### Functions
1.	List Packages:
Use the list function to display available packages from the repositories:
```bash
docker run --rm rpmfetcher:latest list
```
2. Download Packages:
Use the download function to fetch specific RPM packages:
```bash
docker run --rm rpmfetcher:latest download <package-name>
```
- **Replace <package-name> with the name of the RPM package you want to download.**

### Files

- kubernetes.repo: Default Kubernetes repository configuration.
- entrypoint.sh: Entry point script for automated tasks.
- Additional .repo files: Add your .repo files to /repos for extra repositories.