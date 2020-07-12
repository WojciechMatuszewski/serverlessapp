locals {
  distribution_origin_id = "myDistributionID"
}

resource "aws_cloudfront_distribution" "website_distribution" {

  origin {

    domain_name = aws_s3_bucket.website_bucket.website_endpoint
    origin_id   = local.distribution_origin_id

    custom_origin_config {

      origin_protocol_policy = "http-only"
      http_port = "80"
      https_port = "443"

      origin_ssl_protocols = ["TLSv1.2"]
    }

  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = "index.html"
  aliases             = []

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.distribution_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:286420114124:certificate/fa17f96e-cb27-418d-a591-8f45891f0086"
    ssl_support_method  = "sni-only"
  }
}
