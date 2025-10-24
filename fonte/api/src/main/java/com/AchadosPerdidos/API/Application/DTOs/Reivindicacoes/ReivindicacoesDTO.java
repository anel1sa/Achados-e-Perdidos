package com.AchadosPerdidos.API.Application.DTOs.Reivindicacoes;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO completo de reivindicação")
public class ReivindicacoesDTO {
    
    @Schema(description = "ID único da reivindicação", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Reivindicacao;
    
    @Schema(description = "ID do item reivindicado", example = "1")
    private int Id_Item;
    
    @Schema(description = "ID do usuário que fez a reivindicação", example = "1")
    private int Id_Usuario;
    
    @Schema(description = "Data da reivindicação", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private Date Data_Reivindicacao;
    
    @Schema(description = "Status da reivindicação (PENDENTE, APROVADA, REJEITADA)", example = "PENDENTE")
    private String Status_Reivindicacao;
    
    @Schema(description = "Descrição da reivindicação", example = "Este item me pertence, perdi na biblioteca")
    private String Descricao_Reivindicacao;
    
    @Schema(description = "Comprovantes anexados", example = "nota_fiscal.pdf")
    private String Comprovantes;
}
