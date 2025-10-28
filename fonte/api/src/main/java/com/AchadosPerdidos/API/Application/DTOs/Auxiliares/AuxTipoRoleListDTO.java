package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de tipos de role")
public class AuxTipoRoleListDTO {
    
    @Schema(description = "Lista de tipos de role")
    private List<AuxTipoRoleDTO> tiposRole;
    
    @Schema(description = "Total de tipos de role na lista")
    private int totalCount;

    // Getters e Setters
    public List<AuxTipoRoleDTO> getTiposRole() { return tiposRole; }
    public void setTiposRole(List<AuxTipoRoleDTO> tiposRole) { this.tiposRole = tiposRole; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
