package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO para tipo de role")
public class AuxTipoRoleDTO {
    
    @Schema(description = "ID único do tipo de role", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Tipo_Role;
    
    @Schema(description = "Nome do tipo de role", example = "Admin")
    private String Nome_Tipo_Role;
}
