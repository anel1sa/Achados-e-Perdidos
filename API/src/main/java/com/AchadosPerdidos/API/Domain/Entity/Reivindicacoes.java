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
public class Reivindicacoes {
    private int Id_Reivindicacao;
    private int Id_Item;
    private Integer Id_Usuario_Post;
    private Integer Id_Usuario_Proprietario;
    private Date Data_Reivindicacao;
    private String Observacao;
}