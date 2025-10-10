package com.AchadosPerdidos.API.Domain.Entity;

import com.AchadosPerdidos.API.Domain.Enum.Provedor_Armazenamento;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Fotos {
    private int Id_Foto;
    private Integer Usuario_Id;
    private Integer Item_Id;
    private Provedor_Armazenamento Provedor_Armazenamento;
    private String Nome_Bucket;
    private String Chave_Objeto;
    private String Chave_Armazenamento;
    private String Url_Arquivo;
    private String Nome_Original;
    private Long Tamanho_Bytes;
    private Integer Largura;
    private Integer Altura;
    private Boolean Perfil_Usuario;
    private Boolean Foto_Item;
    private Boolean Flg_Inativo;
    private Date Data_Envio;
    private Date Data_Exclusao;
    private Date Data_Atualizacao;
}