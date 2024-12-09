# RDS Instance
resource "aws_db_instance" "contabil" {
  identifier           = "ada-contabil-db"
  engine              = "postgres"
  engine_version      = "15.3"  # Versão mais recente e estável
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  skip_final_snapshot = true

  db_name  = "contabil"
  username = "admin"
  password = "@senhateste@"  # Melhor usar secrets manager em produção

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  # Desabilita acesso público
  publicly_accessible = false
  
  tags = {
    Name = "RDS Contabil"
  }
}