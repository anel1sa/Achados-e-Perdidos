package com.AchadosPerdidos.API.Application.DTOs.Empresa;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO completo de empresa")
public class EmpresaDTO {
    
    @Schema(description = "ID único da empresa", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Empresa;
    
    @Schema(description = "Nome da empresa", example = "Empresa ABC Ltda")
    private String Nome_Empresa;
    
    @Schema(description = "CNPJ da empresa", example = "12345678000195")
    private String CNPJ_Empresa;
    
    @Schema(description = "Endereço da empresa", example = "Rua das Empresas, 123")
    private String Endereco_Empresa;
    
    @Schema(description = "Telefone da empresa", example = "(41) 3333-3333")
    private String Telefone_Empresa;
    
    @Schema(description = "Email da empresa", example = "contato@empresa.com")
    private String Email_Empresa;
    
    @Schema(description = "Status ativo/inativo da empresa", example = "true")
    private Boolean Flg_Ativo;
}
