package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Empresa.EmpresaDTO;
import com.AchadosPerdidos.API.Application.DTOs.Empresa.EmpresaListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Empresa;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class EmpresaModelMapper {

    public EmpresaDTO toDTO(Empresa empresa) {
        if (empresa == null) {
            return null;
        }
        
        EmpresaDTO dto = new EmpresaDTO();
        dto.setId_Empresa(empresa.getId_Empresa());
        dto.setNome_Empresa(empresa.getNome_Empresa());
        dto.setCNPJ_Empresa(empresa.getCNPJ_Matriz());
        dto.setEndereco_Empresa(empresa.getPais_Sede()); // Mapeando Pais_Sede para Endereco_Empresa
        dto.setTelefone_Empresa(empresa.getContato_Principal()); // Mapeando Contato_Principal para Telefone_Empresa
        dto.setEmail_Empresa(empresa.getWebsite()); // Mapeando Website para Email_Empresa
        dto.setFlg_Ativo(empresa.getFlg_Ativo());
        
        return dto;
    }

    public Empresa toEntity(EmpresaDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Empresa empresa = new Empresa();
        empresa.setId_Empresa(dto.getId_Empresa());
        empresa.setNome_Empresa(dto.getNome_Empresa());
        empresa.setCNPJ_Matriz(dto.getCNPJ_Empresa());
        empresa.setPais_Sede(dto.getEndereco_Empresa()); // Mapeando Endereco_Empresa para Pais_Sede
        empresa.setContato_Principal(dto.getTelefone_Empresa()); // Mapeando Telefone_Empresa para Contato_Principal
        empresa.setWebsite(dto.getEmail_Empresa()); // Mapeando Email_Empresa para Website
        empresa.setFlg_Ativo(dto.getFlg_Ativo());
        
        return empresa;
    }

    public EmpresaListDTO toListDTO(List<Empresa> empresas) {
        if (empresas == null) {
            return null;
        }
        
        List<EmpresaDTO> dtoList = empresas.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        EmpresaListDTO listDTO = new EmpresaListDTO();
        listDTO.setEmpresas(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}
