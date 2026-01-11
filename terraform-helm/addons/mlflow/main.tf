resource "helm_release" "mlflow" {
  name       = "mlflow"
  repository = "https://community-charts.github.io/helm-charts"
  chart      = "mlflow"
  namespace  = "mlflow"
  version    = "0.7.19" # stable

  create_namespace = true

  values = [
    file("${path.module}/values/${var.env}.yaml")
  ]

  wait    = true
  timeout = 600
}