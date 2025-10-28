package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Instituicao {
    private int Id_Instituicao;
    private String Tipo_Instituicao;
    private String Nome_Instituicao;
    private String CNPJ_Filial;
    private Boolean Flg_Inativo;
    private LocalDateTime Data_Cadastro;

    // Getters e Setters
    public int getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(int id_Instituicao) { Id_Instituicao = id_Instituicao; }

    public String getTipo_Instituicao() { return Tipo_Instituicao; }
    public void setTipo_Instituicao(String tipo_Instituicao) { Tipo_Instituicao = tipo_Instituicao; }

    public String getNome_Instituicao() { return Nome_Instituicao; }
    public void setNome_Instituicao(String nome_Instituicao) { Nome_Instituicao = nome_Instituicao; }

    public String getCNPJ_Filial() { return CNPJ_Filial; }
    public void setCNPJ_Filial(String CNPJ_Filial) { this.CNPJ_Filial = CNPJ_Filial; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }
}