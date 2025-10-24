package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Tipo_Role;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IAuxTipoRoleQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class AuxTipoRoleQueries implements IAuxTipoRoleQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Aux_Tipo_Role> rowMapper = new RowMapper<Aux_Tipo_Role>() {
        @Override
        public Aux_Tipo_Role mapRow(ResultSet rs, int rowNum) throws SQLException {
            Aux_Tipo_Role auxTipoRole = new Aux_Tipo_Role();
            auxTipoRole.setId_Tipo_Role(rs.getInt("Id_Tipo_Role"));
            auxTipoRole.setNome_Tipo_Role(rs.getString("Nome_Tipo_Role"));
            auxTipoRole.setData_Cadastro(rs.getDate("Data_Cadastro"));
            auxTipoRole.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
            return auxTipoRole;
        }
    };

    @Override
    public List<Aux_Tipo_Role> findAll() {
        String sql = "SELECT * FROM Aux_Tipo_Role ORDER BY Nome_Tipo_Role";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Aux_Tipo_Role findById(int id) {
        String sql = "SELECT * FROM Aux_Tipo_Role WHERE Id_Tipo_Role = ?";
        List<Aux_Tipo_Role> auxTipoRoles = jdbcTemplate.query(sql, rowMapper, id);
        return auxTipoRoles.isEmpty() ? null : auxTipoRoles.get(0);
    }

    @Override
    public Aux_Tipo_Role insert(Aux_Tipo_Role auxTipoRole) {
        String sql = "INSERT INTO Aux_Tipo_Role (Nome_Tipo_Role, Data_Cadastro, Flg_Inativo) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, 
            auxTipoRole.getNome_Tipo_Role(), 
            auxTipoRole.getData_Cadastro(), 
            auxTipoRole.getFlg_Inativo());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Aux_Tipo_Role WHERE Nome_Tipo_Role = ? AND Data_Cadastro = ? ORDER BY Id_Tipo_Role DESC LIMIT 1";
        List<Aux_Tipo_Role> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            auxTipoRole.getNome_Tipo_Role(), 
            auxTipoRole.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Aux_Tipo_Role update(Aux_Tipo_Role auxTipoRole) {
        String sql = "UPDATE Aux_Tipo_Role SET Nome_Tipo_Role = ?, Flg_Inativo = ? WHERE Id_Tipo_Role = ?";
        jdbcTemplate.update(sql, 
            auxTipoRole.getNome_Tipo_Role(), 
            auxTipoRole.getFlg_Inativo(), 
            auxTipoRole.getId_Tipo_Role());
        
        return findById(auxTipoRole.getId_Tipo_Role());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Aux_Tipo_Role WHERE Id_Tipo_Role = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Aux_Tipo_Role> findActive() {
        String sql = "SELECT * FROM Aux_Tipo_Role WHERE Flg_Inativo = false ORDER BY Nome_Tipo_Role";
        return jdbcTemplate.query(sql, rowMapper);
    }
}
