# Lambda Function
resource "aws_lambda_function" "processa_arquivo" {
  filename         = "../app/lambda_function.zip"
  function_name    = "process-arquivo-contabil"
  role            = "aws_iam_role.lambda_role.arn"
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.8"
  timeout         = 30
  memory_size     = 256  # Aumentado para ter mais recursos

  environment {
    variables = {
      DB_HOST     = aws_db_instance.contabil.endpoint
      DB_NAME     = aws_db_instance.contabil.db_name
      DB_USER     = aws_db_instance.contabil.username
      DB_PASSWORD = aws_db_instance.contabil.password
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]  # Usando duas subnets para redundância
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
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

# Política básica de execução da Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Política para acesso à VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Política personalizada para a Lambda
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
          "s3:PutObject",
          "s3:ListBucket",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sns:Publish"
        ]
        Resource = [
          "${aws_s3_bucket.bucket_contabil.arn}",
          "${aws_s3_bucket.bucket_contabil.arn}/*",
          aws_sqs_queue.processa_arquivo.arn,
          aws_sns_topic.upload_do_arquivo.arn
        ]
      }
    ]
  })
}