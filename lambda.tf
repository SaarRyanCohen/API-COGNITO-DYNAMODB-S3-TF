data "archive_file" "welcome" {
  type        = "zip"
  source_file = "test.py"
  output_path = "test.zip"
}

data "archive_file" "post_authentication" {
  type        = "zip"
  source_file = "myfunction.py"
  output_path = "myfunction.zip"
}

resource "aws_lambda_function" "demo_lambda" {
  filename         = data.archive_file.welcome.output_path
  function_name    = "demo_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "test.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  source_code_hash = data.archive_file.welcome.output_base64sha256
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
  environment {
    variables = {
      hello_value = aws_ssm_parameter.hello_parameter.value
    }
  }
  vpc_config {
    subnet_ids         = aws_subnet.public_subnets[*].id
    security_group_ids = ["${aws_security_group.vpc_endpoints.id}"]
  }
}

resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myfunction.arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}



resource "aws_lambda_function" "myfunction" {
  filename         = data.archive_file.post_authentication.output_path  
  function_name    = "myfunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "myfunction.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  source_code_hash = data.archive_file.post_authentication.output_base64sha256
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
  vpc_config {
    subnet_ids         = aws_subnet.public_subnets[*].id
    security_group_ids = ["${aws_security_group.vpc_endpoints.id}"]
  }
    environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.my_table.name
      LOG_BUCKET = aws_s3_bucket.bucket.id
      
  }

} 
}