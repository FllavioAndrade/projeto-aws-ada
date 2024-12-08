resource "aws_s3_bucket" "bucket_contabil" {
  bucket = "ada-contabil-1182"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "acesso_bucket" {
  bucket = aws_s3_bucket.bucket_contabil.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.bucket_contabil.id
  description = "Nome do bucket criado"
}