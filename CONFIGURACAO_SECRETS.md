# 🔧 Configuração de Secrets para a Pipeline

Para que a pipeline CI/CD funcione corretamente, você precisa configurar os seguintes secrets no GitHub.

## 📋 Secrets Necessários

### AWS Credentials
1. `AWS_ACCESS_KEY_ID` - ID da chave de acesso AWS
2. `AWS_SECRET_ACCESS_KEY` - Chave secreta de acesso AWS

## 🔐 Como Configurar os Secrets

### 1. Acessar as Configurações do Repositório
1. Vá para o seu repositório no GitHub
2. Clique em **Settings** (Configurações)
3. No menu lateral, clique em **Secrets and variables** → **Actions**

### 2. Adicionar os Secrets
Para cada secret necessário:

1. Clique em **New repository secret**
2. Digite o nome exato do secret (ex: `AWS_ACCESS_KEY_ID`)
3. Cole o valor correspondente
4. Clique em **Add secret**

### 3. Obter Credenciais AWS

#### Opção 1: Usuário IAM (Recomendado)
1. Acesse o Console AWS → IAM
2. Crie um novo usuário ou use um existente
3. Anexe as seguintes políticas mínimas:
   ```
   - AmazonS3FullAccess
   - AmazonDynamoDBFullAccess (para Terraform state lock)
   ```
4. Gere uma chave de acesso para o usuário
5. Copie o Access Key ID e Secret Access Key

#### Políticas IAM Personalizadas (Mais Seguro)
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::achados-perdidos-*",
                "arn:aws:s3:::achados-perdidos-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:*:table/terraform-state-lock-*"
        }
    ]
}
```

## 🏗️ Recursos AWS Necessários

### Buckets S3 para Terraform State
Crie manualmente os seguintes buckets (ou use Terraform para criá-los):

```bash
# Buckets para armazenar o state do Terraform
aws s3 mb s3://achados-perdidos-terraform-state-dev --region us-east-1
aws s3 mb s3://achados-perdidos-terraform-state-prd --region us-east-1
```

### Tabelas DynamoDB para State Lock
```bash
# Tabela para lock do state (ATUALIZADO)
aws dynamodb create-table \
    --table-name state-us-east-1-github-aep \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-1

# OU se preferir usar a mesma tabela para ambos ambientes (recomendado)
# A tabela "state-us-east-1-github-aep" já foi criada ✅
```

## ✅ Verificar Configuração

Após configurar os secrets:

1. Faça um push para a branch `dev` ou `main`
2. Acesse **Actions** no seu repositório
3. Verifique se a pipeline está executando sem erros de autenticação

## ⚠️ Avisos de Segurança

- **Nunca commit credenciais no código**
- Use IAM roles quando possível ao invés de chaves de acesso
- Revise regularmente as permissões e rotacione as chaves
- Monitore o uso das credenciais via CloudTrail

## 🔄 Rotação de Credenciais

Para rotacionar as credenciais:

1. Crie novas chaves de acesso no AWS IAM
2. Atualize os secrets no GitHub
3. Teste a pipeline
4. Delete as chaves antigas no AWS IAM

## 📞 Suporte

Se encontrar problemas:

1. Verifique se os secrets estão configurados corretamente
2. Confirme se as credenciais AWS têm as permissões necessárias
3. Verifique os logs da pipeline em **Actions** → **[Nome da execução]**
4. Confirme se os buckets S3 e tabelas DynamoDB existem