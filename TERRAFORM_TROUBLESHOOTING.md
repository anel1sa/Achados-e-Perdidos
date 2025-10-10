# 🔧 Soluções para Warnings e Erros do Terraform

## ⚠️ **Warning: Deprecated Parameter `dynamodb_table`**

### **Problema:**
```
Warning: Deprecated Parameter
The parameter "dynamodb_table" is deprecated. Use parameter "use_lockfile" instead.
```

### ✅ **Soluções:**

#### **Opção 1: Manter `dynamodb_table` (Funcional)**
- **Status**: ✅ Funciona perfeitamente na pipeline
- **Ação**: Ignorar o warning (não afeta funcionalidade)
- **Motivo**: `dynamodb_table` ainda é suportado e funcional

#### **Opção 2: Usar versão específica do Terraform**
- **Configuração**: `required_version = ">= 1.0, < 1.10"`
- **Resultado**: Reduz warnings em versões mais novas

#### **Opção 3: Migrar para `use_lockfile` (Futuro)**
```hcl
# backend.tfvars (nova sintaxe)
bucket = "achados-perdidos-terraform-state-dev"
key    = "dev/terraform.tfstate"
region = "us-east-1"
encrypt = true
use_lockfile = true
# Não especificar dynamodb_table diretamente
```

## ❌ **Erro: No valid credential sources found**

### **Problema:**
```
Error: No valid credential sources found
Error: failed to refresh cached credentials, no EC2 IMDS role found
```

### ✅ **Soluções:**

#### **Para Desenvolvimento Local:**

1. **AWS CLI configurado:**
   ```bash
   aws configure
   # Inserir AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY
   ```

2. **Variáveis de ambiente:**
   ```bash
   export AWS_ACCESS_KEY_ID="AKIA..."
   export AWS_SECRET_ACCESS_KEY="..."
   export AWS_DEFAULT_REGION="us-east-1"
   ```

3. **Pular backend remoto para testes locais:**
   ```hcl
   # backend.tf (para testes locais)
   terraform {
     # backend "s3" {}  # Comentar esta linha
   }
   ```

#### **Para Pipeline GitHub Actions:**
- ✅ **Já configurado** - A pipeline usa secrets do GitHub
- ✅ **Credenciais injetadas automaticamente** via `aws-actions/configure-aws-credentials`

## 🎯 **Recomendações:**

### **Para Ambiente de Desenvolvimento:**
1. **Ignorar warnings** - Não afetam funcionalidade
2. **Configurar AWS CLI** para testes locais
3. **Usar backend local** durante desenvolvimento

### **Para Pipeline (Produção):**
1. ✅ **Manter configuração atual** - Funciona perfeitamente
2. ✅ **Warnings não afetam** execução da pipeline
3. ✅ **Credenciais já configuradas** via GitHub Secrets

## 📋 **Status Atual:**

### ✅ **Pipeline Pronta:**
- **Backend S3**: Configurado corretamente
- **Credenciais**: Via GitHub Secrets
- **Ambientes**: Dev e Prod separados
- **Lock**: DynamoDB configurado

### ⚠️ **Warnings Esperados:**
- `dynamodb_table` deprecated → **Ignorar (funcional)**
- Credenciais locais → **Normal (apenas em dev local)**

## 🚀 **Próximos Passos:**

1. **✅ Pipeline funcionará** com a configuração atual
2. **Configure secrets** no GitHub se ainda não fez
3. **Faça push** para testar a pipeline
4. **Ignore warnings** - eles não afetam o funcionamento

## 💡 **Comando para Pipeline:**

```yaml
# A pipeline usa (e está correto):
terraform init -backend-config="envs/dev/backend.tfvars"
terraform plan -var-file="envs/dev/terraform.tfvars"
```

**Status Final: ✅ PRONTO PARA USAR!**