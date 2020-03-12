//
// Providers
//

provider "digitalocean" {
  token = var.do-token
}

provider "kubernetes" {
  load_config_file = true
  host  = data.digitalocean_kubernetes_cluster.primary-cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.primary-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.primary-cluster.kube_config[0].cluster_ca_certificate
  )
}

//
// Data
//

data "digitalocean_kubernetes_cluster" "primary-cluster" {
  name = var.k8s-name

  depends_on = [
    digitalocean_kubernetes_cluster.primary-cluster
  ]
}

//
// Project Resource
//

# resource "digitalocean_project" "locust-deployment" {
#   name = "Locust Deployment"
#   description = "An automatically orchestrated infrastructure to execute scaleable Locust tests."

#   resources = concat(digitalocean_kubernetes_cluster.primary-cluster.node_pool.*.urn, [digitalocean_kubernetes_cluster.primary-cluster.urn])
# }

//
// Kubernetes Resources
//

resource "digitalocean_kubernetes_cluster" "primary-cluster" {
  name = var.k8s-name
  region = var.do-region

  version = var.k8s-version

  node_pool {
      name = var.k8s-pool-name
      size = var.k8s-pool-size
      node_count = var.k8s-pool-count

      tags = [
          var.do-tag
      ]
  }

  tags = [
      var.do-tag
  ]
}

//
// Kubernetes Secret for docker registry
//

resource "kubernetes_secret" "registry" {
  metadata {
    name = "do-registry-secret"
  }

  data = {
    ".dockerconfigjson" = "${file("${path.module}/files/docker-config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}


//
// Kubernetes Deployment
//

//
// Locust Master Service
//

resource "kubernetes_service" "locust-deployment-service" {
  metadata {
    name = "locust-service"
  }
  spec {
    selector = {
      lb-bind = "locust-deployment-master"
    }
    port {
      port = 5557
      target_port= 5557
    }
  }
}

resource "kubernetes_service" "locust-deployment-load-balancer" {
  metadata {
    name = "locust-load-balancer"
  }
  spec {
    selector = {
      lb-bind = "locust-deployment-master"
    }
    port {
      port = 80
      target_port= 8089
    }

    type = "LoadBalancer"
  }
}


//
// Locust Master
//


resource "kubernetes_deployment" "locust-deployment-master" {
  metadata {
    name = "locust-deployment-master"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        lb-bind = "locust-deployment-master"
      }
    }

    template {
      metadata {
        labels = {
          lb-bind = "locust-deployment-master"
        }
      }

      spec {
        container {
          image = var.k8s-deployment-image
          name = "locust-master"

          env {
            name = "TARGET_URL"
            value = var.locust-target
          }

          env {
            name = "LOCUST_MODE"
            value = "master"
          }
        }
        image_pull_secrets {
          name = "do-registry-secret"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "locust-deployment-slave" {
  metadata {
    name = "locust-deployment-slave"
  }

  spec {
    replicas = ceil(var.k8s-pool-count * 3.5)

    selector {
      match_labels = {
        lb-bind = "locust-deployment-slave"
      }
    }

    template {
      metadata {
        labels = {
          lb-bind = "locust-deployment-slave"
        }
      }

      spec {
        container {
          image = var.k8s-deployment-image
          name = "locust-slave"

          env {
            name = "LOCUST_MASTER_HOST"
            value = kubernetes_service.locust-deployment-service.spec[0].cluster_ip
          }

          env {
            name = "LOCUST_MODE"
            value = "slave"
          }

          env {
            name = "TARGET_URL"
            value = var.locust-target
          }
        }
        image_pull_secrets {
          name = "do-registry-secret"
        }
      }
    }
  }
}