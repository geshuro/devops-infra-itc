podAnnotations:
  ${kube2iam_pod_annotation}

policy: ${dns_record_policy}

rbac:
  create: true
  serviceAccountName: ${service_account_name}
  serviceAccountAnnotations:
    ${service_account_iam_role_annotation}
  apiVersion: v1beta1
  pspEnabled: false

securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
podSecurityContext:
  fsGroup: 1001
  runAsUser: 1001
  runAsNonRoot: true

metrics:
  enabled: true
