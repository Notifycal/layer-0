data "aws_ssm_parameter" "slack_bot_token" {
  name = "/providers/slack/botsecops/slack_token"
}
