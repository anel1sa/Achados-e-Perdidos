package com.AchadosPerdidos.API.Application.DTOs.Campus;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO para criação de campus")
public class CampusCreateDTO {
    
    @Schema(description = "Nome do campus", example = "IFPR - Sede Curitiba", required = true)
    private String Nome_Campus;
    
    @Schema(description = "Cidade onde o campus está localizado", example = "Curitiba", required = true)
    private String Cidade;
    
    @Schema(description = "Estado onde o campus está localizado", example = "Paraná", required = true)
    private String Estado;
    
    @Schema(description = "Endereço completo do campus", example = "Rua João Negrão, 1285 - Rebouças", required = true)
    private String Endereco;
    
    @Schema(description = "CEP do campus", example = "80230-150", required = true)
    private String CEP;
    
    @Schema(description = "ID da instituição à qual o campus pertence", example = "1", required = true)
    private int Id_Instituicao;
}
