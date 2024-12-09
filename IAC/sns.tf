#Cria um tópico no SNS
resource "aws_sns_topic" "upload_do_arquivo" {
  name = "arquivo-contabil-carregado"
}