output "locust-master-service-load-balancer" {
  value = kubernetes_service.locust-deployment-load-balancer.load_balancer_ingress[0].ip
}
