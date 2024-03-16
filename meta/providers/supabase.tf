variable "supabase_access_token" {
  type = string
  sensitive = true
}

provider "supabase" {
  access_token = var.supabase_access_token
}
