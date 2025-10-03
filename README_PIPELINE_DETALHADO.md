# 🚀 Pipeline CI/CD - Achados e Perdidos

Esta pipeline automatiza todo o processo de build, teste e deploy da aplicação Achados e Perdidos, incluindo o frontend Flutter, backend Java Spring Boot e infraestrutura AWS via Terraform.

## 📋 Estágios da Pipeline

### 1. 🔧 Build Frontend Flutter
- **Trigger**: Push ou PR para `main` ou `dev`
- **Ações**:
  - Setup do Flutter (versão 3.24.3)
  - Análise estática do código (`flutter analyze`)
  - Execução de testes (`flutter test`)
  - Build para Web (`flutter build web`)
  - Build para Android APK (`flutter build apk`)
  - Upload dos artefatos

### 2. ☕ Build Backend Java Spring Boot
- **Trigger**: Push ou PR para `main` ou `dev`
- **Ações**:
  - Setup do Java 21
  - Detecção automática da estrutura do projeto (Maven/Gradle)
  - Compilação e execução de testes
  - Geração do JAR executável
  - Upload dos artefatos

### 3. 📋 Terraform Plan
- **Trigger**: PR ou push para branches que não sejam `main`
- **Ações**:
  - Autenticação AWS via secrets
  - Inicialização do Terraform com backend remoto
  - Validação da configuração
  - Geração do plano de execução
  - Upload do plano como artefato

### 4. 🚀 Terraform Apply
- **Trigger**: Push para `main` (apenas produção)
- **Ações**:
  - Requer aprovação manual via GitHub Environment
  - Aplicação do plano Terraform
  - Criação/atualização da infraestrutura AWS

### 5. 🔄 Deploy Automático (Dev)
- **Trigger**: Push para branch `dev`
- **Ações**:
  - Deploy automático no ambiente de desenvolvimento
  - Sincronização do frontend com S3
  - Aplicação das mudanças de infraestrutura

## 🔐 Configuração de Secrets

Configure os seguintes secrets no GitHub:

```bash
# AWS Credentials
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=abc123...

# Outros secrets opcionais
DOCKER_USERNAME=seu_usuario
DOCKER_PASSWORD=sua_senha
```

## 🌍 Ambientes

### Desenvolvimento (`dev`)
- **Branch**: `dev`
- **Deploy**: Automático
- **URL**: Definida após deploy
- **Recursos**: Mínimos para testes

### Produção (`prd`)
- **Branch**: `main`
- **Deploy**: Manual com aprovação
- **URL**: Definida após deploy
- **Recursos**: Configuração completa

## 📁 Estrutura de Arquivos

```
.github/workflows/
  └── terraform.yml          # Pipeline principal

terraform/
  ├── backend.tf             # Configuração do backend remoto
  ├── provider.tf            # Provider AWS
  ├── variables.tf           # Definição de variáveis
  ├── s3-bucket.tf          # Recursos S3
  ├── outputs.tf            # Outputs dos recursos
  └── envs/
      ├── dev/
      │   ├── backend.tfvars    # Config backend dev
      │   └── terraform.tfvars  # Variáveis dev
      └── prd/
          ├── backend.tfvars    # Config backend prd
          └── terraform.tfvars  # Variáveis prd
```

## 🔧 Como Usar

### Para Desenvolvimento
1. Faça suas alterações em uma branch feature
2. Abra PR para `dev`
3. A pipeline executa automaticamente build e testes
4. Após merge para `dev`, deploy automático acontece

### Para Produção
1. Faça PR de `dev` para `main`
2. Revise o Terraform Plan nos checks do PR
3. Após merge para `main`, aprove manualmente o deploy
4. Pipeline aplica as mudanças em produção

## 🏗️ Recursos AWS Criados

- **S3 Buckets**:
  - `{projeto}-{env}-images-bucket`: Armazenamento de imagens
  - `{projeto}-{env}-frontend`: Hospedagem do frontend Flutter
- **S3 Website Configuration**: Frontend acessível via HTTP
- **IAM Policies**: Acesso público ao frontend

## 🔍 Monitoramento

- **GitHub Actions**: Logs detalhados de cada execução
- **AWS CloudTrail**: Auditoria das mudanças na infraestrutura
- **Terraform State**: Estado remoto armazenado no S3

## 🆘 Troubleshooting

### Falha na Autenticação AWS
- Verifique se os secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` estão configurados
- Confirme se as credenciais têm as permissões necessárias

### Erro no Terraform Plan
- Verifique se os arquivos `.tfvars` estão corretos
- Confirme se o backend S3 existe e está acessível

### Falha no Build Flutter
- Verifique se o código Flutter está válido
- Confirme se todas as dependências estão no `pubspec.yaml`

### Falha no Build Java
- Verifique se o projeto Java está na estrutura esperada
- Confirme se os testes estão passando localmente

## 📈 Próximos Passos

- [ ] Adicionar testes de integração
- [ ] Implementar notificações no Slack/Discord
- [ ] Adicionar análise de qualidade de código (SonarQube)
- [ ] Implementar rollback automático em caso de falha
- [ ] Adicionar métricas e monitoramento (CloudWatch)