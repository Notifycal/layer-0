resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "supabase_project" "notifycal" {
  organization_id   = "nwapjhhxalarfjebaxag"
  name              = var.supabase_project
  database_password = random_password.db_password.result
  region            = "eu-west-1"

  lifecycle {
    ignore_changes = [organization_id]
  }
}