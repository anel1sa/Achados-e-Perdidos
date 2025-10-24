package com.AchadosPerdidos.API.Domain.Repository.Interfaces;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import java.util.List;

public interface IAuxTipoRoleRepository {
    List<Aux_Tipo_Role> findAll();
    Aux_Tipo_Role findById(int id);
    Aux_Tipo_Role save(Aux_Tipo_Role auxTipoRole);
    boolean deleteById(int id);
    List<Aux_Tipo_Role> findActive();
}
