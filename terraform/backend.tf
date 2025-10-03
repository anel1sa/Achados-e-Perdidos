terraform {
    required_version = ">= 1.3"
    
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    
    # Backend S3 para estado remoto
    # Configurado via arquivo backend.tfvars durante terraform init
    backend "s3" {}
}