module "codebuild" {
  source = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=master"
  stage  = var.stage
  name   = "${var.application_name}-codebuild"

  buildspec = file("../buildspec.yml")

  build_image        = "aws/codebuild/standard:3.0"
  build_compute_type = "BUILD_GENERAL1_MEDIUM"
  build_timeout      = 60

  aws_region = var.region

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.stage
    },
    {
      name  = "BUCKET_NAME"
      value = aws_s3_bucket.website_bucket.bucket
    }
  ]
}

resource "aws_iam_role_policy_attachment" "something" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = module.codebuild.role_id
}

