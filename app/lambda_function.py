import json
import os
import boto3
import psycopg2
from urllib.parse import unquote_plus

#
def count_lines(s3_client, bucket, key):
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    return len(content.splitlines())

def save_to_db(filename, line_count):
    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        port=os.environ['DB_PORT'],
        database=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD']
    )
    #
    cur = conn.cursor()
    
    # Cria a tabela se não existir
    cur.execute("""
        CREATE TABLE IF NOT EXISTS arquivos_processados (
            id SERIAL PRIMARY KEY,
            nome_arquivo VARCHAR(255),
            num_linhas INTEGER,
            data_processamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    # Insere os dados
    cur.execute(
        "INSERT INTO arquivos_processados (nome_arquivo, num_linhas) VALUES (%s, %s)",
        (filename, line_count)
    )
    
    conn.commit()
    cur.close()
    conn.close()

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    
    for record in event['Records']:
        # Processa a mensagem do SQS
        body = json.loads(record['body'])
        s3_event = json.loads(body['Message'])
        
        for s3_record in s3_event['Records']:
            bucket = s3_record['s3']['bucket']['name']
            key = unquote_plus(s3_record['s3']['object']['key'])
            
            try:
                # Conta as linhas do arquivo
                line_count = count_lines(s3_client, bucket, key)
                
                # Salva no banco de dados
                save_to_db(key, line_count)
                
                print(f"Arquivo {key} processado com sucesso. Total de linhas: {line_count}")
                
            except Exception as e:
                print(f"Erro processando {key} do bucket {bucket}. Erro: {str(e)}")
                raise e
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processamento concluído com sucesso!')
    }
