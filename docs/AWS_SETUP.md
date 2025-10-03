# AWS Setup - Achados e Perdidos

Configuração rápida da infraestrutura AWS para as pipelines.

## 🏗️ Setup Básico

### 1. Criar Buckets S3
```bash
aws s3 mb s3://achados-perdidos-releases --region us-east-1
aws s3 mb s3://achados-perdidos-web --region us-east-1
```

### 2. Criar Usuário IAM
```bash
aws iam create-user --user-name achados-perdidos-ci
```

### 3. Política IAM
Salve como `ci-policy.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl", 
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::achados-perdidos-releases",
                "arn:aws:s3:::achados-perdidos-releases/*",
                "arn:aws:s3:::achados-perdidos-web",
                "arn:aws:s3:::achados-perdidos-web/*"
            ]
        }
    ]
}
```

### 4. Aplicar Política
```bash
aws iam create-policy --policy-name AchadosPerdidosCI --policy-document file://ci-policy.json

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws iam attach-user-policy \
  --user-name achados-perdidos-ci \
  --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AchadosPerdidosCI
```

### 5. Gerar Access Keys
```bash
aws iam create-access-key --user-name achados-perdidos-ci
```

⚠️ **Salve as keys** - use nos secrets do GitHub

## 🛡️ Segurança

### Bucket Policy (Download Público)
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::achados-perdidos-releases/releases/*"
        }
    ]
}
```

### Aplicar Policy no Bucket
```bash
aws s3api put-bucket-policy --bucket achados-perdidos-releases --policy file://bucket-policy.json
```

## � Custos Estimados
- **S3**: <$1 USD/mês
- **CloudFront** (opcional): ~$5 USD/mês

## 🧹 Script de Limpeza
```bash
# cleanup.sh
aws s3 rm s3://achados-perdidos-releases --recursive
aws s3 rb s3://achados-perdidos-releases
aws s3 rm s3://achados-perdidos-web --recursive  
aws s3 rb s3://achados-perdidos-web
aws iam detach-user-policy --user-name achados-perdidos-ci --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/AchadosPerdidosCI
aws iam delete-policy --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/AchadosPerdidosCI
aws iam delete-user --user-name achados-perdidos-ci
```