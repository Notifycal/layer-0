resource "github_actions_secret" "iam_role_for_ci" {
  for_each = local.repos

  repository       = each.value
  secret_name      = "AWS_IAM_ROLE_CI"
  plaintext_value  = aws_iam_role.ci_role.arn
}
