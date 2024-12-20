# RDS Instance
resource "aws_db_instance" "contabil" {
  identifier           = "ada-contabil-db"
  engine              = "postgres"
  engine_version      = "15.7"  
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  skip_final_snapshot = true

  db_name  = "contabil"
  username = "dbadmin"
  password = "senhateste" #QUE COISA FEIA, NÃO FAÇA ISSO EM PRODUÇÃO (<3)

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  # Desabilita acesso público
  publicly_accessible = false
    
  # Habilita monitoramento básico
  monitoring_interval = 0
  
  tags = {
    Name    = "RDS Contabil"
    Projeto = "Ada Contabilidade"
    dono    = "Flavio de Andrade"
  }
}