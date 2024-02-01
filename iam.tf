resource "aws_iam_role" "l_e_fail_over" {
  name = "${var.app_name}-role"

  assume_role_policy = data.aws_iam_policy_document.l_e_fail_over.json
}

data "aws_iam_policy_document" "l_e_fail_over" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "l_e_fail_over" {
  role       = aws_iam_role.l_e_fail_over.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_cw_log_policy" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "l_e_fail_over" {
  name   = "${var.app_name}-policy"
  role   = aws_iam_role.l_e_fail_over.name
  policy = data.aws_iam_policy_document.lambda_cw_log_policy.json
}
