package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Instituicao_Publica {
    private int Id_Instituicao_Publica;
    private String Nome_Instituicao_Publica;
    private String CNPJ_Instituicao_Publica;
    private Boolean Flg_Inativo;
    private LocalDateTime Data_Cadastro;

    // Getters e Setters
    public int getId_Instituicao_Publica() { return Id_Instituicao_Publica; }
    public void setId_Instituicao_Publica(int id_Instituicao_Publica) { Id_Instituicao_Publica = id_Instituicao_Publica; }

    public String getNome_Instituicao_Publica() { return Nome_Instituicao_Publica; }
    public void setNome_Instituicao_Publica(String nome_Instituicao_Publica) { Nome_Instituicao_Publica = nome_Instituicao_Publica; }

    public String getCNPJ_Instituicao_Publica() { return CNPJ_Instituicao_Publica; }
    public void setCNPJ_Instituicao_Publica(String CNPJ_Instituicao_Publica) { this.CNPJ_Instituicao_Publica = CNPJ_Instituicao_Publica; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }
}