output "oidc_host_path" {
  value = split("://", var.cluster_oidc_issuer_url)[1]
}
