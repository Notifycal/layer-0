include "root" {
  path = find_in_parent_folders()
}

generate "provider_supabase" {
  path = "_tg.provider.supabase.tf"
  if_exists = "overwrite"
  contents = file("${get_parent_terragrunt_dir()}/meta/providers/supabase.tf")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = merge(local.common_vars.inputs, {})
