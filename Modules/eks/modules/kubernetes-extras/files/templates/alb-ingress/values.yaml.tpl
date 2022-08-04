clusterName: ${cluster_name}

autoDiscoverAwsRegion: ${auto_discover_aws_region}
%{ if auto_discover_aws_region != true }
awsRegion: ${aws_region}
%{ endif }

autoDiscoverAwsVpcID: ${auto_discover_vpc}
%{ if auto_discover_vpc != true }
awsVpcID: ${vpc_id}
%{ endif }

# rbac:
#  create: true
#  serviceAccountName: ${service_account_name}
#  serviceAccountAnnotations: 
#    ${service_account_iam_role_annotation}

rbac:
  ## If true, create & use RBAC resources
  ##
  create: true
  serviceAccount:
    create: true
    name: ${service_account_name}

    ## Annotations for the Service Account
    annotations: { ${service_account_iam_role_annotation} }

image:
  repository: docker.io/amazon/aws-alb-ingress-controller
  tag: ${container_image_tag}
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: ${resource_limits_cpu}
    memory: ${resource_limits_mem}
  requests:
    cpu: ${resource_requests_cpu}
    memory: ${resource_requests_mem}
