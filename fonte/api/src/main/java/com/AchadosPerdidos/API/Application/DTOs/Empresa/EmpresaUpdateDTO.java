package com.AchadosPerdidos.API.Application.DTOs.Empresa;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Schema(description = "DTO para atualização de empresa")
@Getter
@Setter
@AllArgsConstructor
public class EmpresaUpdateDTO {
    
    @Schema(description = "Nome da empresa", example = "Empresa ABC Ltda")
    private String Nome;
    
    @Schema(description = "Nome fantasia da empresa", example = "ABC")
    private String Nome_Fantasia;
    
    @Schema(description = "CNPJ da empresa", example = "12345678000195")
    private String Cnpj;
    
    @Schema(description = "ID do endereço da empresa", example = "1")
    private Integer Endereco_Id;
    
    @Schema(description = "Flag indicando se está inativo", example = "false")
    private Boolean Flg_Inativo;
}

