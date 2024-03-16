resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "supabase_project" "notifycal" {
  organization_id   = var.supabase_org_id
  name              = var.supabase_project
  database_password = random_password.db_password.result
  region            = var.supabase_region

  lifecycle {
    # An organisation cannot be changed after creation
    ignore_changes = [organization_id]
  }
}

resource "aws_ssm_parameter" "supabase_db_password" {
  name        = "/providers/supabase/db_password"
  description = "The PostgreSQL password for Supabase"
  type        = "SecureString"
  value       = random_password.db_password.result
}
