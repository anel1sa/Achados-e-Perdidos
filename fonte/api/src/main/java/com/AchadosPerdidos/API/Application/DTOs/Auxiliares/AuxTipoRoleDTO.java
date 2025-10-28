package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para tipo de role")
public class AuxTipoRoleDTO {
    
    @Schema(description = "ID único do tipo de role", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Tipo_Role;
    
    @Schema(description = "Nome do tipo de role", example = "Admin")
    private String Nome_Tipo_Role;

    // Getters e Setters
    public int getId_Tipo_Role() { return Id_Tipo_Role; }
    public void setId_Tipo_Role(int id_Tipo_Role) { Id_Tipo_Role = id_Tipo_Role; }

    public String getNome_Tipo_Role() { return Nome_Tipo_Role; }
    public void setNome_Tipo_Role(String nome_Tipo_Role) { Nome_Tipo_Role = nome_Tipo_Role; }
}