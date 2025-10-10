package com.AchadosPerdidos.API.Application.DTOs;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.util.Date;

@JsonPropertyOrder({
    "Id_Usuario",
    "Nome_Usuario",
    "CPF_Usuario",
    "Email_Usuario",
    "Senha_Usuario",
    "Matricula_Usuario",
    "Telefone_Usuario",
    "Tipo_Role_Id",
    "foto_item_id",
    "foto_perfil_usuario",
    "Flg_Inativo",
    "Id_Instituicao",
    "Id_Empresa",
    "Id_Campus",
    "Data_Cadastro"
})
public record UsuariosDTO(
    @JsonProperty(access = JsonProperty.Access.READ_ONLY) Integer Id_Usuario,
    @JsonProperty("Nome_Usuario") String Nome_Usuario,
    @JsonProperty("CPF_Usuario") String CPF_Usuario,
    @JsonProperty("Email_Usuario") String Email_Usuario,
    @JsonProperty("Senha_Usuario") String Senha_Usuario,
    @JsonProperty("Matricula_Usuario") String Matricula_Usuario,
    @JsonProperty("Telefone_Usuario") String Telefone_Usuario,
    @JsonProperty("Tipo_Role_Id") int Tipo_Role_Id,
    @JsonProperty("foto_item_id") Integer foto_item_id,
    @JsonProperty("foto_perfil_usuario") Integer foto_perfil_usuario,
    @JsonProperty("Flg_Inativo") Boolean Flg_Inativo,
    @JsonProperty("Id_Instituicao") Integer Id_Instituicao,
    @JsonProperty("Id_Empresa") Integer Id_Empresa,
    @JsonProperty("Id_Campus") Integer Id_Campus,
    @JsonProperty(access = JsonProperty.Access.READ_ONLY) Date Data_Cadastro
) {}