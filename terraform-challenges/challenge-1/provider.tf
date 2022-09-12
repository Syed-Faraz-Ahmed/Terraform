provider "kubernetes" {
    config_path    = "/root/.kube/config"
}
terraform {
  required_providers {
    kubernetes = {
      version = "= 2.11.0"
      source = "hashicorp/kubernetes"
    }
  }
}