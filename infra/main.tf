terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = merge(
    {
      Project     = var.project
      Owner       = var.owner
      Environment = var.environment
      ManagedBy   = "Terraform"
      Practice    = "P12"
    },
    var.extra_tags
  )
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "p12" {
  bucket = "${var.bucket_prefix}-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_versioning" "p12" {
  bucket = aws_s3_bucket.p12.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "p12" {
  bucket = aws_s3_bucket.p12.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "p12" {
  bucket                  = aws_s3_bucket.p12.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "p12_deny_insecure" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.p12.arn,
      "${aws_s3_bucket.p12.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "p12" {
  bucket     = aws_s3_bucket.p12.id
  policy     = data.aws_iam_policy_document.p12_deny_insecure.json
  depends_on = [aws_s3_bucket_public_access_block.p12]
}
