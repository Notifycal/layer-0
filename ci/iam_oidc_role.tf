resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_thumbprints
  url             = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "trust_policydoc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      # TODO: Limit this to specific actions and branches
      values = formatlist("repo:%s/%s:*", var.github_organization_name, local.deployable_repos)
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values   = ["https://token.actions.githubusercontent.com"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_oidc_mgmt" {
  name                 = var.oidc_role_name
  description          = var.oidc_role_description
  max_session_duration = var.role_max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.trust_policydoc.json
}

data "aws_iam_policy_document" "oidc_can_assume_targets_policydoc" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    resources = formatlist("arn:aws:iam::%s:role/${var.ci_role_name}", toset(values(var.aws_target_account_ids)))
  }
}

resource "aws_iam_role_policy" "oidc_can_assume_targets" {
  name   = "allow-assume-target-ci"
  role   = aws_iam_role.github_oidc_mgmt.id
  policy = data.aws_iam_policy_document.oidc_can_assume_targets_policydoc.json
}
