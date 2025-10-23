package com.AchadosPerdidos.API.Application.Mapper;

import com.AchadosPerdidos.API.Application.DTOs.Usuario.UsuariosDTO;
import com.AchadosPerdidos.API.Application.DTOs.Usuario.UsuariosListDTO;
import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class UsuariosModelMapper {

    public UsuariosDTO toDTO(Usuarios usuarios) {
        if (usuarios == null) {
            return null;
        }
        
        UsuariosDTO dto = new UsuariosDTO();
        dto.setId_Usuario(usuarios.getId_Usuario());
        dto.setNome_Usuario(usuarios.getNome_Usuario());
        dto.setCPF_Usuario(usuarios.getCPF_Usuario());
        dto.setEmail_Usuario(usuarios.getEmail_Usuario());
        dto.setSenha_Usuario(usuarios.getSenha_Usuario());
        dto.setMatricula_Usuario(usuarios.getMatricula_Usuario());
        dto.setTelefone_Usuario(usuarios.getTelefone_Usuario());
        dto.setData_Cadastro(usuarios.getData_Cadastro());
        dto.setTipo_Role_Id(usuarios.getTipo_Role_Id());
        dto.setFoto_item_id(usuarios.getFoto_item_id());
        dto.setFoto_perfil_usuario(usuarios.getFoto_perfil_usuario());
        dto.setFlg_Inativo(usuarios.getFlg_Inativo());
        dto.setId_Instituicao(usuarios.getId_Instituicao());
        dto.setId_Empresa(usuarios.getId_Empresa());
        dto.setId_Campus(usuarios.getId_Campus());
        
        return dto;
    }

    public Usuarios toEntity(UsuariosDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Usuarios usuarios = new Usuarios();
        usuarios.setId_Usuario(dto.getId_Usuario());
        usuarios.setNome_Usuario(dto.getNome_Usuario());
        usuarios.setCPF_Usuario(dto.getCPF_Usuario());
        usuarios.setEmail_Usuario(dto.getEmail_Usuario());
        usuarios.setSenha_Usuario(dto.getSenha_Usuario());
        usuarios.setMatricula_Usuario(dto.getMatricula_Usuario());
        usuarios.setTelefone_Usuario(dto.getTelefone_Usuario());
        usuarios.setData_Cadastro(dto.getData_Cadastro());
        usuarios.setTipo_Role_Id(dto.getTipo_Role_Id());
        usuarios.setFoto_item_id(dto.getFoto_item_id());
        usuarios.setFoto_perfil_usuario(dto.getFoto_perfil_usuario());
        usuarios.setFlg_Inativo(dto.getFlg_Inativo());
        usuarios.setId_Instituicao(dto.getId_Instituicao());
        usuarios.setId_Empresa(dto.getId_Empresa());
        usuarios.setId_Campus(dto.getId_Campus());
        
        return usuarios;
    }

    public UsuariosListDTO toListDTO(List<Usuarios> usuarios) {
        if (usuarios == null) {
            return null;
        }
        
        List<UsuariosDTO> dtoList = usuarios.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        
        UsuariosListDTO listDTO = new UsuariosListDTO();
        listDTO.setUsuarios(dtoList);
        listDTO.setTotalCount(dtoList.size());
        
        return listDTO;
    }
}