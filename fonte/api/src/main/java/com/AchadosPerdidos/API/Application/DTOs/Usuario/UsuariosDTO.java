package com.AchadosPerdidos.API.Application.DTOs.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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
    private Date Data_Cadastro;
    
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
}