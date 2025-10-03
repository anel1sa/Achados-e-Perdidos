# Bucket para imagens
resource "aws_s3_bucket" "images" {
    bucket = "${var.project_name}-${var.env}-images-bucket"
    
    tags = merge(var.tags, {
        Name = "${var.project_name}-${var.env}-images-bucket"
        Type = "images"
    })
}

resource "aws_s3_bucket_versioning" "images_versioning" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket para frontend (Flutter Web)
resource "aws_s3_bucket" "frontend" {
    bucket = "${var.project_name}-${var.env}-frontend"
    
    tags = merge(var.tags, {
        Name = "${var.project_name}-${var.env}-frontend"
        Type = "frontend"
    })
}

resource "aws_s3_bucket_versioning" "frontend_versioning" {
  bucket = aws_s3_bucket.frontend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configuração de website estático para o frontend
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Política de acesso público para o frontend
resource "aws_s3_bucket_public_access_block" "frontend_pab" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_pab]
}