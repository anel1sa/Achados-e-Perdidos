package com.AchadosPerdidos.API.Domain.Repository.Interfaces;

import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import java.util.List;

/**
 * Interface do Repository de Usuários
 * Define os contratos para operações de acesso a dados usando SQL queries
 */
public interface IUsuariosRepository {
    
    /**
     * Inserir novo usuário
     * @param usuario - Entidade do usuário
     * @return ID do usuário inserido
     */
    int inserir(Usuarios usuario);
    
    /**
     * Buscar usuário por ID
     * @param id - ID do usuário
     * @return Usuário encontrado ou null
     */
    Usuarios buscarPorId(int id);
    
    /**
     * Listar todos os usuários
     * @return Lista de usuários
     */
    List<Usuarios> listarTodos();
    
    /**
     * Atualizar usuário
     * @param usuario - Entidade do usuário com dados atualizados
     * @return true se atualizado com sucesso
     */
    boolean atualizar(Usuarios usuario);
    
    /**
     * Deletar usuário permanentemente
     * @param id - ID do usuário
     * @return true se deletado com sucesso
     */
    boolean deletar(int id);
}
