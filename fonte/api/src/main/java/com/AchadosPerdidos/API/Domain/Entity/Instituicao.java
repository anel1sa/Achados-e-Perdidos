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
public class Instituicao {
    private int Id_Instituicao;
    private String Tipo_Instituicao;
    private String Nome_Instituicao;
    private String CNPJ_Filial;
    private Boolean Flg_Inativo;
    private Date Data_Cadastro;
}


