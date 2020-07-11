data "aws_iam_policy_document" "codepipeline_assume_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]
    resources = [
      module.website_bucket.s3_bucket_arn,
      "${module.website_bucket.s3_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "code_pipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_document.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  policy = data.aws_iam_policy_document.codepipeline_policy_document.json
  role   = aws_iam_role.code_pipeline_role.id
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.application_name}-pipeline"
  role_arn = aws_iam_role.code_pipeline_role.arn

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
        ProjectName = module.codebuild.project_name
      }
    }
  }
}
