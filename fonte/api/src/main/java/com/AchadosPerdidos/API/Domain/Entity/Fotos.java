package com.AchadosPerdidos.API.Domain.Entity;

import com.AchadosPerdidos.API.Domain.Enum.Provedor_Armazenamento;

import java.time.LocalDateTime;

public class Fotos {
    private int Id_Foto;
    private Integer Usuario_Id;
    private Integer Item_Id;
    private Provedor_Armazenamento Provedor_Armazenamento;
    private String Nome_Bucket;
    private String Chave_Objeto;
    private String Chave_Armazenamento;
    private String Url_Arquivo;
    private String Nome_Original;
    private Long Tamanho_Bytes;
    private Integer Largura;
    private Integer Altura;
    private Boolean Perfil_Usuario;
    private Boolean Foto_Item;
    private Boolean Flg_Inativo;
    private LocalDateTime Data_Envio;
    private LocalDateTime Data_Exclusao;
    private LocalDateTime Data_Atualizacao;

    // Getters e Setters
    public int getId_Foto() { return Id_Foto; }
    public void setId_Foto(int id_Foto) { Id_Foto = id_Foto; }

    public Integer getUsuario_Id() { return Usuario_Id; }
    public void setUsuario_Id(Integer usuario_Id) { Usuario_Id = usuario_Id; }

    public Integer getItem_Id() { return Item_Id; }
    public void setItem_Id(Integer item_Id) { Item_Id = item_Id; }

    public Provedor_Armazenamento getProvedor_Armazenamento() { return Provedor_Armazenamento; }
    public void setProvedor_Armazenamento(Provedor_Armazenamento provedor_Armazenamento) { Provedor_Armazenamento = provedor_Armazenamento; }

    public String getNome_Bucket() { return Nome_Bucket; }
    public void setNome_Bucket(String nome_Bucket) { Nome_Bucket = nome_Bucket; }

    public String getChave_Objeto() { return Chave_Objeto; }
    public void setChave_Objeto(String chave_Objeto) { Chave_Objeto = chave_Objeto; }

    public String getChave_Armazenamento() { return Chave_Armazenamento; }
    public void setChave_Armazenamento(String chave_Armazenamento) { Chave_Armazenamento = chave_Armazenamento; }

    public String getUrl_Arquivo() { return Url_Arquivo; }
    public void setUrl_Arquivo(String url_Arquivo) { Url_Arquivo = url_Arquivo; }

    public String getNome_Original() { return Nome_Original; }
    public void setNome_Original(String nome_Original) { Nome_Original = nome_Original; }

    public Long getTamanho_Bytes() { return Tamanho_Bytes; }
    public void setTamanho_Bytes(Long tamanho_Bytes) { Tamanho_Bytes = tamanho_Bytes; }

    public Integer getLargura() { return Largura; }
    public void setLargura(Integer largura) { Largura = largura; }

    public Integer getAltura() { return Altura; }
    public void setAltura(Integer altura) { Altura = altura; }

    public Boolean getPerfil_Usuario() { return Perfil_Usuario; }
    public void setPerfil_Usuario(Boolean perfil_Usuario) { Perfil_Usuario = perfil_Usuario; }

    public Boolean getFoto_Item() { return Foto_Item; }
    public void setFoto_Item(Boolean foto_Item) { Foto_Item = foto_Item; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public LocalDateTime getData_Envio() { return Data_Envio; }
    public void setData_Envio(LocalDateTime data_Envio) { Data_Envio = data_Envio; }

    public LocalDateTime getData_Exclusao() { return Data_Exclusao; }
    public void setData_Exclusao(LocalDateTime data_Exclusao) { Data_Exclusao = data_Exclusao; }

    public LocalDateTime getData_Atualizacao() { return Data_Atualizacao; }
    public void setData_Atualizacao(LocalDateTime data_Atualizacao) { Data_Atualizacao = data_Atualizacao; }
}