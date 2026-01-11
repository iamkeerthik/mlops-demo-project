resource "helm_release" "mlflow" {
  name             = "mlflow"
  namespace        = "mlflow"
  create_namespace = true

  repository = "https://community-charts.github.io/helm-charts"
  chart      = "mlflow"
  version    = "0.7.19"

  values = [
    file("${path.module}/values/${var.env}.yaml")
  ]
}