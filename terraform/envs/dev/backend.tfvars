bucket = "state-us-east-1-github-aep"
key    = "dev/terraform.tfstate"
region = "us-east-1"
encrypt = true
dynamodb_table = "state-us-east-1-github-aep"

# Configurações adicionais para evitar warnings
skip_credentials_validation = false
skip_metadata_api_check     = false
skip_region_validation      = false