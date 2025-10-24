package com.AchadosPerdidos.API.Application.DTOs.Fotos;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "DTO completo de foto")
public class FotosDTO {
    
    @Schema(description = "ID único da foto", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private int Id_Foto;
    
    @Schema(description = "Nome do arquivo da foto", example = "foto_item_123.jpg")
    private String Nome_Arquivo;
    
    @Schema(description = "URL da foto no S3", example = "https://bucket.s3.amazonaws.com/fotos/foto_item_123.jpg")
    private String URL_Foto;
    
    @Schema(description = "Tamanho do arquivo em bytes", example = "1024000")
    private Long Tamanho_Arquivo;
    
    @Schema(description = "Tipo MIME da foto", example = "image/jpeg")
    private String Tipo_MIME;
    
    @Schema(description = "ID do item relacionado", example = "1")
    private Integer Id_Item;
    
    @Schema(description = "ID do usuário que fez upload", example = "1", accessMode = Schema.AccessMode.READ_ONLY)
    private Integer Id_Usuario;
}
