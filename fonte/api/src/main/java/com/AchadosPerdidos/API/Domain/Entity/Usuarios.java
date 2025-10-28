package com.AchadosPerdidos.API.Domain.Entity;

import java.time.LocalDateTime;

public class Usuarios {
    private int Id_Usuario;
    private String Nome_Usuario;
    private String CPF_Usuario;
    private String Email_Usuario;
    private String Senha_Usuario;
    private String Matricula_Usuario;
    private String Telefone_Usuario;
    private LocalDateTime Data_Cadastro;
    private int Tipo_Role_Id;
    private Boolean Flg_Inativo;
    private Integer foto_item_id;
    private Integer foto_perfil_usuario;
    private Integer Id_Instituicao;
    private Integer Id_Empresa;
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

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public Integer getFoto_item_id() { return foto_item_id; }
    public void setFoto_item_id(Integer foto_item_id) { this.foto_item_id = foto_item_id; }

    public Integer getFoto_perfil_usuario() { return foto_perfil_usuario; }
    public void setFoto_perfil_usuario(Integer foto_perfil_usuario) { this.foto_perfil_usuario = foto_perfil_usuario; }

    public Integer getId_Instituicao() { return Id_Instituicao; }
    public void setId_Instituicao(Integer id_Instituicao) { Id_Instituicao = id_Instituicao; }

    public Integer getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(Integer id_Empresa) { Id_Empresa = id_Empresa; }

    public Integer getId_Campus() { return Id_Campus; }
    public void setId_Campus(Integer id_Campus) { Id_Campus = id_Campus; }
}