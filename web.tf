
# Provider block for AWS
provider "aws" {

  region = "us-east-2"
}
module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"
}

# Create an S3 bucket for storing website files
resource "aws_s3_bucket_acl" "website_bucket" {
  bucket = "thami-website-bucket"
  acl    = "public-read"
}

# Enable website hosting for the S3 bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket_acl.website_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

# Create IAM policies for the different user groups
resource "aws_iam_policy" "marketing_policy" {
  name = "MarketingPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket_acl.website_bucket.acl}",
          "${aws_s3_bucket_acl.website_bucket.acl}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "public-read"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "content_editor_policy" {
  name = "ContentEditorPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket_acl.website_bucket.acl}",
          "${aws_s3_bucket_acl.website_bucket.acl}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "hr_policy" {
  name = "HrPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket_acl.website_bucket.acl}/people.html",
          "${aws_s3_bucket_acl.website_bucket.acl}/people.html/*"
        ]
      }
    ]
  })
}

# Create the IAM users and attach the policies
resource "aws_iam_user" "alice" {
  name = "alice"
}

resource "aws_iam_user" "malory" {
  name = "malory"
}

resource "aws_iam_user" "bobby" {
  name = "bobby"
}

resource "aws_iam_user" "charlie" {
  name = "charlie"
}


resource "aws_iam_user_policy_attachment" "alice_policy_attachment" {
  user       = aws_iam_user.alice.name
  policy_arn = aws_iam_policy.marketing_policy.arn
}

resource "aws_iam_user_policy_attachment" "malory_policy_attachment" {
  user       = aws_iam_user.malory.name
  policy_arn = aws_iam_policy.marketing_policy.arn
}

resource "aws_iam_user_policy_attachment" "bobby_policy_attachment" {
  user       = aws_iam_user.bobby.name
  policy_arn = aws_iam_policy.content_editor_policy.arn
}

resource "aws_iam_user_policy_attachment" "charlie" {
  user       = aws_iam_user.charlie.name
  policy_arn = aws_iam_policy.content_editor_policy.arn
}
