package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IAuxLocalItemQueries;
import org.springframework.stereotype.Component;

@Component
public class AuxLocalItemQueries implements IAuxLocalItemQueries {
    
    private static final String SQL_INSERT_AUX_LOCAL_ITEM = """
            INSERT INTO ap.aux_local_item (
                nome_local_item, descricao_local_item, data_cadastro_local_item, flg_inativo_local_item
            ) VALUES (?, ?, ?, ?)
            """;
    
    private static final String SQL_SELECT_BY_ID = """
            SELECT * FROM ap.aux_local_item WHERE id_aux_local_item = ?
            """;
    
    private static final String SQL_SELECT_BY_NOME = """
            SELECT * FROM ap.aux_local_item WHERE nome_local_item = ?
            """;

    private static final String SQL_SELECT_ALL = """
            SELECT * FROM ap.aux_local_item ORDER BY nome_local_item
            """;

    private static final String SQL_UPDATE_AUX_LOCAL_ITEM = """
            UPDATE ap.aux_local_item SET 
                nome_local_item = ?, descricao_local_item = ?, flg_inativo_local_item = ?
            WHERE id_aux_local_item = ?
            """;
    
    private static final String SQL_DELETE_AUX_LOCAL_ITEM = "DELETE FROM ap.aux_local_item WHERE id_aux_local_item = ?";
    
    @Override
    public String getInsertAuxLocalItem() {
        return SQL_INSERT_AUX_LOCAL_ITEM;
    }
        
    @Override
    public String getSelectById() {
        return SQL_SELECT_BY_ID;
    }
    
    @Override
    public String getSelectByNome() {
        return SQL_SELECT_BY_NOME;
    }
    
    @Override
    public String getSelectAll() {
        return SQL_SELECT_ALL;
    }
    
    @Override
    public String getUpdateAuxLocalItem() {
        return SQL_UPDATE_AUX_LOCAL_ITEM;
    }
    
    @Override
    public String getDeleteAuxLocalItem() {
        return SQL_DELETE_AUX_LOCAL_ITEM;
    }
}