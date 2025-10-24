package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Fotos.FotosDTO;
import com.AchadosPerdidos.API.Application.DTOs.Fotos.FotosListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Fotos;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class FotosModelMapper {

    public FotosDTO toDTO(Fotos fotos) {
        if (fotos == null) {
            return null;
        }
        
        FotosDTO dto = new FotosDTO();
        dto.setId_Foto(fotos.getId_Foto());
        dto.setNome_Arquivo(fotos.getNome_Original());
        dto.setURL_Foto(fotos.getUrl_Arquivo());
        dto.setTamanho_Arquivo(fotos.getTamanho_Bytes());
        dto.setTipo_MIME("image/jpeg"); // Default MIME type
        dto.setId_Item(fotos.getItem_Id());
        dto.setId_Usuario(fotos.getUsuario_Id());
        
        return dto;
    }

    public Fotos toEntity(FotosDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Fotos fotos = new Fotos();
        fotos.setId_Foto(dto.getId_Foto());
        fotos.setNome_Original(dto.getNome_Arquivo());
        fotos.setUrl_Arquivo(dto.getURL_Foto());
        fotos.setTamanho_Bytes(dto.getTamanho_Arquivo());
        fotos.setItem_Id(dto.getId_Item());
        fotos.setUsuario_Id(dto.getId_Usuario());
        
        return fotos;
    }

    public FotosListDTO toListDTO(List<Fotos> fotos) {
        if (fotos == null) {
            return null;
        }
        
        List<FotosDTO> dtoList = fotos.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        FotosListDTO listDTO = new FotosListDTO();
        listDTO.setFotos(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}
