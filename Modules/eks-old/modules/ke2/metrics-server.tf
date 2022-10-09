resource "helm_release" "metrics_server" {
  count = var.install_metrics_server ? 1 : 0

  keyring   = ""
  name      = "metrics-server"
  chart     = "metrics-server"
  namespace = "kube-system"

  set {
    name  = "args"
    value = "{--kubelet-preferred-address-types=InternalIP}"
  }

 # depends_on = [kubernetes_deployment.tiller_deploy]
}

