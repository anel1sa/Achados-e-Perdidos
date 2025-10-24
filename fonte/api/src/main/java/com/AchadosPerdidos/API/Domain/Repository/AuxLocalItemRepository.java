package com.AchadosPerdidos.API.Domain.Repository;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Local_Item;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IAuxLocalItemRepository;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IAuxLocalItemQueries;
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
public class AuxLocalItemRepository implements IAuxLocalItemRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    private IAuxLocalItemQueries auxLocalItemQueries;
    
    private final RowMapper<Aux_Local_Item> auxLocalItemRowMapper = (rs, _) -> {
        Aux_Local_Item auxLocalItem = new Aux_Local_Item();
        auxLocalItem.setId_Aux_Local_Item(rs.getInt("Id_Aux_Local_Item"));
        auxLocalItem.setNome_Local_Item(rs.getString("Nome_Local_Item"));
        auxLocalItem.setDescricao_Local_Item(rs.getString("Descricao_Local_Item"));
        auxLocalItem.setData_Cadastro_Local_Item(rs.getTimestamp("Data_Cadastro_Local_Item"));
        auxLocalItem.setFlg_Inativo_Local_Item(rs.getBoolean("Flg_Inativo_Local_Item"));
        return auxLocalItem;
    };
    
    @Override
    public int inserir(Aux_Local_Item auxLocalItem) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(auxLocalItemQueries.getInsertAuxLocalItem(), Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, auxLocalItem.getNome_Local_Item());
            ps.setString(2, auxLocalItem.getDescricao_Local_Item());
            ps.setTimestamp(3, new java.sql.Timestamp(auxLocalItem.getData_Cadastro_Local_Item().getTime()));
            ps.setBoolean(4, Boolean.TRUE.equals(auxLocalItem.getFlg_Inativo_Local_Item()));
            return ps;
        }, keyHolder);
        
        Number key = keyHolder.getKey();
        return key != null ? key.intValue() : 0;
    }
    
    @Override
    public Aux_Local_Item buscarPorId(int id) {
        List<Aux_Local_Item> auxLocalItems = jdbcTemplate.query(auxLocalItemQueries.getSelectById(), auxLocalItemRowMapper, id);
        return auxLocalItems.isEmpty() ? null : auxLocalItems.get(0);
    }
    
    @Override
    public Aux_Local_Item buscarPorNome(String nome) {
        List<Aux_Local_Item> auxLocalItems = jdbcTemplate.query(auxLocalItemQueries.getSelectByNome(), auxLocalItemRowMapper, nome);
        return auxLocalItems.isEmpty() ? null : auxLocalItems.get(0);
    }
    
    @Override
    public List<Aux_Local_Item> listarTodos() {
        return jdbcTemplate.query(auxLocalItemQueries.getSelectAll(), auxLocalItemRowMapper);
    }
    
    @Override
    public boolean atualizar(Aux_Local_Item auxLocalItem) {
        int rowsAffected = jdbcTemplate.update(auxLocalItemQueries.getUpdateAuxLocalItem(),
            auxLocalItem.getNome_Local_Item(),
            auxLocalItem.getDescricao_Local_Item(),
            auxLocalItem.getFlg_Inativo_Local_Item(),
            auxLocalItem.getId_Aux_Local_Item()
        );
        
        return rowsAffected > 0;
    }
    
    @Override
    public boolean deletar(int id) {
        int rowsAffected = jdbcTemplate.update(auxLocalItemQueries.getDeleteAuxLocalItem(), id);
        return rowsAffected > 0;
    }
}
