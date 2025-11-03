package com.AchadosPerdidos.API.Application.DTOs.StatusItem;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de status de itens")
public class StatusItemListDTO {
    
    @Schema(description = "Lista de status de itens")
    private List<StatusItemDTO> StatusItens;
    
    @Schema(description = "Total de status na lista")
    private int TotalCount;

    // Getters e Setters
    public List<StatusItemDTO> getStatusItens() { return StatusItens; }
    public void setStatusItens(List<StatusItemDTO> statusItens) { StatusItens = statusItens; }

    public int getTotalCount() { return TotalCount; }
    public void setTotalCount(int totalCount) { TotalCount = totalCount; }
}

