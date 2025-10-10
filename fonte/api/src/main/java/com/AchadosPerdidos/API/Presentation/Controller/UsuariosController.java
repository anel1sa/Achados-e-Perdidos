package com.AchadosPerdidos.API.Presentation.Controller;

import com.AchadosPerdidos.API.Application.DTOs.UsuariosDTO;
import com.AchadosPerdidos.API.Application.DTOs.UsuariosListDTO;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IUsuariosService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*") // Permitir CORS para desenvolvimento
public class UsuariosController {
    
    private final IUsuariosService usuariosService;
    
    public UsuariosController(IUsuariosService usuariosService) {
        this.usuariosService = usuariosService;
    }
    
    /**
     * Criar novo usuário
     * @param dto Dados do usuário a ser criado
     * @return Usuário criado com ID gerado
     */
    @PostMapping("/criar")  
    public ResponseEntity<UsuariosListDTO> criarUsuario(@Valid @RequestBody UsuariosDTO dto) {
        try {
            // validações mínimas (CRUD): campos essenciais
            if (dto == null)
            {
                throw new IllegalArgumentException("Corpo da requisição ausente");
            }
            if (dto.Nome_Usuario() == null || dto.Nome_Usuario().trim().isEmpty()) {
                throw new IllegalArgumentException("Nome_Usuario é obrigatório");
            }
            if (dto.Email_Usuario() == null || dto.Email_Usuario().trim().isEmpty()) {
                throw new IllegalArgumentException("Email_Usuario é obrigatório");
            }
            if (dto.Senha_Usuario() == null || dto.Senha_Usuario().trim().isEmpty()) {
                throw new IllegalArgumentException("Senha_Usuario é obrigatória");
            }
            if (dto.Telefone_Usuario() == null || dto.Telefone_Usuario().trim().isEmpty()) {
                throw new IllegalArgumentException("Telefone_Usuario é obrigatório");
            }
            if (dto.Tipo_Role_Id() <= 0) {
                throw new IllegalArgumentException("Tipo_Role_Id deve ser maior que zero");
            }
            UsuariosListDTO usuarioCriado = usuariosService.criarUsuario(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(usuarioCriado);
        }
        catch (Exception e)
        {
            throw new RuntimeException(String.format("Erro ao criar usuário: %s", e.getMessage()));
        }
    }
    
    /**
     * Buscar usuário por ID
     * @param id ID do usuário
     * @return Dados do usuário encontrado
     */
    @GetMapping("/listar/{id}")
    public ResponseEntity<UsuariosListDTO> buscarUsuario(@PathVariable int id) {
        try
        {
            if (id <= 0) {
                throw new IllegalArgumentException("Id do Usuario não encontrado");
            }

            UsuariosListDTO usuario = usuariosService.buscarPorId(id);
            if (usuario != null) {
                return ResponseEntity.ok(usuario);
            }
            return ResponseEntity.notFound().build();
        }
        catch (Exception e)
        {
            throw new RuntimeException(String.format("Erro ao buscar usuário por ID: %s", e.getMessage()));
        }
    }
    
    /**
     * Listar todos os usuários
     * @return Lista de todos os usuários cadastrados
     */
    @GetMapping("/listar")
    public ResponseEntity<List<UsuariosListDTO>> listarTodos() {
        try 
        {
            List<UsuariosListDTO> usuarios = usuariosService.listarTodos();
            return ResponseEntity.ok(usuarios);
        } 
        catch (Exception e) 
        {
            throw new RuntimeException(String.format("Erro ao listar usuários: %s", e.getMessage()));
        }
    }
    
    /**
     * Atualizar usuário existente
     * @param id ID do usuário a ser atualizado
     * @param dto Novos dados do usuário
     * @return Dados do usuário atualizado
     */
    @PutMapping("/atualizar/{id}")
    public ResponseEntity<UsuariosListDTO> atualizarUsuario(@PathVariable int id, @Valid @RequestBody UsuariosDTO dto) {
        if (id <= 0) 
        {
            throw new IllegalArgumentException("Id do Usuario não encontrado");
        }
            try 
            {
                UsuariosListDTO usuarioAtualizado = usuariosService.atualizarUsuario(id, dto);
                return ResponseEntity.ok(usuarioAtualizado);
            } 
            catch (IllegalArgumentException e)
            {
                throw new RuntimeException(String.format("Erro ao atualizar usuário: %s", e.getMessage()));
            }
    }
    
    /**
     * Deletar usuário permanentemente
     * @param id ID do usuário a ser deletado
     * @return Status da operação
     */
    @DeleteMapping("/deletar/{id}")
    public ResponseEntity<Void> deletarUsuario(@PathVariable int id) {
        if (id <= 0) {
            return ResponseEntity.badRequest().build();
        }
        
        try {
            boolean sucesso = usuariosService.deletarUsuario(id);
            if (sucesso) {
                return ResponseEntity.ok().build();
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
