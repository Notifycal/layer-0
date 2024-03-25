resource "aws_iam_openid_connect_provider" "github" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = var.github_thumbprints
  url             = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "ci_role" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.role_max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.trust_policydoc.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = toset(var.role_attach_policies)
  
  policy_arn = each.value
  role       = aws_iam_role.ci_role.name
}

data "aws_iam_policy_document" "trust_policydoc" {
  statement {
    effect = "Allow"
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
      values = formatlist("repo:%s/%s:*", var.github_organization_name, local.repos)
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values = ["https://token.actions.githubusercontent.com"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = ["sts.amazonaws.com"]
    }
  }
}
