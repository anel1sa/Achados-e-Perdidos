package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Instituicao_Privada {
    private int Id_Instituicao_Privada;
    private String Nome_Instituicao_Privada;
    private String CNPJ_Instituicao_Privada;
    private Boolean Flg_Inativo;
    private LocalDateTime Data_Cadastro;

    // Getters e Setters
    public int getId_Instituicao_Privada() { return Id_Instituicao_Privada; }
    public void setId_Instituicao_Privada(int id_Instituicao_Privada) { Id_Instituicao_Privada = id_Instituicao_Privada; }

    public String getNome_Instituicao_Privada() { return Nome_Instituicao_Privada; }
    public void setNome_Instituicao_Privada(String nome_Instituicao_Privada) { Nome_Instituicao_Privada = nome_Instituicao_Privada; }

    public String getCNPJ_Instituicao_Privada() { return CNPJ_Instituicao_Privada; }
    public void setCNPJ_Instituicao_Privada(String CNPJ_Instituicao_Privada) { this.CNPJ_Instituicao_Privada = CNPJ_Instituicao_Privada; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }
}