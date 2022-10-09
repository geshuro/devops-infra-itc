apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/certificate-arn: '${tls_certificate_arn}'
    alb.ingress.kubernetes.io/listen-ports: '[ {"HTTPS":443}, {"HTTP":80} ]'
    alb.ingress.kubernetes.io/healthcheck-port: '15020'
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-FS-2018-06
    alb.ingress.kubernetes.io/subnets: ${subnet_ids}
    alb.ingress.kubernetes.io/security-groups: "${security_group_ids}"
    alb.ingress.kubernetes.io/success-codes: 200,404
    alb.ingress.kubernetes.io/tags: ${tags}
    alb.ingress.kubernetes.io/target-type: ${target_type}
    alb.ingress.kubernetes.io/load-balancer-attributes: routing.http2.enabled=true,access_logs.s3.enabled=${logs_s3_enabled},access_logs.s3.bucket=${logs_s3_bucket},access_logs.s3.prefix=${logs_s3_prefix}
    ${cognito_config}
    kubernetes.io/ingress.class: alb
  labels:
    app: ${app_label}
  name: ${name}
  namespace: istio-system
spec:
  rules:
  - host: '*.${host_name}'
    http:
      paths:
      - backend:
          serviceName: ssl-redirect
          servicePort: use-annotation
      - backend:
          serviceName: istio-ingressgateway
          servicePort: 80
