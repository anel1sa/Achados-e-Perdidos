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
@Schema(description = "DTO para local de item")
public class AuxLocalItemDTO {
    
    @Schema(description = "ID único do local", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Aux_Local_Item;
    
    @Schema(description = "Nome do local", example = "Biblioteca")
    private String Nome_Local_Item;
    
    @Schema(description = "Descrição do local", example = "Biblioteca central do campus")
    private String Descricao_Local_Item;
}
