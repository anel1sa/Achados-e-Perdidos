package com.AchadosPerdidos.API.Domain.Entity;

import lombok.Data;
import java.util.Date;

@Data
public class Usuarios {
    private int Id_Usuario;
    private String Nome_Usuario;
    private String CPF_Usuario;
    private String Email_Usuario;
    private String Senha_Usuario;
    private String Matricula_Usuario;
    private String Telefone_Usuario;
    private Date Data_Cadastro;
    private int Tipo_Role_Id;
    private Boolean Flg_Inativo;
    private Integer foto_item_id;
    private Integer foto_perfil_usuario;
    private Integer Id_Instituicao;
    private Integer Id_Empresa;
    private Integer Id_Campus;
}