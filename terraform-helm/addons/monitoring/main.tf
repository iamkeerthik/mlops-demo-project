resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack-light"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.6.0"

  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/values/${var.env}.yaml")
  ]

  wait    = true
  timeout = 600
}