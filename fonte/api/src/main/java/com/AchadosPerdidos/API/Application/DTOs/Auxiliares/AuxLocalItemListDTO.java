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
@Schema(description = "DTO para lista de locais de itens")
public class AuxLocalItemListDTO {
    
    @Schema(description = "Lista de locais de itens")
    private List<AuxLocalItemDTO> locaisItens;
    
    @Schema(description = "Total de locais na lista")
    private int totalCount;
}
