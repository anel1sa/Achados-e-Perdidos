package com.AchadosPerdidos.API.Application.DTOs.Instituicao;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO completo de instituição")
public class InstituicaoDTO {
    
    @Schema(description = "ID único da instituição", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Instituicao;
    
    @Schema(description = "Tipo da instituição (PUBLICA ou PRIVADA)", example = "PUBLICA")
    private String Tipo_Instituicao;
    
    @Schema(description = "Nome da instituição", example = "Instituto Federal do Paraná")
    private String Nome_Instituicao;
    
    @Schema(description = "CNPJ da instituição", example = "12345678000195")
    private String CNPJ_Filial;
}
