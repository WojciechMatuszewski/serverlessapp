resource "aws_route53_zone" "zone" {
  name = "${var.bucket_name}."
}

resource "aws_acm_certificate" "website_cert" {
  depends_on  = [aws_route53_zone.zone]
  domain_name = var.bucket_name

  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.bucket_name}"]
}

resource "aws_route53_record" "cert_validation" {
  depends_on = [aws_route53_zone.zone]
  name       = aws_acm_certificate.website_cert.domain_validation_options[0].resource_record_name
  type       = aws_acm_certificate.website_cert.domain_validation_options[0].resource_record_type
  zone_id    = aws_route53_zone.zone.id
  records    = [aws_acm_certificate.website_cert.domain_validation_options[0].resource_record_value]
  ttl        = 60
}

resource "aws_route53_record" "website_record" {
  depends_on = [aws_s3_bucket.website_bucket, aws_cloudfront_distribution.website_distribution, aws_route53_zone.zone]

  name    = ""
  type    = "A"
  zone_id = aws_route53_zone.zone.id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
  }
}


resource "aws_route53_record" "website_c_record" {
  depends_on = [aws_s3_bucket.website_bucket, aws_s3_bucket.website_redirect_bucket, aws_route53_zone.zone]

  name    = "www"
  type    = "CNAME"
  zone_id = aws_route53_zone.zone.id

  records = [var.bucket_name]

  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.website_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

