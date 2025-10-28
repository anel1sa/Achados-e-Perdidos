package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Campus {
    private int Id_Campus;
    private Integer Id_Instituicao;
    private String Nome_Campus;
    private String Cidade;
    private String Estado;
    private String Endereco;
    private String CEP;
    private Double Latitude;
    private Double Longitude;
    private Boolean Flg_Ativo;
    private LocalDateTime Data_Cadastro;

    // Getters e Setters
    public int getId_Campus() { return Id_Campus; }
    public void setId_Campus(int id_Campus) { Id_Campus = id_Campus; }

    public Integer getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(Integer id_Instituicao) { Id_Instituicao = id_Instituicao; }

    public String getNome_Campus() { return Nome_Campus; }
    public void setNome_Campus(String nome_Campus) { Nome_Campus = nome_Campus; }

    public String getCidade() { return Cidade; }
    public void setCidade(String cidade) { Cidade = cidade; }

    public String getEstado() { return Estado; }
    public void setEstado(String estado) { Estado = estado; }

    public String getEndereco() { return Endereco; }
    public void setEndereco(String endereco) { Endereco = endereco; }

    public String getCEP() { return CEP; }
    public void setCEP(String CEP) { this.CEP = CEP; }

    public Double getLatitude() { return Latitude; }
    public void setLatitude(Double latitude) { Latitude = latitude; }

    public Double getLongitude() { return Longitude; }
    public void setLongitude(Double longitude) { Longitude = longitude; }

    public Boolean getFlg_Ativo() { return Flg_Ativo; }
    public void setFlg_Ativo(Boolean flg_Ativo) { Flg_Ativo = flg_Ativo; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }
}