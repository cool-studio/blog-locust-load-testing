variable "locust-target" {
  description = "A site for locust to initially target."
}

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
  default = 1
}

variable "k8s-deployment-image" {
  description = "Your Locust image based off the official image, but including your locustfile.py. https://hub.docker.com/r/locustio/locust/tags"
}
