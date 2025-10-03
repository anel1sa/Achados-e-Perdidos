# GitHub Actions - Achados e Perdidos

Pipeline de CI/CD para Flutter integrada com AWS.

## � Secrets Necessários

Configure no GitHub: **Settings** → **Secrets and variables** → **Actions**

### AWS (Obrigatório)
```
AWS_ACCESS_KEY_ID          # Chave de acesso
AWS_SECRET_ACCESS_KEY      # Chave secreta  
AWS_REGION                 # Região (ex: us-east-1)
AWS_S3_BUCKET             # Bucket para APKs
AWS_WEB_S3_BUCKET         # Bucket para web
```

### Android Signing (Para releases)
```
ANDROID_KEYSTORE_BASE64    # Keystore em base64
ANDROID_KEYSTORE_PASSWORD  # Senha do keystore
ANDROID_KEY_PASSWORD       # Senha da chave
ANDROID_KEY_ALIAS         # Alias da chave
```

## 🚀 Setup Rápido

### 1. AWS
```bash
# Criar buckets
aws s3 mb s3://seu-bucket-releases
aws s3 mb s3://seu-bucket-web

# Criar usuário IAM com política S3
# Ver AWS_SETUP.md para detalhes
```

### 2. Android Keystore
```bash
# Gerar keystore
keytool -genkey -v -keystore keystore.jks -alias key

# Converter para base64
base64 keystore.jks > keystore_base64.txt
```

## 📝 Pipelines

### 1. CI/CD Automático (`flutter-ci-cd.yml`)
- **Trigger**: Push para `main/develop` ou PR
- **Jobs**: Test → Build → Deploy para S3

### 2. Release Manual (`android-release.yml`) 
- **Trigger**: Manual via Actions
- **Gera**: APK/AAB assinados + GitHub Release

## 🎯 Como Usar

**Deploy automático**: Push para `main`

**Release manual**: 
1. Actions → Android Release Deploy
2. Run workflow
3. Preencher versão e notas

## 📁 Estrutura S3
```
releases/
├── achados-perdidos-latest.apk
├── android/v1.0.0/
│   ├── achados-perdidos-v1.0.0.apk
│   └── metadata.json
```

## ⚠️ Troubleshooting

- **AWS**: Verificar secrets e permissões IAM
- **Build**: Testar `flutter build apk` localmente
- **Keystore**: Confirmar senhas nos secrets