package com.AchadosPerdidos.API.Application.DTOs.Role;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para atualização de role")
public class RoleUpdateDTO {
    
    @Schema(description = "Nome da role", example = "Admin")
    private String Nome;
    
    @Schema(description = "Descrição da role", example = "Administrador do sistema")
    private String Descricao;
    
    @Schema(description = "Flag indicando se está inativo", example = "false")
    private Boolean Flg_Inativo;

    // Getters e Setters
    public String getNome() { return Nome; }
    public void setNome(String nome) { Nome = nome; }

    public String getDescricao() { return Descricao; }
    public void setDescricao(String descricao) { Descricao = descricao; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }
}

