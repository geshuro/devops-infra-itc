data "template_file" "cloud-init" {
  template = file("${path.module}/cloud-init.cfg")
}

data "template_file" "shell-script" {
  template = file("${path.module}/cloud-init.sh")

  vars = {
    REGION          = local.region
    LOG_GROUP_NAME  = "/shared/bastion-devops"
  }
}

data "template_cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud-init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}
