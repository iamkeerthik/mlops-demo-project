resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  namespace        = "karpenter"
  create_namespace = true

  version = "0.30.2" # Use latest stable

  values = [
    file("${path.module}/values/${var.env}.yaml")
  ]

  wait    = true
  timeout = 600
}