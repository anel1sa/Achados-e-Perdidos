package com.AchadosPerdidos.API.Infrastruture.Mysql;

import com.AchadosPerdidos.API.Infrastruture.Mysql.Interfaces.IUsuariosQueries;
import org.springframework.stereotype.Component;

/**
 * Implementação das consultas SQL para a tabela Usuarios
 * Centraliza as queries para facilitar manutenção e reutilização
 */
@Component
public class UsuariosQueries implements IUsuariosQueries {
    
    private static final String SQL_INSERT_USUARIO = """
            INSERT INTO Usuarios (
                Nome_Usuario, CPF_Usuario, Email_Usuario, Senha_Usuario,
                Matricula_Usuario, Telefone_Usuario, Data_Cadastro,
                Tipo_Role_Id, foto_item_id, foto_perfil_usuario, Flg_Inativo,
                Id_Instituicao, Id_Empresa, Id_Campus
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
    
    private static final String SQL_SELECT_BY_ID = """
            SELECT * FROM Usuarios WHERE Id_Usuario = ?
            """;

    private static final String SQL_SELECT_ALL = """
            SELECT * FROM Usuarios ORDER BY Nome_Usuario
            """;

    private static final String SQL_UPDATE_USUARIO = """
            UPDATE Usuarios SET 
                Nome_Usuario = ?, CPF_Usuario = ?, Email_Usuario = ?, 
                Senha_Usuario = ?, Matricula_Usuario = ?, Telefone_Usuario = ?, 
                Tipo_Role_Id = ?, foto_item_id = ?, foto_perfil_usuario = ?, Flg_Inativo = ?, 
                Id_Instituicao = ?, Id_Empresa = ?, Id_Campus = ?
            WHERE Id_Usuario = ?
            """;
    
    private static final String SQL_DELETE_USUARIO = "DELETE FROM Usuarios WHERE Id_Usuario = ?";
    
    
    @Override
    public String getInsertUsuario() {
        return SQL_INSERT_USUARIO;
    }
        
    @Override
    public String getSelectById() {
        return SQL_SELECT_BY_ID;
    }
    
    @Override
    public String getSelectAll() {
        return SQL_SELECT_ALL;
    }
    
    @Override
    public String getUpdateUsuario() {
        return SQL_UPDATE_USUARIO;
    }
    
    @Override
    public String getDeleteUsuario() {
        return SQL_DELETE_USUARIO;
    }
}