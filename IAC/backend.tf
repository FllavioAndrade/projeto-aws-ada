# Data source para verificar se o bucket existe
data "aws_s3_bucket" "backend" {
  count  = fileexists("${path.module}/backend_initialized") ? 1 : 0
  bucket = "terraform-state-ada-1182"
}

# Habilita backend S3 somente após a primeira aplicação
terraform {
  backend "s3" {
    bucket = "terraform-state-ada-1182"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Recurso local para marcar que o backend foi inicializado
resource "local_file" "backend_initialized" {
  count    = fileexists("${path.module}/backend_initialized") ? 0 : 1
  filename = "${path.module}/backend_initialized"
  content  = "Backend initialized at ${timestamp()}"
}