data "aws_ssm_parameter" "google_oauth2_client_id" {
  name = "/providers/google/oauth2/client_id"
}

data "aws_ssm_parameter" "google_oauth2_client_secret" {
  name = "/providers/google/oauth2/client_secret"
  with_decryption = true
}

resource "supabase_settings" "settings" {
  project_ref = supabase_project.notifycal.id

  auth = jsonencode({
    external_email_enabled = false
    external_google_enabled = true
    # This provider is crap, sensitive data hides the whole block (:
    external_google_client_id = data.aws_ssm_parameter.google_oauth2_client_id.value
    external_google_secret = data.aws_ssm_parameter.google_oauth2_client_secret.value
  })
}
