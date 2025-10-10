package com.AchadosPerdidos.API.Infrastruture.Mysql.Interfaces;

/**
 * Interface para consultas SQL da tabela Usuarios
 * Define os contratos para todas as queries relacionadas a usuários
 */
public interface IUsuariosQueries {
    
    // Inserção
    String getInsertUsuario();
    
    // Busca por id e listagem
    String getSelectById();
    String getSelectAll();
    
    // Atualização
    String getUpdateUsuario();
    
    // Exclusão
    String getDeleteUsuario();
}
