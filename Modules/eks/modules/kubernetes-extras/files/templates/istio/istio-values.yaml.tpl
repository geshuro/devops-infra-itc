# This is used to generate istio.yaml for minimal, demo mode.
# It is shipped with the release, used for bookinfo or quick installation of istio.
# Includes components used in the demo, defaults to alpha3 rules.
global:
  tag: ${container_image_tag}-distroless
  controlPlaneSecurityEnabled: false
  configValidation: ${config_validation_enabled}
  
  proxy:
    accessLogFile: "/dev/stdout"
    resources:
      requests:
        cpu: 10m
        memory: 40Mi

  disablePolicyChecks: false

  mtls:
    # Default setting for service-to-service mtls. Can be set explicitly using
    # destination rules or service annotations.
    enabled: ${mtls_enabled}
    auto: ${mtls_auto}

sidecarInjectorWebhook:
  enabled: ${enable_sidecar_injector}
  # If true, webhook or istioctl injector will rewrite PodSpec for liveness
  # health check to redirect request to sidecar. This makes liveness check work
  # even when mTLS is enabled.
  rewriteAppHTTPProbe: false
  

pilot:
  autoscaleEnabled: false
  traceSampling: 100.0
  resources:
    requests:
      cpu: 10m
      memory: 100Mi

mixer:
  policy:
    enabled: true
    autoscaleEnabled: false
    resources:
      requests:
        cpu: 10m
        memory: 100Mi

  telemetry:
    enabled: true
    autoscaleEnabled: false
    resources:
      requests:
        cpu: 50m
        memory: 100Mi
 
  adapters:
    stdio:
      enabled: true
 
grafana:
  enabled: true

tracing:
  enabled: true

kiali:
  enabled: false
  createDemoSecret: false

gateways:
  istio-ingressgateway:
    autoscaleEnabled: false
    resources:
      requests:
        cpu: 10m
        memory: 40Mi

  istio-egressgateway:
    enabled: true
    autoscaleEnabled: false
    resources:
      requests:
        cpu: 10m
        memory: 40Mi
