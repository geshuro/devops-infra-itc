locals {
  istio_name      = "istio"
  istio_helm_repository_name = join("", data.helm_repository.istio.*.name)

}

data "helm_repository" "istio" {
  name = "istio.io"
  url  = local.url
}

resource "helm_release" "istio" {
  count = local.install_istio ? 1 : 0

  name       = local.istio_name
  repository = data.helm_repository.istio.metadata[0].name
  chart      = "${local.istio_helm_repository_name}/${local.istio_name}"
  namespace  = local.istio_namespace
  version    = var.istio_helm_chart_version

  wait       = false
  timeout = 60

  values = concat(
  [join("", data.template_file.istio.*.rendered)],
  var.istio_helm_values
  )

  depends_on = [
    kubernetes_deployment.tiller_deploy,
    helm_release.istio_init,
  ]
}

data "template_file" "istio" {
  count = local.install_istio ? 1 : 0

  template = file("${local.files_path}/templates/istio/${local.istio_name}-values.yaml.tpl")

  vars = {
    container_image_tag               = var.istio_container_image_tag
    mtls_enabled                      = var.istio_mtls_enabled
    mtls_auto                         = var.istio_mtls_auto
    config_validation_enabled         = var.istio_config_validation_enabled
    enable_sidecar_injector           = var.istio_sidecar_injector_enabled
    sidecar_injection_exclusion_label = var.istio_sidecar_injector_exclusion_label
  }
}
