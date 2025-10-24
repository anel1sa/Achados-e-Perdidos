package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO para lista de tipos de role")
public class AuxTipoRoleListDTO {
    
    @Schema(description = "Lista de tipos de role")
    private List<AuxTipoRoleDTO> tiposRole;
    
    @Schema(description = "Total de tipos de role na lista")
    private int totalCount;
}
