module "efs" {
    source  = "terraform-aws-modules/efs/aws"

    //File system
    name                                    = var.efsName
    creation_token                          = var.efsName
    encrypted                               =  true
    kms_key_arn                             = module.kms.key_arn

    performance_mode                        = "maxIO"
    throughput_mode                         = "provisioned"
    provisioned_throughput_in_mibps         = 256

    lifecycle_policy = {
        transition_to_ia                        = "AFTER_30_DAYS"
        transition_to_primary_storage_class     = "AFTER_1_ACCESS"
    }

    # File system policy
    attach_policy                           = true
    bypass_policy_lockout_safety_check      = false
    policy_statements = [
        {
            sid     = "demoefs"
            actions = ["elasticfilesystem:ClientMount"]
            principals = [
                {
                    type        = "AWS"
                    identifiers = [data.aws_caller_identity.current.arn]
                }
            ]
        }
    ]
    
    //Mount targets and security group
    mount_targets = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v  } }
    security_group_description = "EFS Security Group"
    security_group_vpc_id = module.vpc.vpc_id
    security_group_rules = {
        vpc = {
            description = "NFS Ingress from private subnets"
            cidr_blocks = module.vpc.private_subnets_cidr_blocks
        }
    }

    //access point
    access_points = {
        posix_example = {
            name = "posix-demo"
            posix_user = {
                gid     = 1001
                uid             = 1001
                secondary_gids  = [1002]
            }
        }
        root_demo = {
            root_directory = {
                path            = "/k8s"
                creation_info   = {
                    owner_gid       = 1001
                    owner_uid       = 1001
                    permissions     = 755
                }

            }
        }
    }
    
    //backup policy
    enable_backup_policy = true

    //replication configuration
    create_replication_configuration = true
    replication_configuration_destination = {
        region = var.efsReplicationDestination
    }

    depends_on      = [ module.vpc ]
}
