locals {
  role_attach_policies = merge(var.role_attach_policies, {
    iam_no_user_nor_group_access = aws_iam_policy.ci_iam_access.arn
  })
}

data "aws_iam_policy_document" "ci_trust" {
  provider = aws.nonprod

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.github_oidc_mgmt.arn] 
    }
    # Optional hardening if you use AWS Organizations
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:PrincipalOrgID"
    #   values   = ["o-xxxxxxxxxx"]
    # }
  }
}

resource "aws_iam_role" "ci_role" {
  provider = aws.nonprod

  name                 = var.ci_role_name
  description          = var.ci_role_description
  max_session_duration = var.role_max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.ci_trust.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  provider = aws.nonprod

  for_each = local.role_attach_policies

  policy_arn = each.value
  role       = aws_iam_role.ci_role.name
}


