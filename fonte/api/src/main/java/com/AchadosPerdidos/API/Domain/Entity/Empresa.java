package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Empresa {
    private int Id_Empresa;
    private String Nome_Empresa;
    private String CNPJ_Matriz;
    private String Pais_Sede;
    private String Website;
    private String Contato_Principal;
    private Boolean Flg_Ativo;
    private LocalDateTime Data_Cadastro;

    // Getters e Setters
    public int getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(int id_Empresa) { Id_Empresa = id_Empresa; }

    public String getNome_Empresa() { return Nome_Empresa; }
    public void setNome_Empresa(String nome_Empresa) { Nome_Empresa = nome_Empresa; }

    public String getCNPJ_Matriz() { return CNPJ_Matriz; }
    public void setCNPJ_Matriz(String CNPJ_Matriz) { this.CNPJ_Matriz = CNPJ_Matriz; }

    public String getPais_Sede() { return Pais_Sede; }
    public void setPais_Sede(String pais_Sede) { Pais_Sede = pais_Sede; }

    public String getWebsite() { return Website; }
    public void setWebsite(String website) { Website = website; }

    public String getContato_Principal() { return Contato_Principal; }
    public void setContato_Principal(String contato_Principal) { Contato_Principal = contato_Principal; }

    public Boolean getFlg_Ativo() { return Flg_Ativo; }
    public void setFlg_Ativo(Boolean flg_Ativo) { Flg_Ativo = flg_Ativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }
}