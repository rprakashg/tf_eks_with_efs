variable "region" {
  description = "EKS Cluster AWS region"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "EKS Cluster name"
  type = string
  default = "admincluster"
}

variable "k8s-version" {
  description = "Kubernetes version"
  type = string
  default = "1.27"
}

variable efsName {
  description = "value"
  type = string

  default = "openshift-installs"
}

variable efsReplicationDestination {
  description = "EFS replication destination"
  type = string
  
  default = "us-east-2"
}