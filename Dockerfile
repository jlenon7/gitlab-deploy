FROM ubuntu:20.04

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl gcc g++ make zip \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && curl -L https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz | tar xz && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 \
  && npm install -g @jlenon7/templating
