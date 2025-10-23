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
@Schema(description = "DTO completo de campus")
public class CampusDTO {
    
    @Schema(description = "ID único do campus", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Campus;
    
    @Schema(description = "Nome do campus", example = "IFPR - Sede Curitiba")
    private String Nome_Campus;
    
    @Schema(description = "Cidade onde o campus está localizado", example = "Curitiba")
    private String Cidade;
    
    @Schema(description = "Estado onde o campus está localizado", example = "Paraná")
    private String Estado;
    
    @Schema(description = "Endereço completo do campus", example = "Rua João Negrão, 1285 - Rebouças")
    private String Endereco;
    
    @Schema(description = "CEP do campus", example = "80230-150")
    private String CEP;
    
    @Schema(description = "Status ativo/inativo do campus", example = "true")
    private Boolean Flg_Ativo;
    
    @Schema(description = "ID da instituição à qual o campus pertence", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Instituicao;
}
