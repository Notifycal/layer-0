variable "cognito_user_pool_name" {
  type = string
  default = "notifycal-users"
}

resource "aws_cognito_user_pool" "user_pool" {
  name = var.cognito_user_pool_name
  
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection = "ACTIVE"
}

resource "aws_cognito_user_pool_client" "pool_client" {
  name = "client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
