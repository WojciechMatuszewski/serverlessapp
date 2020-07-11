data "aws_iam_policy_document" "public_bucket_access_document" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
}


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  policy = data.aws_iam_policy_document.public_bucket_access_document.json
}

resource "aws_s3_bucket" "website_redirect_bucket" {
  bucket = "www.${var.bucket_name}"
  acl    = "public-read"

  website {
    redirect_all_requests_to = var.bucket_name
  }
}

