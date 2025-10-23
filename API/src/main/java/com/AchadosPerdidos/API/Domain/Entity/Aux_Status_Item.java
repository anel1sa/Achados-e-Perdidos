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
public class Aux_Status_Item {
    private int Id_Status_Item;
    private String Descricao_Status_Item;
    private Date Data_Cadastro;
    private Boolean Flg_Inativo;
}