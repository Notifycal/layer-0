data "aws_ssm_parameter" "private_access_oauth_app_id" {
  name = "/providers/github/oauth_app/private_access/client_id"
}

data "aws_ssm_parameter" "private_access_oauth_app_secret" {
  name = "/providers/github/oauth_app/private_access/client_secret"
}

data "cloudflare_accounts" "this" {
  name = "notifycal.com"
}

resource "cloudflare_access_identity_provider" "github" {
  account_id = data.cloudflare_accounts.this.accounts[0].id
  name       = "Github"
  type       = "github"

  config {
    client_id     = data.aws_ssm_parameter.private_access_oauth_app_id.value
    # TF always wants to update this client_secret :/
    client_secret = data.aws_ssm_parameter.private_access_oauth_app_secret.value
  }
}
