package com.AchadosPerdidos.API.Application.DTOs.Campus;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO completo de campus")
public class CampusDTO {
    
    @Schema(description = "ID único do campus", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Campus;
    
    @Schema(description = "Nome do campus", example = "IFPR - Sede Curitiba")
    private String Nome_Campus;
    
    @Schema(description = "Cidade onde o campus está localizado", example = "Curitiba")
    private String Cidade;
    
    @Schema(description = "Estado onde o campus está localizado", example = "Paraná")
    private String Estado;
    
    @Schema(description = "Endereço completo do campus", example = "Rua João Negrão, 1285 - Rebouças")
    private String Endereco;
    
    @Schema(description = "CEP do campus", example = "80230-150")
    private String CEP;
    
    @Schema(description = "Status ativo/inativo do campus", example = "true")
    private Boolean Flg_Ativo;
    
    @Schema(description = "ID da instituição à qual o campus pertence", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Instituicao;

    // Getters e Setters
    public int getId_Campus() { return Id_Campus; }
    public void setId_Campus(int id_Campus) { Id_Campus = id_Campus; }

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

    public Boolean getFlg_Ativo() { return Flg_Ativo; }
    public void setFlg_Ativo(Boolean flg_Ativo) { Flg_Ativo = flg_Ativo; }

    public int getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(int id_Instituicao) { Id_Instituicao = id_Instituicao; }
}