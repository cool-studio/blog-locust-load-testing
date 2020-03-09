variable "do-token" {
  description = "DO API Key."
}

variable "do-region" {
  default = "lon1"
  description = "Where DO resources will be located."
}

variable "do-tag" {
  default = "locust-cluster"
  description = "Tag to be used for resources."
}


variable "k8s-name" {
  default = "locust-cluster"
  description = "Name of the K8S cluster."
}

variable "k8s-version" {
  default = "1.16.6-do.0"
  description = "K8S Version. Refer to DO Documentation."
}

variable "k8s-pool-name" {
  default = "primary"
  description = "Name of the K8S cluster node pool."
}
variable "k8s-pool-size" {
  default = "c-4"
}

variable "k8s-pool-count" {
  default = 2
}

variable "k8s-deployment-image" {
  default = "locustio/locust:0.14.5"
  description = "The locust image and version you with to use from Docker Hub. https://hub.docker.com/r/locustio/locust/tags"
}
