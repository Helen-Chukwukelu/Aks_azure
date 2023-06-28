#from the helm-admin.tf file
resource "helm_release" "consul" {
  name              = "hashicorp"
  chart             = "consul"
  repository        = "https://helm.releases.hashicorp.com"
  version           = "0.28.0"
  namespace         = kubernetes_namespace.consul.metadata.0.name
  create_namespace  = "false"
  timeout           = "600"
  values = [
    file("helm-values/consul-values.yaml")
  ]
  set {
    name  = "global.datacenter"
    value = "${lower(var.CLUSTER_NAME)}-aks-za"
  }
  set {
    name  = "global.gossipEncryption.secretName"
    value = kubernetes_secret.consul_gossip_key.metadata.0.name
  }
  // set {
  //   name  = "global.lifecycleSidecarContainer.resources.limits.cpu"
  //   value = "600m"
  // }
  set {
    name  = "server.storage"
    value = var.NODES == 1 ? "2Gi" : "5Gi"
  }
  set {
    name  = "server.replicas"
    value = var.NODES == 1 ? 1 : 3
  }
  set {
    name  = "server.bootstrapExpect"
    value = var.NODES == 1 ? 1 : 3
  }
  set {
    name  = "ingressGateways.defaults.replicas"
    value = var.NODES == 1 ? 1 : 2
  }
  depends_on  = [
    kubernetes_secret.consul_gossip_key
  ]
}