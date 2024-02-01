resource "aws_s3_bucket" "l_e_fail_over" {
  bucket        = "${var.app_name}-bucket"
  force_destroy = true

  tags = {
    Name = "Short URL Bucket"
  }
}

resource "aws_s3_bucket_policy" "l_e_fail_over" {
  bucket = aws_s3_bucket.l_e_fail_over.id

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "PolicyForCloudFrontPrivateContent"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.l_e_fail_over.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" : aws_cloudfront_distribution.l_e_fail_over.arn
          }
        }
      }
    ]
  })
}

resource aws_s3_bucket_ownership_controls l_e_fail_over {
    bucket = aws_s3_bucket.l_e_fail_over.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
# ACLを設定
resource aws_s3_bucket_acl l_e_fail_over {
    bucket = aws_s3_bucket.l_e_fail_over.id
    acl    = "private"
    depends_on = [ aws_s3_bucket_ownership_controls.l_e_fail_over ]
}