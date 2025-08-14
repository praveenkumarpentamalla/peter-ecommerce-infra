resource "aws_amplify_app" "frontend" {
  name       = "Peter-frontend"
  repository = "https://github.com/praveenkumarpentamalla/peter-frontend.git"
  auto_branch_creation_patterns = ["*"]
  enable_auto_branch_creation   = true
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_amplify_app.frontend.default_domain
    origin_id   = "amplify"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
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

  aliases = [aws_amplify_app.frontend.default_domain]
}