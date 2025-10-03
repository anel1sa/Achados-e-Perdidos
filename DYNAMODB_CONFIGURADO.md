# 🗃️ Configuração Atualizada para Tabela DynamoDB

## ✅ **Tabela DynamoDB Configurada:**

**Nome da tabela:** `state-sa-east-1-github-aep`

Os arquivos backend.tfvars foram atualizados para usar sua tabela DynamoDB.

## 📋 **Recursos AWS Necessários:**

### ✅ **DynamoDB (Criado por você):**
- `state-sa-east-1-github-aep` ✅

### 🔲 **Buckets S3 (Verificar se existem):**

Você precisa criar estes buckets S3 para armazenar o state:

```bash
# Bucket para ambiente dev
aws s3 mb s3://achados-perdidos-terraform-state-dev --region sa-east-1

# Bucket para ambiente prd  
aws s3 mb s3://achados-perdidos-terraform-state-prd --region sa-east-1
```

### 🔧 **Verificar se buckets existem:**
```bash
aws s3 ls | grep achados-perdidos-terraform-state
```

## 🚀 **Testar Configuração:**

Agora que a tabela DynamoDB está configurada, você pode testar:

```bash
# Teste com ambiente dev
terraform init -backend-config="envs/dev/backend.tfvars"

# Se funcionar, teste um plan
terraform plan -var-file="envs/dev/terraform.tfvars"
```

## ⚠️ **Se aparecer erro de bucket não encontrado:**

Crie os buckets S3:
```bash
aws s3 mb s3://achados-perdidos-terraform-state-dev --region sa-east-1
aws s3 mb s3://achados-perdidos-terraform-state-prd --region sa-east-1
```

## ✅ **Pipeline Atualizada:**

A pipeline já está configurada para usar:
- ✅ **DynamoDB**: `state-sa-east-1-github-aep`
- ✅ **Buckets S3**: `achados-perdidos-terraform-state-{env}`
- ✅ **Ambientes**: Separados (dev/prd)

**Próximo passo:** Verificar se os buckets S3 existem e testar a inicialização!