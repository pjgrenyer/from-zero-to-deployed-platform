# from-zero-to-deployed-platform
Terraform for from Zero to Deployed

# Create artifact

```
cd code
zip ../from_zero_to_deployed.zip index.js
cd ..
```

# Create S3 Bucket

```
resource "aws_s3_bucket" "email_sender_lambda" {
  bucket = "email-sender-lambda"
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




