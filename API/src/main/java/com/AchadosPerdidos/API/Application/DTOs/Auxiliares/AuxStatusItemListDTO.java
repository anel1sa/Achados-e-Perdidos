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
@Schema(description = "DTO para lista de status de itens")
public class AuxStatusItemListDTO {
    
    @Schema(description = "Lista de status de itens")
    private List<AuxStatusItemDTO> statusItens;
    
    @Schema(description = "Total de status na lista")
    private int totalCount;
}
