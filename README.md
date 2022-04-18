# Gitlab Deploy 🐳

> A docker image to use inside Gitlab CI pipelines

A simple docker image to help in your pipelines, `gitlab-deploy` is based in a `ubuntu` image and comes with `curl, make, zip, awscli, nvm, npm, nodejs, kubectl, helm and templating`.
Feel free to make a `pull request` to add more content to this image.

<img src=".gitlab/gitlab-deploy.png" width="200px" align="right" hspace="30px" vspace="100px">

## Adding more content to this image

> Gitlab CI uses DIND to execute the steps from the pipeline. If you want to add more content to the image, always remember that your command should exist in the interactive mode to work inside the pipeline

```yaml
# You can find this step inside ./.gitlab-ci.yml file

# This is the actual CI pipeline of this project and runs only on new merge_request
Build and test the image commands:
  image: docker:latest
  stage: test
  script:
    - docker build -t test-gitlab-deploy .
    - docker run -i test-gitlab-deploy aws help
    - docker run -i test-gitlab-deploy curl --help
    - docker run -i test-gitlab-deploy zip -v
    - docker run -i test-gitlab-deploy make -v
    - docker run -i test-gitlab-deploy npm -v
    - docker run -i test-gitlab-deploy node -v
    - docker run -i test-gitlab-deploy templating -v
    - docker run -i test-gitlab-deploy helm
    - docker run -i test-gitlab-deploy kubectl
    - docker run -i test-gitlab-deploy /bin/bash -c "source /usr/local/bin/nvm/nvm.sh && nvm -v"
    # Add your command over here. Example -> docker run -i test-gitlab-deploy javac
  only:
    - merge_requests
```

## Pipeline Example

> A .gitlab-ci.yml file as example

```yaml
services:
  - docker:18.09-dind

variables:
  IMAGE_LATEST: nickname-organization/your-image-name-here:latest
  IMAGE_TAG: nickname-organization/your-image-name-here:$CI_COMMIT_SHA

stages:
  - test
  - build
  - deploy

Verify lint and run tests:
  image: node:16.13.0
  stage: test
  services:
    - redis:latest
    - postgres:latest
  variables:
    POSTGRES_DB: "postgres"
    POSTGRES_USER: "postgres"
    POSTGRES_PASSWORD: "root"
    DATABASE_URL_TESTING: "postgresql://postgres:root@postgres:5432/postgres?schema=public"
  script:
    - cp ./manifest/.env.ci .env.ci
    - npm install --silent
    - npm run lint:fix
    - npm run test:ci
  only:
    - merge_requests

Build and push image to Dockerhub:
  image: docker:latest
  stage: build
  script:
    - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    - docker pull $IMAGE_LATEST || true
    - docker build --cache-from $IMAGE_LATEST -t $IMAGE_TAG -t $IMAGE_LATEST .
    - docker push $IMAGE_TAG
    - docker push $IMAGE_LATEST
  only:
    - main

Deploy image to K8S Cluster:
  image: jlenon7/gitlab-deploy:latest
  stage: deploy
  script:
    - aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
    - aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
    - aws configure set region $AWS_DEFAULT_REGION
    - aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name eks-$AWS_DEFAULT_REGION-production
    - templating generate ./manifest/templates --set IMAGE_TAG=$IMAGE_TAG
    - kubectl apply -f ./manifest/config-map.yml -f ./manifest/deployment.yml
  needs: ["Build and push image to Dockerhub"]
  only:
    - main
```

## Warning under nvm CLI

> To use nvm inside your pipelines you will need to use /bin/bash and source nvm.sh first

```yaml
Example:
  image: jlenon7/gitlab-deploy:latest
  stage: deploy
  script:
    # Install node 14.2 version and reinstall all global packages from version 16.2
    - /bin/bash -c "source /usr/local/bin/nvm/nvm.sh && nvm install 14.2.0 && nvm reinstall-packages 16.2.0"
  only:
    - main
```

---

Made with 🖤 by [jlenon7](https://github.com/jlenon7) 👋
