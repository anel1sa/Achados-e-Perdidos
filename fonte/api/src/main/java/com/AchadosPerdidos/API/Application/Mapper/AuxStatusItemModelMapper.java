package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Status_Item;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AuxStatusItemModelMapper {
    
    public AuxStatusItemDTO toDTO(Aux_Status_Item entity) { 
        if (entity == null) {
            return null;
        }
        
        AuxStatusItemDTO dto = new AuxStatusItemDTO();
        dto.setId_Status_Item(entity.getId_Status_Item());
        dto.setDescricao_Status_Item(entity.getDescricao_Status_Item());
        return dto;
    }
    
    public Aux_Status_Item toEntity(AuxStatusItemDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Aux_Status_Item entity = new Aux_Status_Item();
        
        entity.setId_Status_Item(dto.getId_Status_Item());
        entity.setDescricao_Status_Item(dto.getDescricao_Status_Item());
        
        return entity;
    }

    public AuxStatusItemListDTO toListDTO(Aux_Status_Item entity) {
        if (entity == null) {
            return null;
        }

        AuxStatusItemListDTO listDTO = new AuxStatusItemListDTO();
        listDTO.setStatusItens(List.of(toDTO(entity)));
        listDTO.setTotalCount(1);
        return listDTO;
    }
}
