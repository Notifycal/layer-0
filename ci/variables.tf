variable "github_thumbprints" {
  type = list(string)
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "role_name" {
  type    = string
  default = "ci-role-oidc"
}

variable "role_description" {
  type    = string
  default = "Role used by Github Actions to interact with AWS"
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

variable "role_attach_policies" {
  type        = map(string)
  description = "Map of IAM Policy ARNs to attach to the CI role"
}

variable "dependabot_pat" {
  type      = string
  sensitive = true
}
