FROM ubuntu:20.04

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl gcc g++ make zip \
  && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install 8.12.0 \
  && nvm install 12.11.0 \
  && nvm install --lts \
  && npm install -g @jlenon7/templating \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
  && curl -L https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz | tar xz && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64
