package com.AchadosPerdidos.API.Application.DTOs.Reivindicacoes;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "DTO completo de reivindicação")
public class ReivindicacoesDTO {
    
    @Schema(description = "ID único da reivindicação", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Reivindicacao;
    
    @Schema(description = "ID do item reivindicado", example = "1")
    private int Id_Item;
    
    @Schema(description = "ID do usuário que fez a reivindicação", example = "1")
    private int Id_Usuario;
    
    @Schema(description = "Data da reivindicação", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Data_Reivindicacao;
    
    @Schema(description = "Status da reivindicação (PENDENTE, APROVADA, REJEITADA)", example = "PENDENTE")
    private String Status_Reivindicacao;
    
    @Schema(description = "Descrição da reivindicação", example = "Este item me pertence, perdi na biblioteca")
    private String Descricao_Reivindicacao;
    
    @Schema(description = "Comprovantes anexados", example = "nota_fiscal.pdf")
    private String Comprovantes;

    // Getters e Setters
    public int getId_Reivindicacao() { return Id_Reivindicacao; }
    public void setId_Reivindicacao(int id_Reivindicacao) { Id_Reivindicacao = id_Reivindicacao; }

    public int getId_Item() { return Id_Item; }
    public void setId_Item(int id_Item) { Id_Item = id_Item; }

    public int getId_Usuario() { return Id_Usuario; }
    public void setId_Usuario(int id_Usuario) { Id_Usuario = id_Usuario; }

    public LocalDateTime getData_Reivindicacao() { return Data_Reivindicacao; }
    public void setData_Reivindicacao(LocalDateTime data_Reivindicacao) { Data_Reivindicacao = data_Reivindicacao; }

    public String getStatus_Reivindicacao() { return Status_Reivindicacao; }
    public void setStatus_Reivindicacao(String status_Reivindicacao) { Status_Reivindicacao = status_Reivindicacao; }

    public String getDescricao_Reivindicacao() { return Descricao_Reivindicacao; }
    public void setDescricao_Reivindicacao(String descricao_Reivindicacao) { Descricao_Reivindicacao = descricao_Reivindicacao; }

    public String getComprovantes() { return Comprovantes; }
    public void setComprovantes(String comprovantes) { Comprovantes = comprovantes; }
}
