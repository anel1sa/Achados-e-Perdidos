package com.AchadosPerdidos.API.Application.DTOs.Role;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para criação de role")
public class RoleCreateDTO {
    
    @Schema(description = "Nome da role", example = "Admin", required = true)
    private String Nome;
    
    @Schema(description = "Descrição da role", example = "Administrador do sistema")
    private String Descricao;

    // Getters e Setters
    public String getNome() { return Nome; }
    public void setNome(String nome) { Nome = nome; }

    public String getDescricao() { return Descricao; }
    public void setDescricao(String descricao) { Descricao = descricao; }
}

