package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para local de item")
public class AuxLocalItemDTO {
    
    @Schema(description = "ID único do local", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Aux_Local_Item;
    
    @Schema(description = "Nome do local", example = "Biblioteca")
    private String Nome_Local_Item;
    
    @Schema(description = "Descrição do local", example = "Biblioteca central do campus")
    private String Descricao_Local_Item;

    // Getters e Setters
    public int getId_Aux_Local_Item() { return Id_Aux_Local_Item; }
    public void setId_Aux_Local_Item(int id_Aux_Local_Item) { Id_Aux_Local_Item = id_Aux_Local_Item; }

    public String getNome_Local_Item() { return Nome_Local_Item; }
    public void setNome_Local_Item(String nome_Local_Item) { Nome_Local_Item = nome_Local_Item; }

    public String getDescricao_Local_Item() { return Descricao_Local_Item; }
    public void setDescricao_Local_Item(String descricao_Local_Item) { Descricao_Local_Item = descricao_Local_Item; }
}