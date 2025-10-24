package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class AuxTipoRoleModelMapper {

    public AuxTipoRoleDTO toDTO(Aux_Tipo_Role auxTipoRole) {
        if (auxTipoRole == null) {
            return null;
        }
        
        AuxTipoRoleDTO dto = new AuxTipoRoleDTO();
        dto.setId_Tipo_Role(auxTipoRole.getId_Tipo_Role());
        dto.setNome_Tipo_Role(auxTipoRole.getNome_Tipo_Role());
        
        return dto;
    }

    public Aux_Tipo_Role toEntity(AuxTipoRoleDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Aux_Tipo_Role auxTipoRole = new Aux_Tipo_Role();
        auxTipoRole.setId_Tipo_Role(dto.getId_Tipo_Role());
        auxTipoRole.setNome_Tipo_Role(dto.getNome_Tipo_Role());
        
        return auxTipoRole;
    }

    public AuxTipoRoleListDTO toListDTO(List<Aux_Tipo_Role> auxTipoRoles) {
        if (auxTipoRoles == null) {
            return null;
        }
        
        List<AuxTipoRoleDTO> dtoList = auxTipoRoles.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        AuxTipoRoleListDTO listDTO = new AuxTipoRoleListDTO();
        listDTO.setTiposRole(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}
