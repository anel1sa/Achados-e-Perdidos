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
    @Schema(description = "Nome completo", example = "João Silva", required = true)
    private String nomeCompleto;

    @Schema(description = "CPF", example = "12345678901", required = true)
    private String cpf;

    @Schema(description = "Email", example = "joao@ifpr.edu.br", required = true)
    private String email;

    @Schema(description = "Senha em texto plano (será hasheada)", example = "senha123", required = true)
    private String senha;

    @Schema(description = "Matrícula", example = "2024001")
    private String matricula;

    @Schema(description = "Telefone", example = "(41) 99999-9999")
    private String numeroTelefone;

    @Schema(description = "Empresa ID", example = "10")
    private Integer empresaId;

    @Schema(description = "Endereço ID", example = "5")
    private Integer enderecoId;
}