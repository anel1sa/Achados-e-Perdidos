package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Aux_Local_Item {
    private int Id_Aux_Local_Item;
    private String Nome_Local_Item;
    private String Descricao_Local_Item;
    private LocalDateTime Data_Cadastro_Local_Item;
    private Boolean Flg_Inativo_Local_Item;

    // Getters e Setters
    public int getId_Aux_Local_Item() { return Id_Aux_Local_Item; }
    public void setId_Aux_Local_Item(int id_Aux_Local_Item) { Id_Aux_Local_Item = id_Aux_Local_Item; }

    public String getNome_Local_Item() { return Nome_Local_Item; }
    public void setNome_Local_Item(String nome_Local_Item) { Nome_Local_Item = nome_Local_Item; }

    public String getDescricao_Local_Item() { return Descricao_Local_Item; }
    public void setDescricao_Local_Item(String descricao_Local_Item) { Descricao_Local_Item = descricao_Local_Item; }

    public LocalDateTime getData_Cadastro_Local_Item() { return Data_Cadastro_Local_Item; }
    public void setData_Cadastro_Local_Item(LocalDateTime data_Cadastro_Local_Item) { Data_Cadastro_Local_Item = data_Cadastro_Local_Item; }

    public Boolean getFlg_Inativo_Local_Item() { return Flg_Inativo_Local_Item; }
    public void setFlg_Inativo_Local_Item(Boolean flg_Inativo_Local_Item) { Flg_Inativo_Local_Item = flg_Inativo_Local_Item; }
}