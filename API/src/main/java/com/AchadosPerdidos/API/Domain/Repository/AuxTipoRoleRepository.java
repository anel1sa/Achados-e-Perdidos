package com.AchadosPerdidos.API.Domain.Repository;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IAuxTipoRoleRepository;
import com.AchadosPerdidos.API.Infrastruture.DataBase.AuxTipoRoleQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AuxTipoRoleRepository implements IAuxTipoRoleRepository {

    @Autowired
    private AuxTipoRoleQueries auxTipoRoleQueries;

    @Override
    public List<Aux_Tipo_Role> findAll() {
        return auxTipoRoleQueries.findAll();
    }

    @Override
    public Aux_Tipo_Role findById(int id) {
        return auxTipoRoleQueries.findById(id);
    }

    @Override
    public Aux_Tipo_Role save(Aux_Tipo_Role auxTipoRole) {
        if (auxTipoRole.getId_Tipo_Role() == 0) {
            return auxTipoRoleQueries.insert(auxTipoRole);
        } else {
            return auxTipoRoleQueries.update(auxTipoRole);
        }
    }

    @Override
    public boolean deleteById(int id) {
        return auxTipoRoleQueries.deleteById(id);
    }

    @Override
    public List<Aux_Tipo_Role> findActive() {
        return auxTipoRoleQueries.findActive();
    }
}
