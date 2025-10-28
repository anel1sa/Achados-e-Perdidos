package com.AchadosPerdidos.API.Application.DTOs.Fotos;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO completo de foto")
public class FotosDTO {
    
    @Schema(description = "ID único da foto", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Foto;
    
    @Schema(description = "Nome do arquivo da foto", example = "foto_item_123.jpg")
    private String Nome_Arquivo;
    
    @Schema(description = "URL da foto no S3", example = "https://bucket.s3.amazonaws.com/fotos/foto_item_123.jpg")
    private String URL_Foto;
    
    @Schema(description = "Tamanho do arquivo em bytes", example = "1024000")
    private Long Tamanho_Arquivo;
    
    @Schema(description = "Tipo MIME da foto", example = "image/jpeg")
    private String Tipo_MIME;
    
    @Schema(description = "ID do item relacionado", example = "1")
    private Integer Id_Item;
    
    @Schema(description = "ID do usuário que fez upload", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Id_Usuario;

    // Getters e Setters
    public int getId_Foto() { return Id_Foto; }
    public void setId_Foto(int id_Foto) { Id_Foto = id_Foto; }

    public String getNome_Arquivo() { return Nome_Arquivo; }
    public void setNome_Arquivo(String nome_Arquivo) { Nome_Arquivo = nome_Arquivo; }

    public String getURL_Foto() { return URL_Foto; }
    public void setURL_Foto(String URL_Foto) { this.URL_Foto = URL_Foto; }

    public Long getTamanho_Arquivo() { return Tamanho_Arquivo; }
    public void setTamanho_Arquivo(Long tamanho_Arquivo) { Tamanho_Arquivo = tamanho_Arquivo; }

    public String getTipo_MIME() { return Tipo_MIME; }
    public void setTipo_MIME(String tipo_MIME) { Tipo_MIME = tipo_MIME; }

    public Integer getId_Item() { return Id_Item; }
    public void setId_Item(Integer id_Item) { Id_Item = id_Item; }

    public Integer getId_Usuario() { return Id_Usuario; }
    public void setId_Usuario(Integer id_Usuario) { Id_Usuario = id_Usuario; }
}
