FROM ubuntu:20.04

# Update packages
RUN apt-get update

# Install awscli, curl, gcc, g++, make and zip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl gcc g++ make zip

# Set nvm install directory
RUN mkdir -p "/usr/local/bin/nvm"
ENV NVM_DIR "/usr/local/bin/nvm"

# Install nvm, node, npm and npm global libraries
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install 16.2.0 \
    && npm install -g @jlenon7/templating \
    && nvm install 8.12.0 \
    && nvm reinstall-packages 16.2.0 \
    && nvm install 12.11.0 \
    && nvm reinstall-packages 16.2.0

# Add node and npm to path
ENV PATH $NVM_DIR/versions/node/v16.2.0/bin:$PATH

# Install Kubernetes and Helm
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
    && curl -L https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz | tar xz && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64
