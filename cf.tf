resource "aws_cloudfront_distribution" "l_e_fail_over" {
  origin {
    domain_name = aws_s3_bucket.l_e_fail_over.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.l_e_fail_over.id

    origin_access_control_id = aws_cloudfront_origin_access_control.l_e_fail_over.id
    connection_attempts      = "3"
    connection_timeout       = "10"
  }

  logging_config {
    bucket         = aws_s3_bucket.l_e_fail_over.bucket_regional_domain_name
    include_cookies = false
    prefix         = "logs/"
  }

  enabled = true

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.l_e_fail_over.id
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.l_e_fail_over.qualified_arn
      include_body = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "l_e_fail_over" {
  name                              = "${var.app_name}-origin-access-control"
  description                       = "OAC for ${aws_s3_bucket.l_e_fail_over.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
