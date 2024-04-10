# Lambda Function
data "archive_file" "lambda_file_archive" {
  type        = "zip"
  source_file = "${path.module}/functions/lambda.py"
  output_path = "${path.module}/functions/lambda.zip"
}

resource "aws_lambda_function" "my_lambda" {
  filename         = data.archive_file.lambda_file_archive.output_path
  source_code_hash = data.archive_file.lambda_file_archive.output_base64sha256

  function_name = "alb_lambda_function"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.10"
  timeout       = 180
  memory_size   = 128
  role          = aws_iam_role.lambda_role.arn

  vpc_config {
    subnet_ids         = module.network.public_subnet_ids
    security_group_ids = [module.network.vpc_default_security_group_id]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticloadbalancing.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach basic Lambda execution policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_network" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  role       = aws_iam_role.lambda_role.name
}

# Associate Lambda function permission with ALB Target Group for Lambda
resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.alb_tg_lambda.arn
}
