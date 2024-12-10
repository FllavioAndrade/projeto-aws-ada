# Projeto Ada Contabilidade - Automação de Processamento de Arquivos

## Descrição
Este projeto implementa uma solução automatizada para o processamento de arquivos contábeis, substituindo um processo manual propenso a erros. A solução utiliza serviços AWS em uma arquitetura serverless para processar arquivos, contar linhas e armazenar metadados.

## Estrutura do Projeto
```
.
├── app/
│   ├── lambda_function.py    # Função Lambda para processamento
│   ├── lambda_function.zip   # Pacote da função Lambda
│   └── main.py              # Script gerador de CSV
├── IAC/
│   ├── ec2.tf               # Configuração do Bastion Host
│   ├── lambda.tf            # Configuração da Lambda
│   ├── main.tf              # Configurações principais do Terraform
│   ├── rds.tf               # Configuração do RDS
│   ├── s3.tf                # Configuração dos buckets S3
│   ├── security_group.tf    # Grupos de segurança
│   ├── sns.tf               # Configuração do SNS
│   ├── sqs.tf               # Configuração do SQS
│   └── vpc.tf               # Configuração da VPC
└── README.md
```

## Componentes

### Aplicação (`app/`)
- `main.py`: Gera arquivos CSV com dados aleatórios
- `lambda_function.py`: Processa arquivos e salva metadados no RDS
- `lambda_function.zip`: Pacote deployável da função Lambda

### Infraestrutura (`IAC/`)
- VPC com subnets públicas e privadas
- RDS PostgreSQL para armazenamento de dados
- Lambda Function para processamento
- S3 Bucket para armazenamento de arquivos
- SNS/SQS para mensageria
- Bastion Host para acesso ao RDS
- Security Groups para controle de acesso

## Pré-requisitos
- AWS CLI configurado
- Terraform v1.6.0 ou superior
- Python 3.8 ou superior
- Conta AWS com permissões necessárias

## Implantação

1. Clone o repositório:
```bash
git clone https://github.com/FllavioAndrade/projeto-aws-ada.git
cd projeto-aws-ada
```



2. Deploy da infraestrutura:
```bash
cd ./IAC
terraform init
terraform plan
terraform apply
```

3. Gere e envie um arquivo CSV:
```bash
cd ./app
python main.py
```

## Funcionamento
1. Script Python gera arquivo CSV com dados aleatórios
2. Arquivo é enviado para S3 automaticamente
3. Upload aciona notificação SNS
4. Mensagem é enviada para fila SQS
5. Lambda é acionada e processa o arquivo
6. Metadados são salvos no RDS

## Segurança
- VPC privada para recursos críticos
- Bastion Host para acesso ao RDS
- Security Groups específicos para cada componente
- IAM Roles com mínimo privilégio necessário

## Automação
- Upload automático de arquivos
- Processamento serverless via Lambda
- Notificações automáticas via SNS/SQS
- Infraestrutura como Código com Terraform

## Manutenção
Para destruir a infraestrutura:
```bash
cd IAC
terraform destroy
```

## Autor
Flávio Andrade Silva

## Licença
Este projeto está sob a licença MIT.