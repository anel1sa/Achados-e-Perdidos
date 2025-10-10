package com.AchadosPerdidos.API.Application.DTOs;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.util.Date;

@JsonPropertyOrder({
    "Id_Usuario",
    "Nome_Usuario",
    "CPF_Usuario",
    "Email_Usuario",
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
public class UsuariosListDTO {
    private Integer Id_Usuario;
    private String Nome_Usuario;
    private String CPF_Usuario;
    private String Email_Usuario;
    private String Matricula_Usuario;
    private String Telefone_Usuario;
    private int Tipo_Role_Id;
    private Integer foto_item_id;
    private Integer foto_perfil_usuario;
    private Boolean Flg_Inativo;
    private Integer Id_Instituicao;
    private Integer Id_Empresa;
    private Integer Id_Campus;
    private Date Data_Cadastro;

    @JsonProperty("Id_Usuario")
    public Integer getIdUsuario() { return Id_Usuario; }
    public void setIdUsuario(Integer idUsuario) { this.Id_Usuario = idUsuario; }

    @JsonProperty("Nome_Usuario")
    public String getNomeUsuario() { return Nome_Usuario; }
    public void setNomeUsuario(String nomeUsuario) { this.Nome_Usuario = nomeUsuario; }

    @JsonProperty("CPF_Usuario")
    public String getCpfUsuario() { return CPF_Usuario; }
    public void setCpfUsuario(String cpfUsuario) { this.CPF_Usuario = cpfUsuario; }

    @JsonProperty("Email_Usuario")
    public String getEmailUsuario() { return Email_Usuario; }
    public void setEmailUsuario(String emailUsuario) { this.Email_Usuario = emailUsuario; }

    @JsonProperty("Matricula_Usuario")
    public String getMatriculaUsuario() { return Matricula_Usuario; }
    public void setMatriculaUsuario(String matriculaUsuario) { this.Matricula_Usuario = matriculaUsuario; }

    @JsonProperty("Telefone_Usuario")
    public String getTelefoneUsuario() { return Telefone_Usuario; }
    public void setTelefoneUsuario(String telefoneUsuario) { this.Telefone_Usuario = telefoneUsuario; }

    @JsonProperty("Tipo_Role_Id")
    public int getTipoRoleId() { return Tipo_Role_Id; }
    public void setTipoRoleId(int tipoRoleId) { this.Tipo_Role_Id = tipoRoleId; }

    @JsonProperty("foto_item_id")
    public Integer getFotoId() { return foto_item_id; }
    public void setFotoId(Integer fotoId) { this.foto_item_id = fotoId; }

    @JsonProperty("foto_perfil_usuario")
    public Integer getFotoPerfilUsuario() { return foto_perfil_usuario; }
    public void setFotoPerfilUsuario(Integer fotoPerfilUsuario) { this.foto_perfil_usuario = fotoPerfilUsuario; }

    @JsonProperty("Flg_Inativo")
    public Boolean getFlgInativo() { return Flg_Inativo; }
    public void setFlgInativo(Boolean flgInativo) { this.Flg_Inativo = flgInativo; }

    @JsonProperty("Id_Instituicao")
    public Integer getInstituicaoPublicaId() { return Id_Instituicao; }
    public void setInstituicaoPublicaId(Integer instituicaoPublicaId) { this.Id_Instituicao = instituicaoPublicaId; }

    @JsonProperty("Id_Empresa")
    public Integer getInstituicaoPrivadaId() { return Id_Empresa; }
    public void setInstituicaoPrivadaId(Integer instituicaoPrivadaId) { this.Id_Empresa = instituicaoPrivadaId; }

    @JsonProperty("Id_Campus")
    public Integer getCampusId() { return Id_Campus; }
    public void setCampusId(Integer campusId) { this.Id_Campus = campusId; }

    @JsonProperty("Data_Cadastro")
    public Date getDataCadastro() { return Data_Cadastro; }
    public void setDataCadastro(Date dataCadastro) { this.Data_Cadastro = dataCadastro; }
}