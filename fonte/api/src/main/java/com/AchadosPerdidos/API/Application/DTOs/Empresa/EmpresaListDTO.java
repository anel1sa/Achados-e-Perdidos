package com.AchadosPerdidos.API.Application.DTOs.Empresa;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "DTO para lista de empresas")
public class EmpresaListDTO {
    
    @Schema(description = "Lista de empresas")
    private List<EmpresaDTO> empresas;
    
    @Schema(description = "Total de empresas na lista")
    private int totalCount;

    // Getters e Setters
    public List<EmpresaDTO> getEmpresas() { return empresas; }
    public void setEmpresas(List<EmpresaDTO> empresas) { this.empresas = empresas; }

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
}
