locals {
  random_suffix = "r3h5d3gp"
  aws_region = "eu-west-1"
  project_name = "notifycal"

  global_tags = {
    Project = local.project_name
    Region = local.aws_region
  }

  remote_state_tags = merge(local.global_tags, {
    Managed-By = "Terragrunt"
  })
}

remote_state {
  backend = "s3"
  generate = {
    path = "_tg.backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket = "tofu-state-${local.project_name}-${local.random_suffix}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = local.aws_region
    encrypt = true
    dynamodb_table = "tofu-lock-${local.project_name}-${local.random_suffix}"

    s3_bucket_tags = local.remote_state_tags
    dynamodb_table_tags = local.remote_state_tags
  }
}

# tofu and terragrunt versions are handled by the files in the repo root.
generate "tofu_version" {
  path = ".opentofu-version"
  if_exists = "overwrite"
  disable_signature = true
  contents = file("${get_parent_terragrunt_dir()}/.opentofu-version")
}

generate "tg_version" {
  path = ".terragrunt-version"
  if_exists = "overwrite"
  disable_signature = true
  contents = file("${get_parent_terragrunt_dir()}/.terragrunt-version")
}

# Provider versions, this can be override (apparently) with the following TF mechanism
# https://developer.hashicorp.com/terraform/language/files/override#merging-terraform-blocks
generate "provider_versions" {
  path = "_tg.provider.versions.tf"
  if_exists = "overwrite"
  contents = file("${get_parent_terragrunt_dir()}/meta/providers/required_providers.tf")
}

# Assuming the AWS provider will be everywhere
generate "provider_aws" {
  path = "_tg.provider.aws.tf"
  if_exists = "overwrite"
  contents = file("${get_parent_terragrunt_dir()}/meta/providers/aws.tf")
}


terraform {
  extra_arguments "use_tofu" {
    commands  = ["plan", "apply"]
    # arguments = []
    env_vars = {
      TERRAGRUNT_TFPATH = "tofu"
    }
  }
}
