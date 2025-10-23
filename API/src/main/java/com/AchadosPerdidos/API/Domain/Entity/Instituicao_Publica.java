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
public class Instituicao_Publica {
    private int Id_Instituicao_Publica;
    private String Nome_Instituicao_Publica;
    private String CNPJ_Instituicao_Publica;
    private Boolean Flg_Inativo;
    private Date Data_Cadastro;
}