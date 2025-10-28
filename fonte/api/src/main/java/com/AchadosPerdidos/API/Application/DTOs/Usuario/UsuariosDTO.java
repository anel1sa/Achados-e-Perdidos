package com.AchadosPerdidos.API.Application.DTOs.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "DTO completo de usuário")
public class UsuariosDTO {
    
    @Schema(description = "ID único do usuário", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Usuario;
    
    @Schema(description = "Nome completo do usuário", example = "João Silva")
    private String Nome_Usuario;
    
    @Schema(description = "CPF do usuário", example = "12345678901")
    private String CPF_Usuario;
    
    @Schema(description = "Email do usuário", example = "joao@ifpr.edu.br")
    private String Email_Usuario;
    
    @Schema(description = "Senha do usuário", example = "senha123", accessMode = Schema.AccessMode.WRITE_ONLY)
    private String Senha_Usuario;
    
    @Schema(description = "Matrícula do usuário", example = "2024001")
    private String Matricula_Usuario;
    
    @Schema(description = "Telefone do usuário", example = "(41) 99999-9999")
    private String Telefone_Usuario;
    
    @Schema(description = "Data de cadastro do usuário", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Data_Cadastro;
    
    @Schema(description = "Tipo de role do usuário (1=Admin, 2=Professor, 3=Aluno, 4=Instituição Pública, 5=Instituição Privada)", example = "2")
    private int Tipo_Role_Id;
    
    @Schema(description = "ID da foto do item", example = "null", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer foto_item_id;
    
    @Schema(description = "ID da foto de perfil", example = "null", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer foto_perfil_usuario;
    
    @Schema(description = "Status ativo/inativo do usuário", example = "false")
    private Boolean Flg_Inativo;
    
    @Schema(description = "ID da instituição", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Id_Instituicao;
    
    @Schema(description = "ID da empresa", example = "null", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Id_Empresa;
    
    @Schema(description = "ID do campus", example = "1")
    private Integer Id_Campus;

    // Getters e Setters
    public int getId_Usuario() { return Id_Usuario; }
    public void setId_Usuario(int id_Usuario) { Id_Usuario = id_Usuario; }

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

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }

    public int getTipo_Role_Id() { return Tipo_Role_Id; }
    public void setTipo_Role_Id(int tipo_Role_Id) { Tipo_Role_Id = tipo_Role_Id; }

    public Integer getFoto_item_id() { return foto_item_id; }
    public void setFoto_item_id(Integer foto_item_id) { this.foto_item_id = foto_item_id; }

    public Integer getFoto_perfil_usuario() { return foto_perfil_usuario; }
    public void setFoto_perfil_usuario(Integer foto_perfil_usuario) { this.foto_perfil_usuario = foto_perfil_usuario; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public Integer getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(Integer id_Instituicao) { Id_Instituicao = id_Instituicao; }

    public Integer getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(Integer id_Empresa) { Id_Empresa = id_Empresa; }

    public Integer getId_Campus() { return Id_Campus; }
    public void setId_Campus(Integer id_Campus) { Id_Campus = id_Campus; }
}