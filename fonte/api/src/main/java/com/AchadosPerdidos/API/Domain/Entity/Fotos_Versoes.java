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
public class Fotos_Versoes {
    private int Id_Versao;
    private int Id_Foto;
    private String Nome_Bucket;
    private String Chave_Objeto;
    private String Url_Arquivo;
    private Date Data_Versao;
    private String Observacao;
}


