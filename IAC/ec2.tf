# EC2 Instance para Bastion Host
resource "aws_instance" "bastion" {
  ami           = "ami-0c7217cdde317cfec"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "flavio"  

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion-host"
  }
}