aws_region = "eu-west-1"
project = "notifycal"
stack = "ci"
# TODO: Limit perms
role_attach_policies = [
  "arn:aws:iam::aws:policy/PowerUserAccess"
]
