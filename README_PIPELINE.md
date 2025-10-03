# Pipeline GitHub Actions - Quick Start

## ⚡ Setup em 5 minutos

### 1. Configure AWS
```bash
# Criar buckets
aws s3 mb s3://seu-bucket-releases
aws s3 mb s3://seu-bucket-web

# Criar usuário IAM com permissões S3
# Ver AWS_SETUP.md para comandos completos
```

### 2. Secrets GitHub
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY  
AWS_REGION
AWS_S3_BUCKET
AWS_WEB_S3_BUCKET
```

### 3. Android Signing (opcional)
```bash
keytool -genkey -v -keystore key.jks -alias key
base64 key.jks > key_base64.txt
```

Adicionar aos secrets:
```
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_PASSWORD
ANDROID_KEY_ALIAS
```

## 🎯 Como Usar

**Deploy automático**: Push para `main`

**Release manual**: Actions → Android Release Deploy

## ⚠️ Problemas Comuns

- **AWS auth**: Verificar secrets
- **Build falha**: Testar `flutter build apk` local
- **Keystore**: Confirmar senhas

📚 Docs completas: `GITHUB_ACTIONS_SETUP.md` e `AWS_SETUP.md`