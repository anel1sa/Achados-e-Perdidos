package com.AchadosPerdidos.API.Application.DTOs.Reivindicacoes;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de reivindicações")
public class ReivindicacoesListDTO {
    
    @Schema(description = "Lista de reivindicações")
    private List<ReivindicacoesDTO> reivindicacoes;
    
    @Schema(description = "Total de reivindicações na lista")
    private int totalCount;

    // Getters e Setters
    public List<ReivindicacoesDTO> getReivindicacoes() { return reivindicacoes; }
    public void setReivindicacoes(List<ReivindicacoesDTO> reivindicacoes) { this.reivindicacoes = reivindicacoes; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
