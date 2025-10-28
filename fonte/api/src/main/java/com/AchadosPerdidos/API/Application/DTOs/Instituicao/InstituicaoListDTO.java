package com.AchadosPerdidos.API.Application.DTOs.Instituicao;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de instituições")
public class InstituicaoListDTO {
    
    @Schema(description = "Lista de instituições")
    private List<InstituicaoDTO> instituicoes;
    
    @Schema(description = "Total de instituições na lista")
    private int totalCount;

    // Getters e Setters
    public List<InstituicaoDTO> getInstituicoes() { return instituicoes; }
    public void setInstituicoes(List<InstituicaoDTO> instituicoes) { this.instituicoes = instituicoes; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
