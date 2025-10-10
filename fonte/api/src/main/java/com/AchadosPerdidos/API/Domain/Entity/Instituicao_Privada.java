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
public class Instituicao_Privada {
    private int Id_Instituicao_Privada;
    private String Nome_Instituicao_Privada;
    private String CNPJ_Instituicao_Privada;
    private Boolean Flg_Inativo;
    private Date Data_Cadastro;
}