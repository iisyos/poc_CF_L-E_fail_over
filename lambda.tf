provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

data "archive_file" "l_e_fail_over" {
  type        = "zip"
  source_dir  = "lambda"
  output_path = "index.zip"
}

resource "aws_lambda_function" "l_e_fail_over" {
  provider         = aws.virginia
  filename         = data.archive_file.l_e_fail_over.output_path
  function_name    = "${var.app_name}-function"
  role             = aws_iam_role.l_e_fail_over.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.l_e_fail_over.output_base64sha256
  runtime          = "nodejs18.x"

  publish = true

  memory_size = 128
  timeout     = 3
}

