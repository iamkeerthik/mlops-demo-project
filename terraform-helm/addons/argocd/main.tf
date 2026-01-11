resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "6.7.3"

  create_namespace = true

  values = [
    file("${path.module}/values/${var.env}.yaml")
  ]

  wait    = true
  timeout = 600
}