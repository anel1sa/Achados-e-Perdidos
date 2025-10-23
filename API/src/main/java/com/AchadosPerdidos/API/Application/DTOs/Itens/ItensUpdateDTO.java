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
@Schema(description = "DTO para atualização de item")
public class ItensUpdateDTO {
    
    @Schema(description = "Nome do item", example = "Chave do Laboratório")
    private String Nome_Item;
    
    @Schema(description = "Descrição detalhada do item", example = "Chave do laboratório de informática, cor prata")
    private String Descricao_Item;
    
    @Schema(description = "Status ativo/inativo do item", example = "false")
    private Boolean Flg_Inativo;
    
    @Schema(description = "ID do status do item (1=Ativo, 2=Reivindicado, 3=Doado)", example = "1")
    private int Status_Item_Id;
    
    @Schema(description = "ID do local onde o item foi encontrado", example = "2")
    private int Local_Id;
    
    @Schema(description = "ID do campus onde o item foi encontrado", example = "1")
    private int Campus_Id;
}
