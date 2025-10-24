package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Itens;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IItensQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class ItensQueries implements IItensQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Itens> rowMapper = (rs, _) -> {
        Itens itens = new Itens();
        itens.setId_Item(rs.getInt("Id_Item"));
        itens.setNome_Item(rs.getString("Nome_Item"));
        itens.setDescricao_Item(rs.getString("Descricao_Item"));
        itens.setData_Hora_Item(rs.getDate("Data_Hora_Item"));
        itens.setData_Cadastro(rs.getDate("Data_Cadastro"));
        itens.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
        itens.setStatus_Item_Id(rs.getInt("Status_Item_Id"));
        itens.setUsuario_Id(rs.getInt("Usuario_Id"));
        itens.setLocal_Id(rs.getInt("Local_Id"));
        itens.setCampus_Id(rs.getInt("Campus_Id"));
        itens.setId_Empresa(rs.getInt("Id_Empresa"));
        return itens;
    };

    @Override
    public List<Itens> findAll() {
        String sql = "SELECT * FROM Itens ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Itens findById(int id) {
        String sql = "SELECT * FROM Itens WHERE Id_Item = ?";
        List<Itens> itens = jdbcTemplate.query(sql, rowMapper, id);
        return itens.isEmpty() ? null : itens.get(0);
    }

    @Override
    public Itens insert(Itens itens) {
        String sql = "INSERT INTO Itens (Nome_Item, Descricao_Item, Data_Hora_Item, Data_Cadastro, Flg_Inativo, Status_Item_Id, Usuario_Id, Local_Id, Campus_Id, Id_Empresa) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            itens.getNome_Item(),
            itens.getDescricao_Item(),
            itens.getData_Hora_Item(),
            itens.getData_Cadastro(),
            itens.getFlg_Inativo(),
            itens.getStatus_Item_Id(),
            itens.getUsuario_Id(),
            itens.getLocal_Id(),
            itens.getCampus_Id(),
            itens.getId_Empresa());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Itens WHERE Nome_Item = ? AND Data_Cadastro = ? ORDER BY Id_Item DESC LIMIT 1";
        List<Itens> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            itens.getNome_Item(), 
            itens.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Itens update(Itens itens) {
        String sql = "UPDATE Itens SET Nome_Item = ?, Descricao_Item = ?, Data_Hora_Item = ?, Flg_Inativo = ?, Status_Item_Id = ?, Usuario_Id = ?, Local_Id = ?, Campus_Id = ?, Id_Empresa = ? WHERE Id_Item = ?";
        jdbcTemplate.update(sql, 
            itens.getNome_Item(),
            itens.getDescricao_Item(),
            itens.getData_Hora_Item(),
            itens.getFlg_Inativo(),
            itens.getStatus_Item_Id(),
            itens.getUsuario_Id(),
            itens.getLocal_Id(),
            itens.getCampus_Id(),
            itens.getId_Empresa(),
            itens.getId_Item());
        
        return findById(itens.getId_Item());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Itens WHERE Id_Item = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Itens> findActive() {
        String sql = "SELECT * FROM Itens WHERE Flg_Inativo = false ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Itens> findByStatus(int statusId) {
        String sql = "SELECT * FROM Itens WHERE Status_Item_Id = ? ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper, statusId);
    }

    @Override
    public List<Itens> findByUser(int userId) {
        String sql = "SELECT * FROM Itens WHERE Usuario_Id = ? ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    @Override
    public List<Itens> findByCampus(int campusId) {
        String sql = "SELECT * FROM Itens WHERE Campus_Id = ? ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper, campusId);
    }

    @Override
    public List<Itens> findByLocal(int localId) {
        String sql = "SELECT * FROM Itens WHERE Local_Id = ? ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper, localId);
    }

    @Override
    public List<Itens> findByEmpresa(int empresaId) {
        String sql = "SELECT * FROM Itens WHERE Id_Empresa = ? ORDER BY Data_Cadastro DESC";
        return jdbcTemplate.query(sql, rowMapper, empresaId);
    }

    @Override
    public List<Itens> searchByTerm(String searchTerm) {
        String sql = "SELECT * FROM Itens WHERE (Nome_Item LIKE ? OR Descricao_Item LIKE ?) AND Flg_Inativo = false ORDER BY Data_Cadastro DESC";
        String searchPattern = "%" + searchTerm + "%";
        return jdbcTemplate.query(sql, rowMapper, searchPattern, searchPattern);
    }
}
