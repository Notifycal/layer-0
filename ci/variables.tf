variable "github_thumbprints" {
  type = list(string)
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "aws_target_account_ids" {
  type = map(string)
  default = {
    nonprod = "381492094204"
    prod = "222261726252"
  }
}

variable "oidc_role_name" {
  type    = string
  default = "github-oidc-mgmt"
}

variable "oidc_role_description" {
  type    = string
  default = "Entry role for GitHub OIDC in management account"
}

variable "ci_role_name" {
  type = string
  default = "ci-role"
}

variable "ci_role_description" {
  type    = string
  default = "Role for Github Actions CI/CD"
}

variable "role_max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number
  default     = 3600

  validation {
    condition     = var.role_max_session_duration >= 3600 && var.role_max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "ci_role_attach_policies" {
  type        = map(string)
  description = "Map of IAM Policy ARNs to attach to the CI role"
}

variable "dependabot_pat" {
  type      = string
  sensitive = true
}

variable "enable_branch_protection" {
  type        = bool
  description = "Whether main branches will be protected in Github. Only works when using paid Github."
  default     = true
}
