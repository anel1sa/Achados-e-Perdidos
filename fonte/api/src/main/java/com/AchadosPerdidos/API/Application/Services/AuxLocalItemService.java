package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemListDTO;
import com.AchadosPerdidos.API.Application.Mapper.AuxLocalItemModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IAuxLocalItemService;
import com.AchadosPerdidos.API.Domain.Entity.Aux_Local_Item;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IAuxLocalItemRepository;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AuxLocalItemService implements IAuxLocalItemService {
    
    private final AuxLocalItemModelMapper auxLocalItemMapper;
    private final IAuxLocalItemRepository auxLocalItemRepository;
    
    public AuxLocalItemService(AuxLocalItemModelMapper auxLocalItemMapper, IAuxLocalItemRepository auxLocalItemRepository) {
        this.auxLocalItemMapper = auxLocalItemMapper;
        this.auxLocalItemRepository = auxLocalItemRepository;
    }
    
    @Override
    public AuxLocalItemListDTO CriarAuxLocalItem(AuxLocalItemDTO dto) {
        Aux_Local_Item entity = auxLocalItemMapper.toEntity(dto);
        if (entity.getData_Cadastro_Local_Item() == null) 
        {
            entity.setData_Cadastro_Local_Item(new Date());
            log.info("Criando a data do local do item");
        }

        if (entity.getFlg_Inativo_Local_Item() == null) 
        {
            entity.setFlg_Inativo_Local_Item(false);
            log.info("Definindo o flag de inatividade do local do item como false");
        }
        int idGerado = auxLocalItemRepository.inserir(entity);
        entity.setId_Aux_Local_Item(idGerado);
        return auxLocalItemMapper.toListDTO(entity);
    }
    
    @Override
    public AuxLocalItemListDTO BuscarPorId(int id) {
        Aux_Local_Item entity = auxLocalItemRepository.buscarPorId(id);
        return entity != null ? auxLocalItemMapper.toListDTO(entity) : null;
    }
    
    @Override
    public List<AuxLocalItemListDTO> ListarTodos() {
        return auxLocalItemRepository.listarTodos().stream()
            .map(auxLocalItemMapper::toListDTO)
            .collect(Collectors.toList());
    }
    
    @Override
    public AuxLocalItemListDTO AtualizarAuxLocalItem(int id, AuxLocalItemDTO dto) {
        // Buscar local de item existente
        Aux_Local_Item entityExistente = auxLocalItemRepository.buscarPorId(id);
        
        if (entityExistente == null) {
            throw new RuntimeException("Local de item não encontrado com ID: " + id);
        }
        
        // Converter DTO para Entity
        Aux_Local_Item entityAtualizada = auxLocalItemMapper.toEntity(dto);
        
        // Manter dados que não devem ser alterados
        entityAtualizada.setId_Aux_Local_Item(id);
        entityAtualizada.setData_Cadastro_Local_Item(entityExistente.getData_Cadastro_Local_Item());

        if (entityAtualizada.getNome_Local_Item() == null) {
            entityAtualizada.setNome_Local_Item(entityExistente.getNome_Local_Item());
        }
        if (entityAtualizada.getDescricao_Local_Item() == null) {
            entityAtualizada.setDescricao_Local_Item(entityExistente.getDescricao_Local_Item());
        }
        if (entityAtualizada.getFlg_Inativo_Local_Item() == null) {
            entityAtualizada.setFlg_Inativo_Local_Item(entityExistente.getFlg_Inativo_Local_Item());
        }
        
        // Atualizar no banco usando repository
        boolean sucesso = auxLocalItemRepository.atualizar(entityAtualizada);
        
        if (!sucesso) {
            throw new RuntimeException("Erro ao atualizar local de item");
        }
        
        // Converter Entity para DTO
        return auxLocalItemMapper.toListDTO(entityAtualizada);
    }
    
    @Override
    public boolean DeletarAuxLocalItem(int id) {
        return auxLocalItemRepository.deletar(id);
    }
}