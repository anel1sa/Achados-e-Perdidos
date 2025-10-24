package com.AchadosPerdidos.API.Domain.Repository;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Status_Item;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IAuxStatusItemRepository;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IAuxStatusItemQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class AuxStatusItemRepository implements IAuxStatusItemRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;  
    
    @Autowired
    private IAuxStatusItemQueries auxStatusItemQueries;
    
    private final RowMapper<Aux_Status_Item> auxStatusItemRowMapper = (rs, _) -> {
        Aux_Status_Item auxStatusItem = new Aux_Status_Item();
        auxStatusItem.setId_Status_Item(rs.getInt("Id_Status_Item"));
        auxStatusItem.setDescricao_Status_Item(rs.getString("Descricao_Status_Item"));
        auxStatusItem.setData_Cadastro(rs.getTimestamp("Data_Cadastro"));
        auxStatusItem.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
        return auxStatusItem;
    };
    
    @Override
    public int inserir(Aux_Status_Item auxStatusItem) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(auxStatusItemQueries.getInsertAuxStatusItem(), Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, auxStatusItem.getDescricao_Status_Item());
            ps.setTimestamp(2, new java.sql.Timestamp(auxStatusItem.getData_Cadastro().getTime()));
            ps.setBoolean(3, Boolean.TRUE.equals(auxStatusItem.getFlg_Inativo()));
            return ps;
        }, keyHolder);
        
        Number key = keyHolder.getKey();
        return key != null ? key.intValue() : 0;
    }
    
    @Override
    public Aux_Status_Item buscarPorId(int id) {
        List<Aux_Status_Item> auxStatusItems = jdbcTemplate.query(auxStatusItemQueries.getSelectById(), auxStatusItemRowMapper, id);
        return auxStatusItems.isEmpty() ? null : auxStatusItems.get(0);
    }
    
    @Override
    public Aux_Status_Item buscarPorDescricao(String descricao) {
        List<Aux_Status_Item> auxStatusItems = jdbcTemplate.query(auxStatusItemQueries.getSelectByDescricao(), auxStatusItemRowMapper, descricao);
        return auxStatusItems.isEmpty() ? null : auxStatusItems.get(0);
    }
    
    @Override
    public List<Aux_Status_Item> listarTodos() {
        return jdbcTemplate.query(auxStatusItemQueries.getSelectAll(), auxStatusItemRowMapper);
    }
    
    @Override
    public boolean atualizar(Aux_Status_Item auxStatusItem) {
        int rowsAffected = jdbcTemplate.update(auxStatusItemQueries.getUpdateAuxStatusItem(),
            auxStatusItem.getDescricao_Status_Item(),
            auxStatusItem.getFlg_Inativo(),
            auxStatusItem.getId_Status_Item()
        );
        
        return rowsAffected > 0;
    }
    
    @Override
    public boolean deletar(int id) {
        int rowsAffected = jdbcTemplate.update(auxStatusItemQueries.getDeleteAuxStatusItem(), id);
        return rowsAffected > 0;
    }
}
