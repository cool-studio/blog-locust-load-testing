//
// Providers
//

provider "digitalocean" {
  token = var.do-token
}

provider "kubernetes" {
  load_config_file = false
  host  = data.digitalocean_kubernetes_cluster.primary-cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.primary-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.primary-cluster.kube_config[0].cluster_ca_certificate
  )
}


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

