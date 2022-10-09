# output service_catalog_helm_values {
#   value = join("", helm_release.service_catalog.*.metadata.0.values)
# }
