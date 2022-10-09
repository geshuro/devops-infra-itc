data "tls_certificate" "cert" {
  url = var.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "openid_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = var.cluster_oidc_issuer_url
}