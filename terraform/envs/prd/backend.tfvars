bucket = "state-sa-east-1-github-aep"
key    = "prd/terraform.tfstate"
region = "sa-east-1"
encrypt = true
dynamodb_table = "state-sa-east-1-github-aep"

# Configurações adicionais para evitar warnings
skip_credentials_validation = false
skip_metadata_api_check     = false
skip_region_validation      = false