package com.AchadosPerdidos.API.Application.DTOs.Itens;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO para criação de item")
public class ItensCreateDTO {
    
    @Schema(description = "Nome do item", example = "Chave do Laboratório", required = true)
    private String Nome_Item;
    
    @Schema(description = "Descrição detalhada do item", example = "Chave do laboratório de informática, cor prata", required = true)
    private String Descricao_Item;
    
    @Schema(description = "ID do status do item (1=Ativo, 2=Reivindicado, 3=Doado)", example = "1", required = true)
    private int Status_Item_Id;
    
    @Schema(description = "ID do local onde o item foi encontrado", example = "2", required = true)
    private int Local_Id;
    
    @Schema(description = "ID do campus onde o item foi encontrado", example = "1", required = true)
    private int Campus_Id;
}
