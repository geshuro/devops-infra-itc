resource "helm_release" "efs_provisioner" {
  count = var.install_efs_provisioner ? 1 : 0

  keyring   = ""
  name      = "efs-provisioner"
  chart     = "stable/efs-provisioner"
  namespace = "kube-system"

  set {
    name  = "efsProvisioner.efsFileSystemId"
    value = var.fs_id
  }

  set {
    name  = "efsProvisioner.awsRegion"
    value = var.aws_region
  }

  depends_on = [
    kubernetes_deployment.tiller_deploy,
  ]
}

