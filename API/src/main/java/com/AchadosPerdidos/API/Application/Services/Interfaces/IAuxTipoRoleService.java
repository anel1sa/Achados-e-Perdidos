package com.AchadosPerdidos.API.Application.Services.Interfaces;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleListDTO;

public interface IAuxTipoRoleService {
    AuxTipoRoleListDTO getAllAuxTipoRoles();
    AuxTipoRoleDTO getAuxTipoRoleById(int id);
    AuxTipoRoleDTO createAuxTipoRole(AuxTipoRoleDTO auxTipoRoleDTO);
    AuxTipoRoleDTO updateAuxTipoRole(int id, AuxTipoRoleDTO auxTipoRoleDTO);
    boolean deleteAuxTipoRole(int id);
    AuxTipoRoleListDTO getActiveAuxTipoRoles();
}
