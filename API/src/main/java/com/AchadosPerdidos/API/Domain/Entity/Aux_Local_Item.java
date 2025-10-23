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
public class Aux_Local_Item {
    private int Id_Aux_Local_Item;
    private String Nome_Local_Item;
    private String Descricao_Local_Item;
    private Date Data_Cadastro_Local_Item;
    private Boolean Flg_Inativo_Local_Item;
}