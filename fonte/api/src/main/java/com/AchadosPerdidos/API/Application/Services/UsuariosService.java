package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.UsuariosDTO;
import com.AchadosPerdidos.API.Application.DTOs.UsuariosListDTO;
import com.AchadosPerdidos.API.Application.Mapper.UsuariosModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IUsuariosService;
import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IUsuariosRepository;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementação do Service de Usuários
 * Contém as regras de negócio para operações com usuários
 */
@Service
public class UsuariosService implements IUsuariosService {
    
    private final UsuariosModelMapper usuariosMapper;
    private final IUsuariosRepository usuariosRepository;
    
    public UsuariosService(UsuariosModelMapper usuariosMapper, IUsuariosRepository usuariosRepository) {
        this.usuariosMapper = usuariosMapper;
        this.usuariosRepository = usuariosRepository;
    }
    
    @Override
    public UsuariosListDTO criarUsuario(UsuariosDTO dto) {

        Usuarios entity = usuariosMapper.toEntity(dto);
        if (entity.getData_Cadastro() == null) {
            entity.setData_Cadastro(new Date());
        }
        if (entity.getFlg_Inativo() == null) {
            entity.setFlg_Inativo(false);
        }
        int idGerado = usuariosRepository.inserir(entity);
        entity.setId_Usuario(idGerado);
        return usuariosMapper.toListDTO(entity);
    }
    
    @Override
    public UsuariosListDTO buscarPorId(int id) {
        Usuarios entity = usuariosRepository.buscarPorId(id);
        return entity != null ? usuariosMapper.toListDTO(entity) : null;
    }
    
    
    @Override
    public List<UsuariosListDTO> listarTodos() {
        return usuariosRepository.listarTodos().stream()
            .map(usuariosMapper::toListDTO)
            .collect(Collectors.toList());
    }
    
    
    @Override
    public UsuariosListDTO atualizarUsuario(int id, UsuariosDTO dto) {
        // Buscar usuário existente
        Usuarios entityExistente = usuariosRepository.buscarPorId(id);
        
        if (entityExistente == null) {
            throw new RuntimeException("Usuário não encontrado com ID: " + id);
        }
        
        // Converter DTO para Entity
        Usuarios entityAtualizada = usuariosMapper.toEntity(dto);
        
        // Manter dados que não devem ser alterados
        entityAtualizada.setId_Usuario(id);
        entityAtualizada.setData_Cadastro(entityExistente.getData_Cadastro());

        if (entityAtualizada.getNome_Usuario() == null) {
            entityAtualizada.setNome_Usuario(entityExistente.getNome_Usuario());
        }
        if (entityAtualizada.getCPF_Usuario() == null) {
            entityAtualizada.setCPF_Usuario(entityExistente.getCPF_Usuario());
        }
        if (entityAtualizada.getEmail_Usuario() == null) {
            entityAtualizada.setEmail_Usuario(entityExistente.getEmail_Usuario());
        }
        if (entityAtualizada.getSenha_Usuario() == null) {
            entityAtualizada.setSenha_Usuario(entityExistente.getSenha_Usuario());
        }
        if (entityAtualizada.getMatricula_Usuario() == null) {
            entityAtualizada.setMatricula_Usuario(entityExistente.getMatricula_Usuario());
        }
        if (entityAtualizada.getTelefone_Usuario() == null) {
            entityAtualizada.setTelefone_Usuario(entityExistente.getTelefone_Usuario());
        }
        if (entityAtualizada.getTipo_Role_Id() <= 0) {
            entityAtualizada.setTipo_Role_Id(entityExistente.getTipo_Role_Id());
        }
        if (entityAtualizada.getFoto_item_id() == null) {
            entityAtualizada.setFoto_item_id(entityExistente.getFoto_item_id());
        }
        if (entityAtualizada.getFoto_perfil_usuario() == null) {
            entityAtualizada.setFoto_perfil_usuario(entityExistente.getFoto_perfil_usuario());
        }
        if (entityAtualizada.getFlg_Inativo() == null) {
            entityAtualizada.setFlg_Inativo(entityExistente.getFlg_Inativo());
        }
        if (entityAtualizada.getId_Instituicao() == null) {
            entityAtualizada.setId_Instituicao(entityExistente.getId_Instituicao());
        }
        if (entityAtualizada.getId_Empresa() == null) {
            entityAtualizada.setId_Empresa(entityExistente.getId_Empresa());
        }
        if (entityAtualizada.getId_Campus() == null) {
            entityAtualizada.setId_Campus(entityExistente.getId_Campus());
        }
        
        // Atualizar no banco usando repository
        boolean sucesso = usuariosRepository.atualizar(entityAtualizada);
        
        if (!sucesso) {
            throw new RuntimeException("Erro ao atualizar usuário");
        }
        
        // Converter Entity para DTO
        return usuariosMapper.toListDTO(entityAtualizada);
    }
    
    @Override
    public boolean deletarUsuario(int id) {
        return usuariosRepository.deletar(id);
    }
}
