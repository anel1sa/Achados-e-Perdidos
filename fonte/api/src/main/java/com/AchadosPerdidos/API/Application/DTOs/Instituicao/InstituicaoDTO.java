package com.AchadosPerdidos.API.Application.DTOs.Instituicao;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO completo de instituição")
public class InstituicaoDTO {
    
    @Schema(description = "ID único da instituição", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Instituicao;
    
    @Schema(description = "Tipo da instituição (PUBLICA ou PRIVADA)", example = "PUBLICA")
    private String Tipo_Instituicao;
    
    @Schema(description = "Nome da instituição", example = "Instituto Federal do Paraná")
    private String Nome_Instituicao;
    
    @Schema(description = "CNPJ da instituição", example = "12345678000195")
    private String CNPJ_Filial;

    // Getters e Setters
    public int getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(int id_Instituicao) { Id_Instituicao = id_Instituicao; }

    public String getTipo_Instituicao() { return Tipo_Instituicao; }
    public void setTipo_Instituicao(String tipo_Instituicao) { Tipo_Instituicao = tipo_Instituicao; }

    public String getNome_Instituicao() { return Nome_Instituicao; }
    public void setNome_Instituicao(String nome_Instituicao) { Nome_Instituicao = nome_Instituicao; }

    public String getCNPJ_Filial() { return CNPJ_Filial; }
    public void setCNPJ_Filial(String CNPJ_Filial) { this.CNPJ_Filial = CNPJ_Filial; }
}
