package com.AchadosPerdidos.API.Application.DTOs.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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
}