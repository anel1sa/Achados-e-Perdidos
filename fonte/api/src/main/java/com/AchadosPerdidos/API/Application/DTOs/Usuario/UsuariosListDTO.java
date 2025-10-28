package com.AchadosPerdidos.API.Application.DTOs.Usuario;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de usuários")
public class UsuariosListDTO {
    
    @Schema(description = "Lista de usuários")
    private List<UsuariosDTO> usuarios;
    
    @Schema(description = "Total de usuários na lista")
    private int totalCount;

    // Getters e Setters
    public List<UsuariosDTO> getUsuarios() { return usuarios; }
    public void setUsuarios(List<UsuariosDTO> usuarios) { this.usuarios = usuarios; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}