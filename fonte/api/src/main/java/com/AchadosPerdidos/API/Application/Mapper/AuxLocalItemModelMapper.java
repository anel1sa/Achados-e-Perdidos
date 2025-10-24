package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Local_Item;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AuxLocalItemModelMapper {
    
    public AuxLocalItemDTO toDTO(Aux_Local_Item entity) { 
        if (entity == null) {
            return null;
        }
        
        AuxLocalItemDTO dto = new AuxLocalItemDTO();
        dto.setId_Aux_Local_Item(entity.getId_Aux_Local_Item());
        dto.setNome_Local_Item(entity.getNome_Local_Item());
        dto.setDescricao_Local_Item(entity.getDescricao_Local_Item());
        return dto;
    }
    
    public Aux_Local_Item toEntity(AuxLocalItemDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Aux_Local_Item entity = new Aux_Local_Item();
        
        entity.setId_Aux_Local_Item(dto.getId_Aux_Local_Item());
        entity.setNome_Local_Item(dto.getNome_Local_Item());
        entity.setDescricao_Local_Item(dto.getDescricao_Local_Item());
        
        return entity;
    }

    public AuxLocalItemListDTO toListDTO(Aux_Local_Item entity) {
        if (entity == null) {
            return null;
        }

        AuxLocalItemListDTO listDTO = new AuxLocalItemListDTO();
        listDTO.setLocaisItens(List.of(toDTO(entity)));
        listDTO.setTotalCount(1);
        return listDTO;
    }
}
