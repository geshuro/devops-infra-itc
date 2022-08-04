global:
  # Default tag for Istio images.
  tag: ${container_image_tag}-distroless

  imagePullPolicy: IfNotPresent

certmanager:
  enabled: false

job:
  resources:
    requests:
      cpu: 10m
      memory: 50Mi
    limits:
      cpu: 100m
      memory: 200Mi
