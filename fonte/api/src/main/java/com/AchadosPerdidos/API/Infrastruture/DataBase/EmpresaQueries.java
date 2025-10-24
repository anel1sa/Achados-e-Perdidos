package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Empresa;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IEmpresaQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class EmpresaQueries implements IEmpresaQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Empresa> rowMapper = new RowMapper<Empresa>() {
        @Override
        public Empresa mapRow(ResultSet rs, int rowNum) throws SQLException {
            Empresa empresa = new Empresa();
            empresa.setId_Empresa(rs.getInt("Id_Empresa"));
            empresa.setNome_Empresa(rs.getString("Nome_Empresa"));
            empresa.setCNPJ_Matriz(rs.getString("CNPJ_Matriz"));
            empresa.setPais_Sede(rs.getString("Pais_Sede"));
            empresa.setWebsite(rs.getString("Website"));
            empresa.setContato_Principal(rs.getString("Contato_Principal"));
            empresa.setFlg_Ativo(rs.getBoolean("Flg_Ativo"));
            empresa.setData_Cadastro(rs.getDate("Data_Cadastro"));
            return empresa;
        }
    };

    @Override
    public List<Empresa> findAll() {
        String sql = "SELECT * FROM Empresa ORDER BY Nome_Empresa";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Empresa findById(int id) {
        String sql = "SELECT * FROM Empresa WHERE Id_Empresa = ?";
        List<Empresa> empresas = jdbcTemplate.query(sql, rowMapper, id);
        return empresas.isEmpty() ? null : empresas.get(0);
    }

    @Override
    public Empresa insert(Empresa empresa) {
        String sql = "INSERT INTO Empresa (Nome_Empresa, CNPJ_Matriz, Pais_Sede, Website, Contato_Principal, Flg_Ativo, Data_Cadastro) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            empresa.getNome_Empresa(),
            empresa.getCNPJ_Matriz(),
            empresa.getPais_Sede(),
            empresa.getWebsite(),
            empresa.getContato_Principal(),
            empresa.getFlg_Ativo(),
            empresa.getData_Cadastro());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Empresa WHERE Nome_Empresa = ? AND Data_Cadastro = ? ORDER BY Id_Empresa DESC LIMIT 1";
        List<Empresa> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            empresa.getNome_Empresa(), 
            empresa.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Empresa update(Empresa empresa) {
        String sql = "UPDATE Empresa SET Nome_Empresa = ?, CNPJ_Matriz = ?, Pais_Sede = ?, Website = ?, Contato_Principal = ?, Flg_Ativo = ? WHERE Id_Empresa = ?";
        jdbcTemplate.update(sql, 
            empresa.getNome_Empresa(),
            empresa.getCNPJ_Matriz(),
            empresa.getPais_Sede(),
            empresa.getWebsite(),
            empresa.getContato_Principal(),
            empresa.getFlg_Ativo(),
            empresa.getId_Empresa());
        
        return findById(empresa.getId_Empresa());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Empresa WHERE Id_Empresa = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Empresa> findActive() {
        String sql = "SELECT * FROM Empresa WHERE Flg_Ativo = true ORDER BY Nome_Empresa";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Empresa> findByCountry(String paisSede) {
        String sql = "SELECT * FROM Empresa WHERE Pais_Sede = ? ORDER BY Nome_Empresa";
        return jdbcTemplate.query(sql, rowMapper, paisSede);
    }
}
