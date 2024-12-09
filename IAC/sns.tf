#Cria um tópico no SNS
resource "aws_sns_topic" "upload_do_arquivo" {
  name = "arquivo-contabil-carregado"
}

# Subscrição do SQS no tópico SNS
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.upload_do_arquivo.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.processa_arquivo.arn
}