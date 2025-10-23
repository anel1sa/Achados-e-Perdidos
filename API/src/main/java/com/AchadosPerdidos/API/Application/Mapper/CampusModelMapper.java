package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Campus.CampusDTO;
import com.AchadosPerdidos.API.Application.DTOs.Campus.CampusListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Campus;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class CampusModelMapper {

    public CampusDTO toDTO(Campus campus) {
        if (campus == null) {
            return null;
        }
        
        CampusDTO dto = new CampusDTO();
        dto.setId_Campus(campus.getId_Campus());
        dto.setNome_Campus(campus.getNome_Campus());
        dto.setCidade(campus.getCidade());
        dto.setEstado(campus.getEstado());
        dto.setEndereco(campus.getEndereco());
        dto.setCEP(campus.getCEP());
        dto.setFlg_Ativo(campus.getFlg_Ativo());
        dto.setId_Instituicao(campus.getId_Instituicao());
        
        return dto;
    }

    public Campus toEntity(CampusDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Campus campus = new Campus();
        campus.setId_Campus(dto.getId_Campus());
        campus.setNome_Campus(dto.getNome_Campus());
        campus.setCidade(dto.getCidade());
        campus.setEstado(dto.getEstado());
        campus.setEndereco(dto.getEndereco());
        campus.setCEP(dto.getCEP());
        campus.setFlg_Ativo(dto.getFlg_Ativo());
        campus.setId_Instituicao(dto.getId_Instituicao());
        
        return campus;
    }

    public CampusListDTO toListDTO(List<Campus> campus) {
        if (campus == null) {
            return null;
        }
        
        List<CampusDTO> dtoList = campus.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        CampusListDTO listDTO = new CampusListDTO();
        listDTO.setCampi(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}