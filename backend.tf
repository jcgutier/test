data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket  = "terraform-states.nearsoft"
    profile = "default"
    region  = "us-east-1"
    key     = "Task/natanael-cano/k8s"
  }
}

provider "aws" {
    region = "us-east-1"
    profile = "default"
}

data "aws_eks_cluster_auth" "auth" {
  name = "natanael-cano-cluster"
}

provider "helm" {
  kubernetes {
    token                  = data.aws_eks_cluster_auth.auth.token
    host                   = data.terraform_remote_state.k8s.outputs.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.k8s.outputs.eks_cluster.certificate_authority.0.data)
    load_config_file       = false
  }
}

resource "helm_release" "prometheus" {
  name  = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart = "prometheus"
  namespace = "kube-system"
}
