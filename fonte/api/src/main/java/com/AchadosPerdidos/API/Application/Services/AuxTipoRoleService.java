package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleListDTO;
import com.AchadosPerdidos.API.Application.Mapper.AuxTipoRoleModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IAuxTipoRoleService;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import com.AchadosPerdidos.API.Domain.Repository.AuxTipoRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AuxTipoRoleService implements IAuxTipoRoleService {

    @Autowired
    private AuxTipoRoleRepository auxTipoRoleRepository;

    @Autowired
    private AuxTipoRoleModelMapper auxTipoRoleModelMapper;

    @Override
    public AuxTipoRoleListDTO getAllAuxTipoRoles() {
        List<Aux_Tipo_Role> auxTipoRoles = auxTipoRoleRepository.findAll();
        return auxTipoRoleModelMapper.toListDTO(auxTipoRoles);
    }

    @Override
    public AuxTipoRoleDTO getAuxTipoRoleById(int id) {
        Aux_Tipo_Role auxTipoRole = auxTipoRoleRepository.findById(id);
        return auxTipoRoleModelMapper.toDTO(auxTipoRole);
    }

    @Override
    public AuxTipoRoleDTO createAuxTipoRole(AuxTipoRoleDTO auxTipoRoleDTO) {
        Aux_Tipo_Role auxTipoRole = auxTipoRoleModelMapper.toEntity(auxTipoRoleDTO);
        auxTipoRole.setData_Cadastro(new Date());
        auxTipoRole.setFlg_Inativo(false);
        
        Aux_Tipo_Role savedAuxTipoRole = auxTipoRoleRepository.save(auxTipoRole);
        return auxTipoRoleModelMapper.toDTO(savedAuxTipoRole);
    }

    @Override
    public AuxTipoRoleDTO updateAuxTipoRole(int id, AuxTipoRoleDTO auxTipoRoleDTO) {
        Aux_Tipo_Role existingAuxTipoRole = auxTipoRoleRepository.findById(id);
        if (existingAuxTipoRole == null) {
            return null;
        }
        
        existingAuxTipoRole.setNome_Tipo_Role(auxTipoRoleDTO.getNome_Tipo_Role());
        
        Aux_Tipo_Role updatedAuxTipoRole = auxTipoRoleRepository.save(existingAuxTipoRole);
        return auxTipoRoleModelMapper.toDTO(updatedAuxTipoRole);
    }

    @Override
    public boolean deleteAuxTipoRole(int id) {
        Aux_Tipo_Role auxTipoRole = auxTipoRoleRepository.findById(id);
        if (auxTipoRole == null) {
            return false;
        }
        
        return auxTipoRoleRepository.deleteById(id);
    }

    @Override
    public AuxTipoRoleListDTO getActiveAuxTipoRoles() {
        List<Aux_Tipo_Role> activeAuxTipoRoles = auxTipoRoleRepository.findActive();
        return auxTipoRoleModelMapper.toListDTO(activeAuxTipoRoles);
    }
}
