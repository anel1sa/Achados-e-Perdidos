package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensDTO;
import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Itens;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ItensModelMapper {

    public ItensDTO toDTO(Itens itens) {
        if (itens == null) {
            return null;
        }
        
        ItensDTO dto = new ItensDTO();
        dto.setId_Item(itens.getId_Item());
        dto.setNome_Item(itens.getNome_Item());
        dto.setDescricao_Item(itens.getDescricao_Item());
        dto.setData_Hora_Item(itens.getData_Hora_Item());
        dto.setData_Cadastro(itens.getData_Cadastro());
        dto.setFlg_Inativo(itens.getFlg_Inativo());
        dto.setStatus_Item_Id(itens.getStatus_Item_Id());
        dto.setUsuario_Id(itens.getUsuario_Id());
        dto.setLocal_Id(itens.getLocal_Id());
        dto.setCampus_Id(itens.getCampus_Id());
        dto.setId_Empresa(itens.getId_Empresa());
        
        return dto;
    }

    public Itens toEntity(ItensDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Itens itens = new Itens();
        itens.setId_Item(dto.getId_Item());
        itens.setNome_Item(dto.getNome_Item());
        itens.setDescricao_Item(dto.getDescricao_Item());
        itens.setData_Hora_Item(dto.getData_Hora_Item());
        itens.setData_Cadastro(dto.getData_Cadastro());
        itens.setFlg_Inativo(dto.getFlg_Inativo());
        itens.setStatus_Item_Id(dto.getStatus_Item_Id());
        itens.setUsuario_Id(dto.getUsuario_Id());
        itens.setLocal_Id(dto.getLocal_Id());
        itens.setCampus_Id(dto.getCampus_Id());
        itens.setId_Empresa(dto.getId_Empresa());
        
        return itens;
    }

    public ItensListDTO toListDTO(List<Itens> itens) {
        if (itens == null) {
            return null;
        }
        
        List<ItensDTO> dtoList = itens.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        ItensListDTO listDTO = new ItensListDTO();
        listDTO.setItens(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}
