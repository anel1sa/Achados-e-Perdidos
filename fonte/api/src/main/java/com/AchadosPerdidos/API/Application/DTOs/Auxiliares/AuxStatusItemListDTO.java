package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de status de itens")
public class AuxStatusItemListDTO {
    
    @Schema(description = "Lista de status de itens")
    private List<AuxStatusItemDTO> statusItens;
    
    @Schema(description = "Total de status na lista")
    private int totalCount;

    // Getters e Setters
    public List<AuxStatusItemDTO> getStatusItens() { return statusItens; }
    public void setStatusItens(List<AuxStatusItemDTO> statusItens) { this.statusItens = statusItens; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
