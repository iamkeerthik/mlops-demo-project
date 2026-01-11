resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "6.3.0"

  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/values/metrics-server.yaml")
  ]

  wait    = true
  timeout = 300
}