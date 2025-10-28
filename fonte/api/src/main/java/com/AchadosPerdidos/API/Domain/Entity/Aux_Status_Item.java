package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Aux_Status_Item {
    private int Id_Status_Item;
    private String Descricao_Status_Item;
    private LocalDateTime Data_Cadastro;
    private Boolean Flg_Inativo;

    // Getters e Setters
    public int getId_Status_Item() { return Id_Status_Item; }
    public void setId_Status_Item(int id_Status_Item) { Id_Status_Item = id_Status_Item; }

    public String getDescricao_Status_Item() { return Descricao_Status_Item; }
    public void setDescricao_Status_Item(String descricao_Status_Item) { Descricao_Status_Item = descricao_Status_Item; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }
}