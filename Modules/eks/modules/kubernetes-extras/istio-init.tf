locals {
  istio_init_name    = "istio-init"
  install_istio = var.install_helm && var.install_istio
  istio_namespace    = "istio-system"
  istio_init_helm_repository_name = "istio.io"
  url = "https://storage.googleapis.com/istio-release/releases/${var.istio_helm_chart_version}/charts/"
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
        name = local.istio_namespace
  }
}

data "helm_repository" "istio_repo" {
  name = "istio.io"
  url  = local.url
}

resource "helm_release" "istio_init" {
  count = local.install_istio ? 1 : 0

  name       = local.istio_init_name
  repository = data.helm_repository.istio_repo.metadata[0].name
  chart      = "${local.istio_init_helm_repository_name}/${local.istio_init_name}"
  namespace  = local.istio_namespace
  version    = var.istio_helm_chart_version

  timeout = 1200

  values = [
    join("", data.template_file.istio_init.*.rendered),
  ]

  depends_on = [
    kubernetes_deployment.tiller_deploy, kubernetes_namespace.istio_system
  ]
}


data "template_file" "istio_init" {
  count = local.install_istio ? 1 : 0

  template = file("${local.files_path}/templates/istio/${local.istio_init_name}-values.yaml.tpl")

  vars = {
    container_image_tag = var.istio_container_image_tag
  }
}
