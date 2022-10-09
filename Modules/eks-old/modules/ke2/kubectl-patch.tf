resource "null_resource" "kubectl-patch" {
 count = var.install_kubectl-patch ? 1 : 0
    provisioner "local-exec" { 
    command = "sh ${path.module}/files/scripts/kubectl-patch.sh" # Dependencies: kubectl
    environment = {
         path = "${path.module}/files/scripts/"
    }
 } 
}

