package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Itens {
    private int Id_Item;
    private String Nome_Item;
    private String Descricao_Item;
    private LocalDateTime Data_Hora_Item;
    private Boolean Flg_Inativo;
    private LocalDateTime Data_Cadastro;
    private int Status_Item_Id;
    private int Usuario_Id;
    private int Local_Id;
    private Integer Campus_Id;
    private Integer Id_Empresa;

    // Getters e Setters
    public int getId_Item() { return Id_Item; }
    public void setId_Item(int id_Item) { Id_Item = id_Item; }

    public String getNome_Item() { return Nome_Item; }
    public void setNome_Item(String nome_Item) { Nome_Item = nome_Item; }

    public String getDescricao_Item() { return Descricao_Item; }
    public void setDescricao_Item(String descricao_Item) { Descricao_Item = descricao_Item; }

    public LocalDateTime getData_Hora_Item() { return Data_Hora_Item; }
    public void setData_Hora_Item(LocalDateTime data_Hora_Item) { Data_Hora_Item = data_Hora_Item; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }

    public int getStatus_Item_Id() { return Status_Item_Id; }
    public void setStatus_Item_Id(int status_Item_Id) { Status_Item_Id = status_Item_Id; }

    public int getUsuario_Id() { return Usuario_Id; }
    public void setUsuario_Id(int usuario_Id) { Usuario_Id = usuario_Id; }

    public int getLocal_Id() { return Local_Id; }
    public void setLocal_Id(int local_Id) { Local_Id = local_Id; }

    public Integer getCampus_Id() { return Campus_Id; }
    public void setCampus_Id(Integer campus_Id) { Campus_Id = campus_Id; }

    public Integer getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(Integer id_Empresa) { Id_Empresa = id_Empresa; }
}