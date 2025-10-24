package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Campus;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.ICampusQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CampusQueries implements ICampusQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Campus> rowMapper = new RowMapper<Campus>() {
        @Override
        public Campus mapRow(ResultSet rs, int rowNum) throws SQLException {
            Campus campus = new Campus();
            campus.setId_Campus(rs.getInt("Id_Campus"));
            campus.setId_Instituicao(rs.getInt("Id_Instituicao"));
            campus.setNome_Campus(rs.getString("Nome_Campus"));
            campus.setCidade(rs.getString("Cidade"));
            campus.setEstado(rs.getString("Estado"));
            campus.setEndereco(rs.getString("Endereco"));
            campus.setCEP(rs.getString("CEP"));
            campus.setLatitude(rs.getDouble("Latitude"));
            campus.setLongitude(rs.getDouble("Longitude"));
            campus.setFlg_Ativo(rs.getBoolean("Flg_Ativo"));
            campus.setData_Cadastro(rs.getDate("Data_Cadastro"));
            return campus;
        }
    };

    @Override
    public List<Campus> findAll() {
        String sql = "SELECT * FROM Campus ORDER BY Nome_Campus";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Campus findById(int id) {
        String sql = "SELECT * FROM Campus WHERE Id_Campus = ?";
        List<Campus> campus = jdbcTemplate.query(sql, rowMapper, id);
        return campus.isEmpty() ? null : campus.get(0);
    }

    @Override
    public Campus insert(Campus campus) {
        String sql = "INSERT INTO Campus (Id_Instituicao, Nome_Campus, Cidade, Estado, Endereco, CEP, Latitude, Longitude, Flg_Ativo, Data_Cadastro) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            campus.getId_Instituicao(),
            campus.getNome_Campus(), 
            campus.getCidade(),
            campus.getEstado(),
            campus.getEndereco(),
            campus.getCEP(),
            campus.getLatitude(),
            campus.getLongitude(),
            campus.getFlg_Ativo(),
            campus.getData_Cadastro());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Campus WHERE Nome_Campus = ? AND Data_Cadastro = ? ORDER BY Id_Campus DESC LIMIT 1";
        List<Campus> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            campus.getNome_Campus(), 
            campus.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Campus update(Campus campus) {
        String sql = "UPDATE Campus SET Id_Instituicao = ?, Nome_Campus = ?, Cidade = ?, Estado = ?, Endereco = ?, CEP = ?, Latitude = ?, Longitude = ?, Flg_Ativo = ? WHERE Id_Campus = ?";
        jdbcTemplate.update(sql, 
            campus.getId_Instituicao(),
            campus.getNome_Campus(),
            campus.getCidade(),
            campus.getEstado(),
            campus.getEndereco(),
            campus.getCEP(),
            campus.getLatitude(),
            campus.getLongitude(),
            campus.getFlg_Ativo(),
            campus.getId_Campus());
        
        return findById(campus.getId_Campus());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Campus WHERE Id_Campus = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Campus> findActive() {
        String sql = "SELECT * FROM Campus WHERE Flg_Ativo = true ORDER BY Nome_Campus";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Campus> findByInstitution(int institutionId) {
        String sql = "SELECT * FROM Campus WHERE Id_Instituicao = ? ORDER BY Nome_Campus";
        return jdbcTemplate.query(sql, rowMapper, institutionId);
    }
}
