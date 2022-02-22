FROM ubuntu:20.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update packages
RUN apt-get update

# Install awscli, curl, gcc, g++, make and zip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl gcc g++ make zip

# Set nvm install directory
RUN mkdir -p "/usr/local/nvm"
ENV NVM_DIR "/usr/local/nvm"

# Install nvm, node, npm and npm global libraries
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install --lts \
    && npm install -g @jlenon7/templating \
    && nvm install 8.12.0 \
    && npm install -g @jlenon7/templating \
    && nvm install 12.11.0 \
    && npm install -g @jlenon7/templating

# Install Kubernetes and Helm
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
    && curl -L https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz | tar xz && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 \
