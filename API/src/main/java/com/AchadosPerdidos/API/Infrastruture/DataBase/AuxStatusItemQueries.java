package com.AchadosPerdidos.API.Infrastruture.DataBase;
        
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IAuxStatusItemQueries;
import org.springframework.stereotype.Component;

@Component
public class AuxStatusItemQueries implements IAuxStatusItemQueries {
    
    private static final String SQL_INSERT_AUX_STATUS_ITEM = """
            INSERT INTO ap.aux_status_item (
                descricao_status_item, data_cadastro, flg_inativo
            ) VALUES (?, ?, ?)
            """;
    
    private static final String SQL_SELECT_BY_ID = """
            SELECT * FROM ap.aux_status_item WHERE id_status_item = ?
            """;
    
    private static final String SQL_SELECT_BY_DESCRICAO = """
            SELECT * FROM ap.aux_status_item WHERE descricao_status_item = ?
            """;

    private static final String SQL_SELECT_ALL = """
            SELECT * FROM ap.aux_status_item ORDER BY descricao_status_item
            """;

    private static final String SQL_UPDATE_AUX_STATUS_ITEM = """
            UPDATE ap.aux_status_item SET 
                descricao_status_item = ?, flg_inativo = ?
            WHERE id_status_item = ?
            """;
    
    private static final String SQL_DELETE_AUX_STATUS_ITEM = "DELETE FROM ap.aux_status_item WHERE id_status_item = ?";
    
    @Override
    public String getInsertAuxStatusItem() {
        return SQL_INSERT_AUX_STATUS_ITEM;
    }
        
    @Override
    public String getSelectById() {
        return SQL_SELECT_BY_ID;
    }
    
    @Override
    public String getSelectByDescricao() {
        return SQL_SELECT_BY_DESCRICAO;
    }
    
    @Override
    public String getSelectAll() {
        return SQL_SELECT_ALL;
    }
    
    @Override
    public String getUpdateAuxStatusItem() {
        return SQL_UPDATE_AUX_STATUS_ITEM;
    }
    
    @Override
    public String getDeleteAuxStatusItem() {
        return SQL_DELETE_AUX_STATUS_ITEM;
    }
}
