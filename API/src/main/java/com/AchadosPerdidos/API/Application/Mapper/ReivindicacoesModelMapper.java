package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Reivindicacoes.ReivindicacoesDTO;
import com.AchadosPerdidos.API.Application.DTOs.Reivindicacoes.ReivindicacoesListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Reivindicacoes;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ReivindicacoesModelMapper {

    public ReivindicacoesDTO toDTO(Reivindicacoes reivindicacoes) {
        if (reivindicacoes == null) {
            return null;
        }
        
        ReivindicacoesDTO dto = new ReivindicacoesDTO();
        dto.setId_Reivindicacao(reivindicacoes.getId_Reivindicacao());
        dto.setId_Item(reivindicacoes.getId_Item());
        dto.setId_Usuario(reivindicacoes.getId_Usuario_Post());
        dto.setData_Reivindicacao(reivindicacoes.getData_Reivindicacao());
        dto.setStatus_Reivindicacao("PENDENTE"); // Status padrão
        dto.setDescricao_Reivindicacao(reivindicacoes.getObservacao());
        dto.setComprovantes(""); // Campo vazio por padrão
        
        return dto;
    }

    public Reivindicacoes toEntity(ReivindicacoesDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Reivindicacoes reivindicacoes = new Reivindicacoes();
        reivindicacoes.setId_Reivindicacao(dto.getId_Reivindicacao());
        reivindicacoes.setId_Item(dto.getId_Item());
        reivindicacoes.setId_Usuario_Post(dto.getId_Usuario());
        reivindicacoes.setData_Reivindicacao(dto.getData_Reivindicacao());
        reivindicacoes.setObservacao(dto.getDescricao_Reivindicacao());
        
        return reivindicacoes;
    }

    public ReivindicacoesListDTO toListDTO(List<Reivindicacoes> reivindicacoes) {
        if (reivindicacoes == null) {
            return null;
        }
        
        List<ReivindicacoesDTO> dtoList = reivindicacoes.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        ReivindicacoesListDTO listDTO = new ReivindicacoesListDTO();
        listDTO.setReivindicacoes(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}
