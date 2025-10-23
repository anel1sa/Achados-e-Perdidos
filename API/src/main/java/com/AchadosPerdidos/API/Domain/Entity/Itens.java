package com.AchadosPerdidos.API.Domain.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Itens {
    private int Id_Item;
    private String Nome_Item;
    private String Descricao_Item;
    private Date Data_Hora_Item;
    private Boolean Flg_Inativo;
    private Date Data_Cadastro;
    private int Status_Item_Id;
    private int Usuario_Id;
    private int Local_Id;
    private Integer Campus_Id;
    private Integer Id_Empresa;
}