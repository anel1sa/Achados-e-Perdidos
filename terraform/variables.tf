variable "region" {
    type        = string
    description = "AWS region para deploy dos recursos"
    default     = "sa-east-1"
}

variable "project_name" {
    type        = string
    description = "Nome do projeto"
    default     = "aep"
}

variable "env" {
    type        = string
    description = "Ambiente (dev, prd)"
    validation {
        condition     = contains(["dev", "prd"], var.env)
        error_message = "Environment deve ser 'dev' ou 'prd'."
    }
}

variable "tags" {
    type        = map(string)
    description = "Tags para aplicar aos recursos"
    default = {
        Project   = "achados-perdidos"
        ManagedBy = "terraform"
    }
}
