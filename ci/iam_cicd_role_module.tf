module "cicd_role_nonprod" {
  providers = {
    aws = aws.nonprod
  }

  source = "../modules/ci-role-target-account"

  role_name = var.ci_role_name
  role_description = var.ci_role_description
  role_max_session_duration = var.role_max_session_duration
  role_attach_policies = var.ci_role_attach_policies

  assume_role_role_arn = aws_iam_role.github_oidc_mgmt.arn
}
