/*deprecado
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}*/

resource "helm_release" "dashboard" {
  count = var.install_dashboard ? 1 : 0

  keyring   = ""
  name      = "dashboard"
  chart     = "kubernetes-dashboard/kubernetes-dashboard"
  namespace = "kube-system"
  
  # depends_on = [kubernetes_deployment.tiller_deploy]

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.externalPort"
    value = 80
  }

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "rbac.clusterReadOnlyRole"
    value = "true"
  }

}

