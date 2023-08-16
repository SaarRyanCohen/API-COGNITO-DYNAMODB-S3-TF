resource "aws_dynamodb_table" "my_table" {
  name         = "my-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  point_in_time_recovery {
    enabled = true
  }
  attribute {
    name = "user_id"
    type = "S"
  }
}
resource "random_id" "s3_bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "bucket" {
  bucket = "logs-aws${random_id.s3_bucket_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "s3bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_ssm_parameter" "hello_parameter" {
  name        = "/myapp/hello_parameter"
  description = "Parameter to store the 'hello' value"
  type        = "String"
  value       = "Hello, From My-App"
}
data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      aws_ssm_parameter.hello_parameter.arn,
]
}
}