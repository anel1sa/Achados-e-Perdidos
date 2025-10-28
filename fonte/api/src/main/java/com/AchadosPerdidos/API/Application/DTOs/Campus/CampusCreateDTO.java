package com.AchadosPerdidos.API.Application.DTOs.Campus;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para criação de campus")
public class CampusCreateDTO {
    
    @Schema(description = "Nome do campus", example = "IFPR - Sede Curitiba", required = true)
    private String Nome_Campus;
    
    @Schema(description = "Cidade onde o campus está localizado", example = "Curitiba", required = true)
    private String Cidade;
    
    @Schema(description = "Estado onde o campus está localizado", example = "Paraná", required = true)
    private String Estado;
    
    @Schema(description = "Endereço completo do campus", example = "Rua João Negrão, 1285 - Rebouças", required = true)
    private String Endereco;
    
    @Schema(description = "CEP do campus", example = "80230-150", required = true)
    private String CEP;
    
    @Schema(description = "ID da instituição à qual o campus pertence", example = "1", required = true)
    private int Id_Instituicao;

    // Getters e Setters
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

    public int getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(int id_Instituicao) { Id_Instituicao = id_Instituicao; }
}
