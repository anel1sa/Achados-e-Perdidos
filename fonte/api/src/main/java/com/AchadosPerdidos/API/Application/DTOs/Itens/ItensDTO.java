package com.AchadosPerdidos.API.Application.DTOs.Itens;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "DTO completo de item")
public class ItensDTO {
    
    @Schema(description = "ID único do item", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Item;
    
    @Schema(description = "Nome do item", example = "Chave do Laboratório")
    private String Nome_Item;
    
    @Schema(description = "Descrição detalhada do item", example = "Chave do laboratório de informática, cor prata")
    private String Descricao_Item;
    
    @Schema(description = "Data e hora em que o item foi encontrado/perdido", example = "2024-01-01T10:30:00", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Data_Hora_Item;
    
    @Schema(description = "Data de cadastro do item", example = "2024-01-01T00:00:00", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime Data_Cadastro;
    
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

    // Getters e Setters
    public int getId_Item() { return Id_Item; }
    public void setId_Item(int id_Item) { Id_Item = id_Item; }

    public String getNome_Item() { return Nome_Item; }
    public void setNome_Item(String nome_Item) { Nome_Item = nome_Item; }

    public String getDescricao_Item() { return Descricao_Item; }
    public void setDescricao_Item(String descricao_Item) { Descricao_Item = descricao_Item; }

    public LocalDateTime getData_Hora_Item() { return Data_Hora_Item; }
    public void setData_Hora_Item(LocalDateTime data_Hora_Item) { Data_Hora_Item = data_Hora_Item; }

    public LocalDateTime getData_Cadastro() { return Data_Cadastro; }
    public void setData_Cadastro(LocalDateTime data_Cadastro) { Data_Cadastro = data_Cadastro; }

    public Boolean getFlg_Inativo() { return Flg_Inativo; }
    public void setFlg_Inativo(Boolean flg_Inativo) { Flg_Inativo = flg_Inativo; }

    public int getStatus_Item_Id() { return Status_Item_Id; }
    public void setStatus_Item_Id(int status_Item_Id) { Status_Item_Id = status_Item_Id; }

    public int getUsuario_Id() { return Usuario_Id; }
    public void setUsuario_Id(int usuario_Id) { Usuario_Id = usuario_Id; }

    public int getLocal_Id() { return Local_Id; }
    public void setLocal_Id(int local_Id) { Local_Id = local_Id; }

    public int getCampus_Id() { return Campus_Id; }
    public void setCampus_Id(int campus_Id) { Campus_Id = campus_Id; }

    public Integer getId_Empresa() { return Id_Empresa; }
    public void setId_Empresa(Integer id_Empresa) { Id_Empresa = id_Empresa; }
}
