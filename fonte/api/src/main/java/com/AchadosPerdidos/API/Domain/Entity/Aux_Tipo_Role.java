package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Aux_Tipo_Role {
    private int Id_Tipo_Role;
    private String Nome_Tipo_Role;
    private LocalDateTime Data_Cadastro;
    private Boolean Flg_Inativo;

    // Getters e Setters
    public int getId_Tipo_Role() { return Id_Tipo_Role; }
    public void setId_Tipo_Role(int id_Tipo_Role) { Id_Tipo_Role = id_Tipo_Role; }

    public String getNome_Tipo_Role() { return Nome_Tipo_Role; }
    public void setNome_Tipo_Role(String nome_Tipo_Role) { Nome_Tipo_Role = nome_Tipo_Role; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }
}