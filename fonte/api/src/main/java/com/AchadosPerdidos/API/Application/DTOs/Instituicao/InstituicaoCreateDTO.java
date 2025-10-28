package com.AchadosPerdidos.API.Application.DTOs.Instituicao;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para criação de instituição")
public class InstituicaoCreateDTO {
    
    @Schema(description = "Tipo da instituição (PUBLICA ou PRIVADA)", example = "PUBLICA", required = true)
    private String Tipo_Instituicao;
    
    @Schema(description = "Nome da instituição", example = "Instituto Federal do Paraná", required = true)
    private String Nome_Instituicao;
    
    @Schema(description = "CNPJ da instituição", example = "12345678000195", required = true)
    private String CNPJ_Filial;

    // Getters e Setters
    public String getTipo_Instituicao() { return Tipo_Instituicao; }
    public void setTipo_Instituicao(String tipo_Instituicao) { Tipo_Instituicao = tipo_Instituicao; }

    public String getNome_Instituicao() { return Nome_Instituicao; }
    public void setNome_Instituicao(String nome_Instituicao) { Nome_Instituicao = nome_Instituicao; }

    public String getCNPJ_Filial() { return CNPJ_Filial; }
    public void setCNPJ_Filial(String CNPJ_Filial) { this.CNPJ_Filial = CNPJ_Filial; }
}
