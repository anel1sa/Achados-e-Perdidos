package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO para status de item")
public class AuxStatusItemDTO {
    
    @Schema(description = "ID único do status", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Status_Item;
    
    @Schema(description = "Descrição do status", example = "Ativo")
    private String Descricao_Status_Item;
}
