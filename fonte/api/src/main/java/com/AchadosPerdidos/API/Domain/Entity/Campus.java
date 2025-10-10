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
public class Campus {
    private int Id_Campus;
    private Integer Id_Instituicao;
    private String Nome_Campus;
    private String Cidade;
    private String Estado;
    private String Endereco;
    private String CEP;
    private Double Latitude;
    private Double Longitude;
    private Boolean Flg_Ativo;
    private Date Data_Cadastro;
}


