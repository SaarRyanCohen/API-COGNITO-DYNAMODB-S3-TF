output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.demo_lambda.function_name
}

output "api_gateway_endpoint" {
  description = "Base URL for API Gateway stage."
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/"
}


output "lambda_function_name" {
  description = "The lambda function name"
  value       = aws_lambda_function.demo_lambda.function_name
}


