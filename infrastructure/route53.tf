resource "aws_route53_zone" "zone" {
  name = "${var.bucket_name}."
}


//module "acm_request_certificate" {
//  source      = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=master"
//  domain_name = var.bucket_name
//
//  process_domain_validation_options = true
//  validation_method                 = "DNS"
//  subject_alternative_names         = ["*.${var.bucket_name}"]
//
//  zone_name = aws_route53_zone.zone.name
//}
