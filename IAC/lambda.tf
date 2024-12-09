# Lambda Function
resource "aws_lambda_function" "processa_arquivo" {
  filename         = "../app/lambda_function.zip"
  function_name    = "process-arquivo-contabil"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.8"
  timeout         = 30

  environment {
    variables = {
      DB_HOST     = aws_db_instance.contabil.endpoint
      DB_NAME     = aws_db_instance.contabil.db_name
      DB_USER     = aws_db_instance.contabil.username
      DB_PASSWORD = aws_db_instance.contabil.password
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# Trigger da Lambda para processar mensagens do SQS
resource "aws_lambda_event_source_mapping" "trigger_sqs_lambda" {
  event_source_arn = aws_sqs_queue.processa_arquivo.arn
  function_name    = aws_lambda_function.processa_arquivo.function_name
  batch_size       = 1
  enabled          = true
}

# IAM Role para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_process_file_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Política para a Lambda acessar S3, SQS e CloudWatch Logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_process_file_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",""
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "rds:*"  # Adicionado para acesso ao RDS
        ]
        Resource = [
          "${aws_s3_bucket.bucket_contabil.arn}",
          "${aws_s3_bucket.bucket_contabil.arn}/*",
          aws_sqs_queue.processa_arquivo.arn,
          aws_sns_topic.upload_do_arquivo.arn,
          "arn:aws:logs:*:*:*",
          "${aws_db_instance.contabil.arn}"  # Adicionado ARN do RDS
        ]
      }
    ]
  })
}
# Política para a Lambda acessar VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}