package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Instituicao;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IInstituicaoQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class InstituicaoQueries implements IInstituicaoQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Instituicao> rowMapper = new RowMapper<Instituicao>() {
        @Override
        public Instituicao mapRow(ResultSet rs, int rowNum) throws SQLException {
            Instituicao instituicao = new Instituicao();
            instituicao.setId_Instituicao(rs.getInt("Id_Instituicao"));
            instituicao.setTipo_Instituicao(rs.getString("Tipo_Instituicao"));
            instituicao.setNome_Instituicao(rs.getString("Nome_Instituicao"));
            instituicao.setCNPJ_Filial(rs.getString("CNPJ_Filial"));
            instituicao.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
            instituicao.setData_Cadastro(rs.getDate("Data_Cadastro"));
            return instituicao;
        }
    };

    @Override
    public List<Instituicao> findAll() {
        String sql = "SELECT * FROM Instituicao ORDER BY Nome_Instituicao";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Instituicao findById(int id) {
        String sql = "SELECT * FROM Instituicao WHERE Id_Instituicao = ?";
        List<Instituicao> instituicoes = jdbcTemplate.query(sql, rowMapper, id);
        return instituicoes.isEmpty() ? null : instituicoes.get(0);
    }

    @Override
    public Instituicao insert(Instituicao instituicao) {
        String sql = "INSERT INTO Instituicao (Tipo_Instituicao, Nome_Instituicao, CNPJ_Filial, Flg_Inativo, Data_Cadastro) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            instituicao.getTipo_Instituicao(),
            instituicao.getNome_Instituicao(), 
            instituicao.getCNPJ_Filial(),
            instituicao.getFlg_Inativo(),
            instituicao.getData_Cadastro());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Instituicao WHERE Nome_Instituicao = ? AND Data_Cadastro = ? ORDER BY Id_Instituicao DESC LIMIT 1";
        List<Instituicao> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            instituicao.getNome_Instituicao(), 
            instituicao.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Instituicao update(Instituicao instituicao) {
        String sql = "UPDATE Instituicao SET Tipo_Instituicao = ?, Nome_Instituicao = ?, CNPJ_Filial = ?, Flg_Inativo = ? WHERE Id_Instituicao = ?";
        jdbcTemplate.update(sql, 
            instituicao.getTipo_Instituicao(),
            instituicao.getNome_Instituicao(),
            instituicao.getCNPJ_Filial(),
            instituicao.getFlg_Inativo(),
            instituicao.getId_Instituicao());
        
        return findById(instituicao.getId_Instituicao());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Instituicao WHERE Id_Instituicao = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Instituicao> findActive() {
        String sql = "SELECT * FROM Instituicao WHERE Flg_Inativo = false ORDER BY Nome_Instituicao";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Instituicao> findByType(String tipoInstituicao) {
        String sql = "SELECT * FROM Instituicao WHERE Tipo_Instituicao = ? ORDER BY Nome_Instituicao";
        return jdbcTemplate.query(sql, rowMapper, tipoInstituicao);
    }
}
