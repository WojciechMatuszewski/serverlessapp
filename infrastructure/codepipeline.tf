module "website_bucket" {
  source   = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  stage    = var.stage
  name     = var.application_name
  hostname = var.bucket_name
}


resource "aws_codepipeline" "pipeline" {
  name     = "${var.application_name}-pipeline"
  role_arn = module.codebuild.role_arn

  artifact_store {
    location = module.website_bucket.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = [var.application_name]

      configuration = {
        Owner                = var.github_user_name
        Repo                 = var.github_repo_name
        OAuthToken           = data.sops_file.secrets.data["github_token"]
        PollForSourceChanges = "true"
        Branch               = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      category        = "Build"
      name            = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = [var.application_name]

      configuration = {
        ProjectName = "testing"
      }
    }
  }
}
