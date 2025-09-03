variable "role_name" {
  type = string
  default = "ci-role"
}

variable "role_description" {
  type = string
  default = "Role for Github Actions CI/CD"
}

variable "role_max_session_duration" {
  type = number
  default = 3600 # Hard limit, explicit

  validation {
    condition     = var.role_max_session_duration == 3600
    error_message = "There is a hard limit of 3600 seconds for AssumeRole chaining"
  }
}

variable "role_attach_policies" {
  type        = map(string)
  description = "Map of IAM Policy ARNs to attach to the CI role"
}

variable "assume_role_role_arn" {
  type = string
  description = "Role that is able to assume the CI/CD role created here"
}
