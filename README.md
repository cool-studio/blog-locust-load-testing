# Locust Load Testing

#### Built as an example for [a Cool Studio Blog](https://cool.studio/)

[Read it here](https://medium.com/cool-studio/load-testing-your-infrastructure-effectively-787a638082a)

## Overview

A [Distributed Locust Cluster](https://locust.io) deployed using Terraform to Kubernetes on DigitalOcean.

The default configuration will create the following:

* 1 Kubernetes Cluster
  * 1 Node Pool
    * 1 Node (C-4)
  * 2 Deployments
    * Locust Master (1 Replica)
    * Locust Slave (1 Replica)
  * 2 Services
    * Locust Master Internal
    * Locust Master Load Balancer (Web UI)
* 1 Docker Image
  * Locust (with your config, to your repository of choice)


## Docker

Building the Dockerfile is easy, and only a few variable adjustments need to be made for the `build_and_push.sh` script to run:

* VERSION=[1.0.0]
* NAME=[locust-test]
* REPO_HOSTNAME=[registry.digitalocean.com/example-user]

Then your Terraform variable for `k8s-deployment-image` will become `registry.digitalocean.com/example/locust-test:1.0.0`

## Terraform

### Variables
There are some variables you need to set manually for the Terraform plan to run:

* do-token
  * Your DigitalOcean API key.
* locust-target
  * A URL for the initial Locust target.
* k8s-deployment-image
  * The repository and image you will be using to run Locust.


### Files
You also need to add on file into the `terraform/files` directory before applying the plan:

* docker-config.json
  * The Docker config that will be used to autorise your requests with your private repository.