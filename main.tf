# terraform settings
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Provider
provider "digitalocean" {
  token = var.do_token
}

# Resources
resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name   = var.k8s_name
  region = var.region
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}

# resource "digitalocean_kubernetes_node_pool" "node_premium" {
#   cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id
#   name       = "premium"
#   size       = "s-4vcpu-4gb"
#   node_count = 1
# }

#Variables

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

# Output

# output "kube_config" {
#   value = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
# }

output "kube_endpoint" {
   value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
 }