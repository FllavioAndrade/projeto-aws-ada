# cria um SQS
resource "aws_sqs_queue" "processa_arquivo" {
  name = "process-arquivo-contabil"
  visibility_timeout_seconds = 60
}

# SQS Queue Policy
resource "aws_sqs_queue_policy" "politica_processa_arquivo" {
  queue_url = aws_sqs_queue.processa_arquivo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.processa_arquivo.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn": aws_sns_topic.file_uploaded.arn
          }
        }
      }
    ]
  })
}