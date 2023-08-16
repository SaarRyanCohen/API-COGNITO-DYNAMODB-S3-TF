
resource "aws_cognito_user_pool" "user_pool" {
  name = "my-user-pool"

  alias_attributes = ["email", "preferred_username"]
  
  auto_verified_attributes = ["email"]
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  lambda_config {
    post_authentication = aws_lambda_function.myfunction.arn
    post_confirmation   = aws_lambda_function.myfunction.arn

    
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "demo-app-cognito-client"

  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = true
  supported_identity_providers         = ["COGNITO"]
  refresh_token_validity               = 30
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  allowed_oauth_flows_user_pool_client = true
  prevent_user_existence_errors        = "ENABLED"
  callback_urls                        = ["${aws_apigatewayv2_stage.lambda_stage.invoke_url}/"]
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

}
resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
