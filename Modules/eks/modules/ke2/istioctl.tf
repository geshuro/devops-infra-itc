locals {
  istio_name      = "istio"
  profile         = "demo"
}

resource "null_resource" "istioctl" {
 count = var.install_istio ? 1 : 0
    provisioner "local-exec" { 
    command = "sh ${path.module}/files/scripts/istioctl.sh" # Dependencies: istioctl
    environment = {
      profile    = local.profile
    }
  }
}

