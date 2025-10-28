package com.AchadosPerdidos.API.Application.DTOs.Empresa;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO completo de empresa")
public class EmpresaDTO {
    
    @Schema(description = "ID único da empresa", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Empresa;
    
    @Schema(description = "Nome da empresa", example = "Empresa ABC Ltda")
    private String Nome_Empresa;
    
    @Schema(description = "CNPJ da empresa", example = "12345678000195")
    private String CNPJ_Empresa;
    
    @Schema(description = "Endereço da empresa", example = "Rua das Empresas, 123")
    private String Endereco_Empresa;
    
    @Schema(description = "Telefone da empresa", example = "(41) 3333-3333")
    private String Telefone_Empresa;
    
    @Schema(description = "Email da empresa", example = "contato@empresa.com")
    private String Email_Empresa;
    
    @Schema(description = "Status ativo/inativo da empresa", example = "true")
    private Boolean Flg_Ativo;

    // Getters e Setters
    public int getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(int id_Empresa) { Id_Empresa = id_Empresa; }

    public String getNome_Empresa() { return Nome_Empresa; }
    public void setNome_Empresa(String nome_Empresa) { Nome_Empresa = nome_Empresa; }

    public String getCNPJ_Empresa() { return CNPJ_Empresa; }
    public void setCNPJ_Empresa(String CNPJ_Empresa) { this.CNPJ_Empresa = CNPJ_Empresa; }

    public String getEndereco_Empresa() { return Endereco_Empresa; }
    public void setEndereco_Empresa(String endereco_Empresa) { Endereco_Empresa = endereco_Empresa; }

    public String getTelefone_Empresa() { return Telefone_Empresa; }
    public void setTelefone_Empresa(String telefone_Empresa) { Telefone_Empresa = telefone_Empresa; }

    public String getEmail_Empresa() { return Email_Empresa; }
    public void setEmail_Empresa(String email_Empresa) { Email_Empresa = email_Empresa; }

    public Boolean getFlg_Ativo() { return Flg_Ativo; }
    public void setFlg_Ativo(Boolean flg_Ativo) { Flg_Ativo = flg_Ativo; }
}
