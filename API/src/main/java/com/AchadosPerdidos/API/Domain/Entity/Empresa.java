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
public class Empresa {
    private int Id_Empresa;
    private String Nome_Empresa;
    private String CNPJ_Matriz;
    private String Pais_Sede;
    private String Website;
    private String Contato_Principal;
    private Boolean Flg_Ativo;
    private Date Data_Cadastro;
}


