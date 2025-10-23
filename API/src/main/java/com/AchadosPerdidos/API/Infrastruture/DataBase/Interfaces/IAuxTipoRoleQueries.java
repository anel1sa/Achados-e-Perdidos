package com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import java.util.List;

public interface IAuxTipoRoleQueries {
    List<Aux_Tipo_Role> findAll();
    Aux_Tipo_Role findById(int id);
    Aux_Tipo_Role insert(Aux_Tipo_Role auxTipoRole);
    Aux_Tipo_Role update(Aux_Tipo_Role auxTipoRole);
    boolean deleteById(int id);
    List<Aux_Tipo_Role> findActive();
}
