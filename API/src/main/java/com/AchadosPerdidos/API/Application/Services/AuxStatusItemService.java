package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemListDTO;
import com.AchadosPerdidos.API.Application.Mapper.AuxStatusItemModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IAuxStatusItemService;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Status_Item;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IAuxStatusItemRepository;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AuxStatusItemService implements IAuxStatusItemService {
    
    private final AuxStatusItemModelMapper auxStatusItemMapper;
    private final IAuxStatusItemRepository auxStatusItemRepository;
    
    public AuxStatusItemService(AuxStatusItemModelMapper auxStatusItemMapper, IAuxStatusItemRepository auxStatusItemRepository) {
        this.auxStatusItemMapper = auxStatusItemMapper;
        this.auxStatusItemRepository = auxStatusItemRepository;
    }
    
    @Override
    public AuxStatusItemListDTO criarAuxStatusItem(AuxStatusItemDTO dto) {
        Aux_Status_Item entity = auxStatusItemMapper.toEntity(dto);
        if (entity.getData_Cadastro() == null) {
            entity.setData_Cadastro(new Date());
        }
        if (entity.getFlg_Inativo() == null) {
            entity.setFlg_Inativo(false);
        }
        int idGerado = auxStatusItemRepository.inserir(entity);
        entity.setId_Status_Item(idGerado);
        return auxStatusItemMapper.toListDTO(entity);
    }
    
    @Override
    public AuxStatusItemListDTO buscarPorId(int id) {
        Aux_Status_Item entity = auxStatusItemRepository.buscarPorId(id);
        return entity != null ? auxStatusItemMapper.toListDTO(entity) : null;
    }
    
    @Override
    public AuxStatusItemListDTO buscarPorDescricao(String descricao) {
        Aux_Status_Item entity = auxStatusItemRepository.buscarPorDescricao(descricao);
        return entity != null ? auxStatusItemMapper.toListDTO(entity) : null;
    }
    
    @Override
    public List<AuxStatusItemListDTO> listarTodos() {
        return auxStatusItemRepository.listarTodos().stream()
            .map(auxStatusItemMapper::toListDTO)
            .collect(Collectors.toList());
    }
    
    @Override
    public AuxStatusItemListDTO atualizarAuxStatusItem(int id, AuxStatusItemDTO dto) {
        Aux_Status_Item entityExistente = auxStatusItemRepository.buscarPorId(id);
        
        if (entityExistente == null) {
            throw new RuntimeException("Status de item não encontrado com ID: " + id);
        }
        
        Aux_Status_Item entityAtualizada = auxStatusItemMapper.toEntity(dto);
        
        entityAtualizada.setId_Status_Item(id);
        entityAtualizada.setData_Cadastro(entityExistente.getData_Cadastro());

        if (entityAtualizada.getDescricao_Status_Item() == null) {
            entityAtualizada.setDescricao_Status_Item(entityExistente.getDescricao_Status_Item());
        }
        if (entityAtualizada.getFlg_Inativo() == null) {
            entityAtualizada.setFlg_Inativo(entityExistente.getFlg_Inativo());
        }
        
        boolean sucesso = auxStatusItemRepository.atualizar(entityAtualizada);
        
        if (!sucesso) {
            throw new RuntimeException("Erro ao atualizar status de item");
        }
        
        return auxStatusItemMapper.toListDTO(entityAtualizada);
    }
    
    @Override
    public boolean deletarAuxStatusItem(int id) {
        return auxStatusItemRepository.deletar(id);
    }
}
