module "website_bucket" {
  source   = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  stage    = var.stage
  name     = var.application_name
  hostname = var.bucket_name

  //  parent_zone_id = aws_route53_zone.zone.name
}
