module "codebuild" {
  source = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=master"
  stage  = var.stage
  name   = "${var.application_name}-codebuild"

  buildspec = file("../buildspec.yml")

  build_image        = "aws/codebuild/standard:3.0"
  build_compute_type = "BUILD_GENERAL1_SMALL"
  build_timeout      = 60

  aws_region = var.region

  extra_permissions = ["s3:PutObject"]

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.stage
    },
    {
      name  = "BUCKET_NAME"
      value = module.website_bucket.s3_bucket_name
    }
  ]
}
