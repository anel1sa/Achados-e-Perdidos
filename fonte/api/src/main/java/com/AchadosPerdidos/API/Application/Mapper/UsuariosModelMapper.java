package com.AchadosPerdidos.API.Application.Mapper;
import com.AchadosPerdidos.API.Application.DTOs.UsuariosDTO;
import com.AchadosPerdidos.API.Application.DTOs.UsuariosListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import org.springframework.stereotype.Component;

/**
 * Mapper para conversão entre Entity e DTOs
 * 
 * Vantagens:
 * - Mapeamento direto e eficiente
 * - Controle total sobre a conversão
 * - Fácil de manter e debugar
 * - Spring integrado
 */
@Component
public class UsuariosModelMapper {
    
    /**
     * Converte Entity para DTO
     */
    public UsuariosDTO toDTO(Usuarios entity) {
        if (entity == null) {
            return null;
        }
        
        // Como UsuariosDTO é um record, usamos o construtor diretamente
        return new UsuariosDTO(
            entity.getId_Usuario(),
            entity.getNome_Usuario(),
            entity.getCPF_Usuario(),
            entity.getEmail_Usuario(),
            entity.getSenha_Usuario(),
            entity.getMatricula_Usuario(),
            entity.getTelefone_Usuario(),
            entity.getTipo_Role_Id(),
            entity.getFoto_item_id(),
            entity.getFoto_perfil_usuario(),
            entity.getFlg_Inativo(),
            entity.getId_Instituicao(),
            entity.getId_Empresa(),
            entity.getId_Campus(),
            entity.getData_Cadastro()
        );
    }
    
    /**
     * Converte DTO para Entity
     */
    public Usuarios toEntity(UsuariosDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Usuarios entity = new Usuarios();
        
        // Mapeamento direto dos campos
        entity.setId_Usuario(dto.Id_Usuario());
        entity.setNome_Usuario(dto.Nome_Usuario());
        entity.setCPF_Usuario(dto.CPF_Usuario());
        entity.setEmail_Usuario(dto.Email_Usuario());
        entity.setSenha_Usuario(dto.Senha_Usuario());
        entity.setMatricula_Usuario(dto.Matricula_Usuario());
        entity.setTelefone_Usuario(dto.Telefone_Usuario());
        entity.setTipo_Role_Id(dto.Tipo_Role_Id());
        entity.setFoto_item_id(dto.foto_item_id());
        entity.setFoto_perfil_usuario(dto.foto_perfil_usuario());
        entity.setFlg_Inativo(dto.Flg_Inativo());
        entity.setId_Instituicao(dto.Id_Instituicao());
        entity.setId_Empresa(dto.Id_Empresa());
        entity.setId_Campus(dto.Id_Campus());
        entity.setData_Cadastro(dto.Data_Cadastro());
        
        return entity;
    }

    /**
     * Converte Entity para DTO de listagem (sem senha)
     */
    public UsuariosListDTO toListDTO(Usuarios entity) {
        if (entity == null) {
            return null;
        }

        UsuariosListDTO dto = new UsuariosListDTO();
        dto.setIdUsuario(entity.getId_Usuario());
        dto.setNomeUsuario(entity.getNome_Usuario());
        dto.setCpfUsuario(entity.getCPF_Usuario());
        dto.setEmailUsuario(entity.getEmail_Usuario());
        dto.setMatriculaUsuario(entity.getMatricula_Usuario());
        dto.setTelefoneUsuario(entity.getTelefone_Usuario());
        dto.setTipoRoleId(entity.getTipo_Role_Id());
        dto.setFotoId(entity.getFoto_item_id());
        dto.setFotoPerfilUsuario(entity.getFoto_perfil_usuario());
        dto.setFlgInativo(entity.getFlg_Inativo());
        dto.setInstituicaoPublicaId(entity.getId_Instituicao());
        dto.setInstituicaoPrivadaId(entity.getId_Empresa());
        dto.setCampusId(entity.getId_Campus());
        dto.setDataCadastro(entity.getData_Cadastro());
        return dto;
    }
}
