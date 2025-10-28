package com.AchadosPerdidos.API.Application.DTOs.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para criação de usuário")
public class UsuariosCreateDTO {
    
    @Schema(description = "Nome completo do usuário", example = "João Silva", required = true)
    private String Nome_Usuario;
    
    @Schema(description = "CPF do usuário", example = "12345678901", required = true)
    private String CPF_Usuario;
    
    @Schema(description = "Email do usuário", example = "joao@ifpr.edu.br", required = true)
    private String Email_Usuario;
    
    @Schema(description = "Senha do usuário", example = "senha123", required = true)
    private String Senha_Usuario;
    
    @Schema(description = "Matrícula do usuário", example = "2024001", required = true)
    private String Matricula_Usuario;
    
    @Schema(description = "Telefone do usuário", example = "(41) 99999-9999")
    private String Telefone_Usuario;
    
    @Schema(description = "Tipo de role do usuário (1=Admin, 2=Professor, 3=Aluno, 4=Instituição Pública, 5=Instituição Privada)", example = "2", required = true)
    private int Tipo_Role_Id;
    
    @Schema(description = "ID do campus do usuário", example = "1", required = true)
    private Integer Id_Campus;
    
    @Schema(description = "ID da empresa (opcional)", example = "null")
    private Integer Id_Empresa;

    // Getters e Setters
    public String getNome_Usuario() { return Nome_Usuario; }
    public void setNome_Usuario(String nome_Usuario) { Nome_Usuario = nome_Usuario; }

    public String getCPF_Usuario() { return CPF_Usuario; }
    public void setCPF_Usuario(String CPF_Usuario) { this.CPF_Usuario = CPF_Usuario; }

    public String getEmail_Usuario() { return Email_Usuario; }
    public void setEmail_Usuario(String email_Usuario) { Email_Usuario = email_Usuario; }

    public String getSenha_Usuario() { return Senha_Usuario; }
    public void setSenha_Usuario(String senha_Usuario) { Senha_Usuario = senha_Usuario; }

    public String getMatricula_Usuario() { return Matricula_Usuario; }
    public void setMatricula_Usuario(String matricula_Usuario) { Matricula_Usuario = matricula_Usuario; }

    public String getTelefone_Usuario() { return Telefone_Usuario; }
    public void setTelefone_Usuario(String telefone_Usuario) { Telefone_Usuario = telefone_Usuario; }

    public int getTipo_Role_Id() { return Tipo_Role_Id; }
    public void setTipo_Role_Id(int tipo_Role_Id) { Tipo_Role_Id = tipo_Role_Id; }

    public Integer getId_Campus() { return Id_Campus; }
    public void setId_Campus(Integer id_Campus) { Id_Campus = id_Campus; }

    public Integer getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(Integer id_Empresa) { Id_Empresa = id_Empresa; }
}