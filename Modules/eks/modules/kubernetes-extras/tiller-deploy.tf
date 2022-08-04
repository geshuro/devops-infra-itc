locals {
  tiller_deploy_name  = "tiller-deploy"
  tiller_service_name = "tiller-deploy"
}

resource "kubernetes_service" "tiller_deploy" {
  count = var.install_helm ? 1 : 0

  metadata {
    name      = local.tiller_service_name
    namespace = var.tiller_deploy_namespace

    labels = {
      app  = "helm"
      name = "tiller"
    }
  }

  spec {
    selector = {
        app  = "helm"
        name = "tiller"
    }

    port {
      name        = "tiller"
      port        = 44134
      target_port = "tiller"
    }
  }
}

resource "kubernetes_deployment" "tiller_deploy" {
  count = var.install_helm ? 1 : 0

  metadata {
    name      = local.tiller_deploy_name
    namespace = var.tiller_deploy_namespace

    labels = {
      app  = "helm"
      name = "tiller"
    }
  }

  spec {
    min_ready_seconds      = 15
    replicas               = 1
    revision_history_limit = 10

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app  = "helm"
        name = "tiller"
      }
    }

    template {
      metadata {
        namespace = ""

        labels = {
          app  = "helm"
          name = "tiller"
        }
      }

      spec {
        service_account_name = var.tiller_deploy_service_account_name
        restart_policy       = "Always"

        termination_grace_period_seconds = 30

        automount_service_account_token = "true"

        container {
          image             = "gcr.io/kubernetes-helm/tiller:${var.tiller_container_image_tag}"
          name              = "tiller"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 44134
            name           = "tiller"
            protocol       = "TCP"
          }

          port {
            container_port = 44135
            name           = "http"
            protocol       = "TCP"
          }

          env {
            name  = "TILLER_NAMESPACE"
            value = var.tiller_deploy_namespace
          }

          env {
            name  = "TILLER_HISTORY_MAX"
            value = "0"
          }

          liveness_probe {
            http_get {
              path   = "/liveness"
              port   = 44135
              scheme = "HTTP"
            }

            period_seconds        = 10
            initial_delay_seconds = 1
            success_threshold     = 1
            failure_threshold     = 3
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path   = "/readiness"
              port   = 44135
              scheme = "HTTP"
            }

            period_seconds        = 10
            initial_delay_seconds = 1
            success_threshold     = 2
            failure_threshold     = 3
            timeout_seconds       = 1
          }
        }
      }
    }
  }

  depends_on = [kubernetes_cluster_role_binding.tiller_deploy]
}

resource "kubernetes_service_account" "tiller_deploy" {
  count = var.install_helm ? 1 : 0

  automount_service_account_token = true

  metadata {
    name      = var.tiller_deploy_service_account_name
    namespace = var.tiller_deploy_namespace
  }
}

resource "kubernetes_cluster_role_binding" "tiller_deploy" {
  count = var.install_helm ? 1 : 0

  metadata {
    name = local.tiller_deploy_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = var.tiller_deploy_service_account_name
    namespace = var.tiller_deploy_namespace
  }

  depends_on = [kubernetes_service_account.tiller_deploy]
}

resource "kubernetes_namespace" "helm" {
  count = var.install_helm && var.tiller_deploy_namespace != "kube-system" ? 1 : 0

  metadata {
    name = var.tiller_deploy_namespace
  }
}
