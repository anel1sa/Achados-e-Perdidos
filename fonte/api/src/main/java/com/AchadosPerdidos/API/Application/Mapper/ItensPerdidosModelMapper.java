package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.ItensPerdidos.ItensPerdidosDTO;
import com.AchadosPerdidos.API.Application.DTOs.ItensPerdidos.ItensPerdidosListDTO;
import com.AchadosPerdidos.API.Domain.Entity.ItensPerdidos;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ItensPerdidosModelMapper {

    public ItensPerdidosDTO toDTO(ItensPerdidos itensPerdidos) {
        if (itensPerdidos == null) {
            return null;
        }
        
        ItensPerdidosDTO dto = new ItensPerdidosDTO();
        dto.setId(itensPerdidos.getId());
        dto.setNome(itensPerdidos.getNome());
        dto.setDescricao(itensPerdidos.getDescricao());
        dto.setEncontrado_Em(itensPerdidos.getEncontrado_Em());
        dto.setUsuario_Relator_Id(itensPerdidos.getUsuario_Relator_Id());
        dto.setLocal_Id(itensPerdidos.getLocal_Id());
        dto.setStatus_Item_Id(itensPerdidos.getStatus_Item_Id());
        dto.setDta_Criacao(itensPerdidos.getDta_Criacao());
        dto.setFlg_Inativo(itensPerdidos.getFlg_Inativo());
        dto.setDta_Remocao(itensPerdidos.getDta_Remocao());
        
        return dto;
    }

    public ItensPerdidos toEntity(ItensPerdidosDTO dto) {
        if (dto == null) {
            return null;
        }
        
        ItensPerdidos itensPerdidos = new ItensPerdidos();
        itensPerdidos.setId(dto.getId());
        itensPerdidos.setNome(dto.getNome());
        itensPerdidos.setDescricao(dto.getDescricao());
        itensPerdidos.setEncontrado_Em(dto.getEncontrado_Em());
        itensPerdidos.setUsuario_Relator_Id(dto.getUsuario_Relator_Id());
        itensPerdidos.setLocal_Id(dto.getLocal_Id());
        itensPerdidos.setStatus_Item_Id(dto.getStatus_Item_Id());
        itensPerdidos.setDta_Criacao(dto.getDta_Criacao());
        itensPerdidos.setFlg_Inativo(dto.getFlg_Inativo());
        itensPerdidos.setDta_Remocao(dto.getDta_Remocao());
        
        return itensPerdidos;
    }

    public ItensPerdidosListDTO toListDTO(List<ItensPerdidos> itensPerdidos) {
        if (itensPerdidos == null) {
            return null;
        }
        
        List<ItensPerdidosDTO> dtoList = itensPerdidos.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        ItensPerdidosListDTO listDTO = new ItensPerdidosListDTO();
        listDTO.setItensPerdidos(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}

