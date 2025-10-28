package com.AchadosPerdidos.API.Application.DTOs.Itens;

import io.swagger.v3.oas.annotations.media.Schema;

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

    // Getters e Setters
    public String getNome_Item() { return Nome_Item; }
    public void setNome_Item(String nome_Item) { Nome_Item = nome_Item; }

    public String getDescricao_Item() { return Descricao_Item; }
    public void setDescricao_Item(String descricao_Item) { Descricao_Item = descricao_Item; }

    public int getStatus_Item_Id() { return Status_Item_Id; }
    public void setStatus_Item_Id(int status_Item_Id) { Status_Item_Id = status_Item_Id; }

    public int getLocal_Id() { return Local_Id; }
    public void setLocal_Id(int local_Id) { Local_Id = local_Id; }

    public int getCampus_Id() { return Campus_Id; }
    public void setCampus_Id(int campus_Id) { Campus_Id = campus_Id; }
}
