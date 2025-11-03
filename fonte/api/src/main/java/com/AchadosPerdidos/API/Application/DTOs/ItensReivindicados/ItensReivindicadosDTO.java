package com.AchadosPerdidos.API.Application.DTOs.ItensReivindicados;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

@Schema(description = "DTO completo de item reivindicado")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ItensReivindicadosDTO {
    
    @Schema(description = "ID único da reivindicação", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id;
    
    @Schema(description = "Detalhes da reivindicação", example = "Este item me pertence, perdi na biblioteca")
    private String Detalhes_Reivindicacao;
    
    @Schema(description = "ID do item reivindicado", example = "1")
    private int Item_Id;
    
    @Schema(description = "ID do usuário que fez a reivindicação", example = "1")
    private int Usuario_Reivindicador_Id;
    
    @Schema(description = "ID do usuário que achou o item", example = "2", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Usuario_Achou_Id;
    
    @Schema(description = "Data de criação", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Dta_Criacao;
    
    @Schema(description = "Flag indicando se está inativo", example = "false")
    private Boolean Flg_Inativo;
    
    @Schema(description = "Data de remoção", example = "null", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Dta_Remocao;
}

