package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para status de item")
public class AuxStatusItemDTO {
    
    @Schema(description = "ID único do status", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Status_Item;
    
    @Schema(description = "Descrição do status", example = "Ativo")
    private String Descricao_Status_Item;

    // Getters e Setters
    public int getId_Status_Item() { return Id_Status_Item; }
    public void setId_Status_Item(int id_Status_Item) { Id_Status_Item = id_Status_Item; }

    public String getDescricao_Status_Item() { return Descricao_Status_Item; }
    public void setDescricao_Status_Item(String descricao_Status_Item) { Descricao_Status_Item = descricao_Status_Item; }
}