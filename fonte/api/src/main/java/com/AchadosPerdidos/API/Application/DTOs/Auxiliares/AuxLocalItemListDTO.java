package com.AchadosPerdidos.API.Application.DTOs.Auxiliares;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de locais de itens")
public class AuxLocalItemListDTO {
    
    @Schema(description = "Lista de locais de itens")
    private List<AuxLocalItemDTO> locaisItens;
    
    @Schema(description = "Total de locais na lista")
    private int totalCount;

    // Getters e Setters
    public List<AuxLocalItemDTO> getLocaisItens() { return locaisItens; }
    public void setLocaisItens(List<AuxLocalItemDTO> locaisItens) { this.locaisItens = locaisItens; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
