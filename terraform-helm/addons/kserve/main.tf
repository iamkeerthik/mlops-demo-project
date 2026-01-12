locals {
  values_file = "${path.module}/values/${var.env}.yaml"
}

############################
# 1️⃣ CERT-MANAGER
############################
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.15.1"

  create_namespace = true

  values = [
    yamlencode({
      installCRDs = true
    }),
    file(local.values_file)
  ]

  wait    = true
  timeout = 600
}

############################
# 2️⃣ KSERVE CRDS
############################
resource "helm_release" "kserve_crds" {
  name       = "kserve-crds"
  repository = "https://kserve.github.io/helm-charts"
  chart      = "kserve-crds"
  namespace  = "kserve"
  version    = "0.14.0"

  create_namespace = true

  depends_on = [
    helm_release.cert_manager
  ]

  values = [
    file(local.values_file)
  ]

  wait    = true
  timeout = 600
}

############################
# 3️⃣ KSERVE CONTROLLER
############################
resource "helm_release" "kserve" {
  name       = "kserve"
  repository = "https://kserve.github.io/helm-charts"
  chart      = "kserve"
  namespace  = "kserve"
  version    = "0.14.0"

  create_namespace = true

  depends_on = [
    helm_release.kserve_crds
  ]

  values = [
    file(local.values_file)
  ]

  wait    = true
  timeout = 600
}