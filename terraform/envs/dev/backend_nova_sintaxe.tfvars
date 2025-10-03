# Versão atualizada sem warnings (opcional)
bucket = "state-sa-east-1-github-aep"
key    = "dev/terraform.tfstate"
region = "sa-east-1"
encrypt = true

# Nova sintaxe (Terraform >= 1.6)
use_lockfile = true

# Configurações adicionais
skip_credentials_validation = false
skip_metadata_api_check     = false
skip_region_validation      = false

# Nota: Com use_lockfile=true, o Terraform usa automaticamente
# uma tabela DynamoDB com nome baseado no bucket
# Padrão: {bucket}-lock