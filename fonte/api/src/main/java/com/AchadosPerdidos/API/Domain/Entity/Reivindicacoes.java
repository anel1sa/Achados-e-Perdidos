package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Reivindicacoes {
    private int Id_Reivindicacao;
    private int Id_Item;
    private Integer Id_Usuario_Post;
    private Integer Id_Usuario_Proprietario;
    private LocalDateTime Data_Reivindicacao;
    private String Observacao;

    // Getters e Setters
    public int getId_Reivindicacao() { return Id_Reivindicacao; }
    public void setId_Reivindicacao(int id_Reivindicacao) { Id_Reivindicacao = id_Reivindicacao; }

    public int getId_Item() { return Id_Item; }
    public void setId_Item(int id_Item) { Id_Item = id_Item; }

    public Integer getId_Usuario_Post() { return Id_Usuario_Post; }
    public void setId_Usuario_Post(Integer id_Usuario_Post) { Id_Usuario_Post = id_Usuario_Post; }

    public Integer getId_Usuario_Proprietario() { return Id_Usuario_Proprietario; }
    public void setId_Usuario_Proprietario(Integer id_Usuario_Proprietario) { Id_Usuario_Proprietario = id_Usuario_Proprietario; }

    public LocalDateTime getData_Reivindicacao() { return Data_Reivindicacao; }
    public void setData_Reivindicacao(LocalDateTime data_Reivindicacao) { Data_Reivindicacao = data_Reivindicacao; }

    public String getObservacao() { return Observacao; }
    public void setObservacao(String observacao) { Observacao = observacao; }
}