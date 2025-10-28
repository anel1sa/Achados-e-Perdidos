package com.AchadosPerdidos.API.Application.DTOs.Itens;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de itens")
public class ItensListDTO {
    
    @Schema(description = "Lista de itens")
    private List<ItensDTO> itens;
    
    @Schema(description = "Total de itens na lista")
    private int totalCount;

    // Getters e Setters
    public List<ItensDTO> getItens() { return itens; }
    public void setItens(List<ItensDTO> itens) { this.itens = itens; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
