data "aws_iam_policy_document" "ci_iam_access" {
  # provider = aws.nonprod

  statement {
    sid       = "IAMFullAccess"
    effect    = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }

  statement {
    sid    = "DenyUserAndGroupChanges"
    effect = "Deny"
    actions = [
      "iam:PutUserPolicy",
      "iam:PutUserPermissionsBoundary",
      "iam:DetachUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:DeleteUserPermissionsBoundary",
      "iam:AttachUserPolicy",
      "iam:UpdateUser",
      "iam:RemoveUserFromGroup",
      "iam:DeleteUser",
      "iam:CreateUser",
      "iam:AddUserToGroup",
      "iam:UpdateGroup",
      "iam:DeleteGroup",
      "iam:AttachGroupPolicy",
      "iam:DeleteGroupPolicy",
      "iam:DetachGroupPolicy",
      "iam:PutGroupPolicy",
      "iam:CreateGroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ci_iam_access" {
  # provider = aws.nonprod

  name   = "notifycal-ci-iam-access"
  path   = "/"
  policy = data.aws_iam_policy_document.ci_iam_access.json
}
