resource "helm_release" "dashboard" {
  count = var.install_dashboard ? 1 : 0

  keyring   = ""
  name      = "dashboard"
  chart     = "stable/kubernetes-dashboard"
  namespace = "kube-system"

  depends_on = [kubernetes_deployment.tiller_deploy]
}

