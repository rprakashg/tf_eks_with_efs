module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "19.15.3"

    cluster_name = var.name
    cluster_version = var.k8s-version

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    cluster_endpoint_public_access = true

    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"

        attach_cluster_primary_security_group = true

        # Disabling and using externally provided security groups
        create_security_group = false
    }
    
    eks_managed_node_groups = {
        one = {
            name = "node-group-1"

            instance_types = ["t3.small"]

            min_size     = 1
            max_size     = 3
            desired_size = 2

            pre_bootstrap_user_data = <<-EOT
            echo 'foo bar'
            EOT

            vpc_security_group_ids = [
                aws_security_group.node_group_one.id
            ]
        }

        two = {
            name = "node-group-2"

            instance_types = ["t3.medium"]

            min_size     = 1
            max_size     = 3
            desired_size = 2

            pre_bootstrap_user_data = <<-EOT
            echo 'foo bar'
            EOT

            vpc_security_group_ids = [
                aws_security_group.node_group_two.id
            ]
        }
    }

}