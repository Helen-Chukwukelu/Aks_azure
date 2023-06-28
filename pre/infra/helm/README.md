Generic Helm Chart
=======
A Helm chart for Kubernetes

Current chart version is `0.1.0`


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release chart-repo
```

These commands deploys an application on the Kubernetes cluster in the default configuration.
The [Parameters](#Parameters) section lists the parameters that can be configured during installation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release chart-repo --set=nameOverride=demo,url=demo.app
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```bash
$ helm install my-release chart-repo -f values.yaml
```



## Parameters

The following tables lists the configurable parameters of the chart and their default values.

| Key | Type | Default | Description |
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| deployment.containerPort | int | `8080` |  |
| env | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nginx"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.host | string | `"chart-example.local"` |  |
| ingress.path | string | `"/"` |  |
| ingress.tls | object | `{}` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| probes.livenessProbe.httpGet.path | string | `"/"` |  |
| probes.livenessProbe.httpGet.port | string | `"http"` |  |
| probes.readinessProbe.httpGet.path | string | `"/"` |  |
| probes.readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| service.targetPort | int | `8080` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecar.args | list | `[]` |  |
| sidecar.enabled | bool | `false` |  |
| sidecar.image.pullPolicy | string | `"Always"` |  |
| sidecar.image.repository | string | `nil` |  |
| sidecar.image.tag | string | `nil` |  |
| sidecar.name | string | `nil` |  |
| sidecar.port | string | `nil` |  |
| sidecar.probe.httpHeaders.enabled | bool | `false` |  |
| sidecar.probe.httpHeaders.liveness.name | string | `"X-Kubernetes-Health-Check"` |  |
| sidecar.probe.httpHeaders.liveness.value | string | `"livenessProbe"` |  |
| sidecar.probe.httpHeaders.readiness.name | string | `"X-Kubernetes-Health-Check"` |  |
| sidecar.probe.httpHeaders.readiness.value | string | `"readinessProbe"` |  |
| sidecar.probe.initialDelaySeconds | int | `120` |  |
| sidecar.probe.path | string | `"/health"` |  |
| sidecar.probe.periodSeconds | int | `10` |  |
| sidecar.probe.type | string | `"request"` |  |
| tolerations | list | `[]` |  |
| url | string | `""` |  |
