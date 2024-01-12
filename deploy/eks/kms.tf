module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  aliases               = ["efs/${var.efsName}"]
  description           = "EFS customer managed key"
  enable_default_policy = true

  # For example use only
  deletion_window_in_days = 7

  tags = local.tags
}