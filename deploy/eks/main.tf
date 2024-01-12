provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
    
  tags = {
    owner: "Ram Gopinathan"
    email: "rprakashg@gmail.com"
    website: "https://rprakashg.github.io"
  }
}