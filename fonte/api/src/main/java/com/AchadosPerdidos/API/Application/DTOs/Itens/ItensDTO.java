package com.AchadosPerdidos.API.Application.DTOs.Itens;

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
@Schema(description = "DTO completo de item")
public class ItensDTO {
    
    @Schema(description = "ID único do item", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Item;
    
    @Schema(description = "Nome do item", example = "Chave do Laboratório")
    private String Nome_Item;
    
    @Schema(description = "Descrição detalhada do item", example = "Chave do laboratório de informática, cor prata")
    private String Descricao_Item;
    
    @Schema(description = "Data e hora em que o item foi encontrado/perdido", example = "2024-01-01T10:30:00", accessMode = Schema.AccessMode.READ_ONLY)
    private Date Data_Hora_Item;
    
    @Schema(description = "Data de cadastro do item", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private Date Data_Cadastro;
    
    @Schema(description = "Status ativo/inativo do item", example = "false")
    private Boolean Flg_Inativo;
    
    @Schema(description = "ID do status do item (1=Ativo, 2=Reivindicado, 3=Doado)", example = "1")
    private int Status_Item_Id;
    
    @Schema(description = "ID do usuário que cadastrou o item", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Usuario_Id;
    
    @Schema(description = "ID do local onde o item foi encontrado", example = "2")
    private int Local_Id;
    
    @Schema(description = "ID do campus onde o item foi encontrado", example = "1")
    private int Campus_Id;
    
    @Schema(description = "ID da empresa (opcional)", example = "null", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Id_Empresa;
}
