package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Reivindicacoes;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IReivindicacoesQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ReivindicacoesQueries implements IReivindicacoesQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Reivindicacoes> rowMapper = new RowMapper<Reivindicacoes>() {
        @Override
        public Reivindicacoes mapRow(ResultSet rs, int rowNum) throws SQLException {
            Reivindicacoes reivindicacoes = new Reivindicacoes();
            reivindicacoes.setId_Reivindicacao(rs.getInt("Id_Reivindicacao"));
            reivindicacoes.setId_Item(rs.getInt("Id_Item"));
            reivindicacoes.setId_Usuario_Post(rs.getInt("Id_Usuario_Post"));
            reivindicacoes.setId_Usuario_Proprietario(rs.getInt("Id_Usuario_Proprietario"));
            reivindicacoes.setData_Reivindicacao(rs.getDate("Data_Reivindicacao"));
            reivindicacoes.setObservacao(rs.getString("Observacao"));
            return reivindicacoes;
        }
    };

    @Override
    public List<Reivindicacoes> findAll() {
        String sql = "SELECT * FROM Reivindicacoes ORDER BY Data_Reivindicacao DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Reivindicacoes findById(int id) {
        String sql = "SELECT * FROM Reivindicacoes WHERE Id_Reivindicacao = ?";
        List<Reivindicacoes> reivindicacoes = jdbcTemplate.query(sql, rowMapper, id);
        return reivindicacoes.isEmpty() ? null : reivindicacoes.get(0);
    }

    @Override
    public Reivindicacoes insert(Reivindicacoes reivindicacoes) {
        String sql = "INSERT INTO Reivindicacoes (Id_Item, Id_Usuario_Post, Id_Usuario_Proprietario, Data_Reivindicacao, Observacao) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            reivindicacoes.getId_Item(),
            reivindicacoes.getId_Usuario_Post(),
            reivindicacoes.getId_Usuario_Proprietario(),
            reivindicacoes.getData_Reivindicacao(),
            reivindicacoes.getObservacao());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Reivindicacoes WHERE Id_Item = ? AND Id_Usuario_Post = ? AND Data_Reivindicacao = ? ORDER BY Id_Reivindicacao DESC LIMIT 1";
        List<Reivindicacoes> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            reivindicacoes.getId_Item(),
            reivindicacoes.getId_Usuario_Post(),
            reivindicacoes.getData_Reivindicacao());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Reivindicacoes update(Reivindicacoes reivindicacoes) {
        String sql = "UPDATE Reivindicacoes SET Id_Item = ?, Id_Usuario_Post = ?, Id_Usuario_Proprietario = ?, Observacao = ? WHERE Id_Reivindicacao = ?";
        jdbcTemplate.update(sql, 
            reivindicacoes.getId_Item(),
            reivindicacoes.getId_Usuario_Post(),
            reivindicacoes.getId_Usuario_Proprietario(),
            reivindicacoes.getObservacao(),
            reivindicacoes.getId_Reivindicacao());
        
        return findById(reivindicacoes.getId_Reivindicacao());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Reivindicacoes WHERE Id_Reivindicacao = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Reivindicacoes> findByItem(int itemId) {
        String sql = "SELECT * FROM Reivindicacoes WHERE Id_Item = ? ORDER BY Data_Reivindicacao DESC";
        return jdbcTemplate.query(sql, rowMapper, itemId);
    }

    @Override
    public List<Reivindicacoes> findByUser(int userId) {
        String sql = "SELECT * FROM Reivindicacoes WHERE Id_Usuario_Post = ? ORDER BY Data_Reivindicacao DESC";
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    @Override
    public List<Reivindicacoes> findByProprietario(int proprietarioId) {
        String sql = "SELECT * FROM Reivindicacoes WHERE Id_Usuario_Proprietario = ? ORDER BY Data_Reivindicacao DESC";
        return jdbcTemplate.query(sql, rowMapper, proprietarioId);
    }

    @Override
    public Reivindicacoes findByItemAndUser(int itemId, int userId) {
        String sql = "SELECT * FROM Reivindicacoes WHERE Id_Item = ? AND Id_Usuario_Post = ? ORDER BY Data_Reivindicacao DESC LIMIT 1";
        List<Reivindicacoes> reivindicacoes = jdbcTemplate.query(sql, rowMapper, itemId, userId);
        return reivindicacoes.isEmpty() ? null : reivindicacoes.get(0);
    }
}
