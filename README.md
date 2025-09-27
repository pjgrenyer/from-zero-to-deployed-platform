# from-zero-to-deployed-platform
Terraform for from Zero to Deployed

# Create artifact

```
zip -r from_zero_to_deployed.zip dist
```

# Create S3 Bucket

```
resource "aws_s3_bucket" "from_zero_to_deployed" {
  bucket = "from-zero-to-deployed"
}
```

# Upload Artifact to Bucket

```
resource "aws_s3_object" "from_zero_to_deployed" {
  bucket = aws_s3_bucket.from_zero_to_deployed.id
  key    = "from_zero_to_deployed.zip"
  source = "from_zero_to_deployed.zip"
}
```
# Create a Role so the Lambda can run

Adding a role to a lambda allows it to gain permissions for other services, such as logging.

- A Lambda does not require this role to be specificed
- Terraform does require a role to be specifiec for a lambda

```
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
```

# Allow the Lambda to Log to Cloudwatch
```
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
```

# Create the Lambda
```
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
```

# Create a Payload

```
{
    "key": "value"
}
```

# Execute to Lamba with the Payload
```
aws lambda invoke --function-name from-zero-to-deployed --payload file://payload.json --cli-binary-format raw-in-base64-out response.json && more response.json
```






