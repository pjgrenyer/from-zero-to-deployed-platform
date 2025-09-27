resource "aws_s3_bucket" "from_zero_to_deployed" {
  bucket = "email-sender-lambda"
}

resource "aws_s3_object" "from_zero_to_deployed" {
  bucket = aws_s3_bucket.from_zero_to_deployed.id
  key    = "from_zero_to_deployed.zip"
  source = "from_zero_to_deployed.zip"
}

resource "aws_iam_role" "lambda" {
  name = "lambda"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "lambda_role_logs_policy" {
  name   = "LambdaLogsPolicy"
  role   = aws_iam_role.lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
  }
EOF
}

resource "aws_lambda_function" "from_zero_to_deployed" {
  s3_bucket     = aws_s3_bucket.from_zero_to_deployed.id
  s3_key        = aws_s3_object.from_zero_to_deployed.key
  function_name = "from-zero-to-deployed"
  role          = aws_iam_role.lambda.arn
  handler       = "dist/index.handler"
  publish       = true

  runtime = "nodejs20.x"
  layers  = []
}

