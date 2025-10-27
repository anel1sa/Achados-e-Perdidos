package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensDTO;
import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensListDTO;
import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensCreateDTO;
import com.AchadosPerdidos.API.Application.DTOs.Itens.ItensUpdateDTO;
import com.AchadosPerdidos.API.Application.Mapper.ItensModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IItensService;
import com.AchadosPerdidos.API.Domain.Entity.Itens;
import com.AchadosPerdidos.API.Domain.Repository.ItensRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ItensService implements IItensService {

    @Autowired
    private ItensRepository itensRepository;

    @Autowired
    private ItensModelMapper itensModelMapper;

    @Override
    @Cacheable(value = "itens", key = "'all'")
    public ItensListDTO getAllItens() {
        List<Itens> itens = itensRepository.findAll();
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "#id")
    public ItensDTO getItemById(int id) {
        Itens itens = itensRepository.findById(id);
        return itensModelMapper.toDTO(itens);
    }

    @Override
    @CacheEvict(value = "itens", allEntries = true)
    public ItensDTO createItem(ItensDTO itensDTO) {
        Itens itens = itensModelMapper.toEntity(itensDTO);
        itens.setData_Cadastro(new Date());
        itens.setData_Hora_Item(new Date());
        itens.setFlg_Inativo(false);
        
        Itens savedItens = itensRepository.save(itens);
        return itensModelMapper.toDTO(savedItens);
    }

    @Override
    @CacheEvict(value = "itens", allEntries = true)
    public ItensDTO createItemFromDTO(ItensCreateDTO createDTO) {
        Itens itens = new Itens();
        itens.setNome_Item(createDTO.getNome_Item());
        itens.setDescricao_Item(createDTO.getDescricao_Item());
        itens.setStatus_Item_Id(createDTO.getStatus_Item_Id());
        itens.setLocal_Id(createDTO.getLocal_Id());
        itens.setCampus_Id(createDTO.getCampus_Id());
        itens.setData_Cadastro(new Date());
        itens.setData_Hora_Item(new Date());
        itens.setFlg_Inativo(false);
        
        Itens savedItens = itensRepository.save(itens);
        return itensModelMapper.toDTO(savedItens);
    }

    @Override
    @CacheEvict(value = "itens", allEntries = true)
    public ItensDTO updateItem(int id, ItensDTO itensDTO) {
        Itens existingItens = itensRepository.findById(id);
        if (existingItens == null) {
            return null;
        }
        
        existingItens.setNome_Item(itensDTO.getNome_Item());
        existingItens.setDescricao_Item(itensDTO.getDescricao_Item());
        existingItens.setData_Hora_Item(itensDTO.getData_Hora_Item());
        existingItens.setFlg_Inativo(itensDTO.getFlg_Inativo());
        existingItens.setStatus_Item_Id(itensDTO.getStatus_Item_Id());
        existingItens.setUsuario_Id(itensDTO.getUsuario_Id());
        existingItens.setLocal_Id(itensDTO.getLocal_Id());
        existingItens.setCampus_Id(itensDTO.getCampus_Id());
        existingItens.setId_Empresa(itensDTO.getId_Empresa());
        
        Itens updatedItens = itensRepository.save(existingItens);
        return itensModelMapper.toDTO(updatedItens);
    }

    @Override
    @CacheEvict(value = "itens", allEntries = true)
    public ItensDTO updateItemFromDTO(int id, ItensUpdateDTO updateDTO) {
        Itens existingItens = itensRepository.findById(id);
        if (existingItens == null) {
            return null;
        }
        
        // Atualizar apenas os campos fornecidos
        if (updateDTO.getNome_Item() != null) {
            existingItens.setNome_Item(updateDTO.getNome_Item());
        }
        if (updateDTO.getDescricao_Item() != null) {
            existingItens.setDescricao_Item(updateDTO.getDescricao_Item());
        }
        if (updateDTO.getFlg_Inativo() != null) {
            existingItens.setFlg_Inativo(updateDTO.getFlg_Inativo());
        }
        if (updateDTO.getStatus_Item_Id() > 0) {
            existingItens.setStatus_Item_Id(updateDTO.getStatus_Item_Id());
        }
        if (updateDTO.getLocal_Id() > 0) {
            existingItens.setLocal_Id(updateDTO.getLocal_Id());
        }
        if (updateDTO.getCampus_Id() > 0) {
            existingItens.setCampus_Id(updateDTO.getCampus_Id());
        }
        
        Itens updatedItens = itensRepository.save(existingItens);
        return itensModelMapper.toDTO(updatedItens);
    }

    @Override
    @CacheEvict(value = "itens", allEntries = true)
    public boolean deleteItem(int id) {
        Itens itens = itensRepository.findById(id);
        if (itens == null) {
            return false;
        }
        
        return itensRepository.deleteById(id);
    }

    @Override
    @Cacheable(value = "itens", key = "'active'")
    public ItensListDTO getActiveItens() {
        List<Itens> activeItens = itensRepository.findActive();
        return itensModelMapper.toListDTO(activeItens);
    }

    @Override
    @Cacheable(value = "itens", key = "'status_' + #statusId")
    public ItensListDTO getItensByStatus(int statusId) {
        List<Itens> itens = itensRepository.findByStatus(statusId);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "'user_' + #userId")
    public ItensListDTO getItensByUser(int userId) {
        List<Itens> itens = itensRepository.findByUser(userId);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "'campus_' + #campusId")
    public ItensListDTO getItensByCampus(int campusId) {
        List<Itens> itens = itensRepository.findByCampus(campusId);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "'local_' + #localId")
    public ItensListDTO getItensByLocal(int localId) {
        List<Itens> itens = itensRepository.findByLocal(localId);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "'empresa_' + #empresaId")
    public ItensListDTO getItensByEmpresa(int empresaId) {
        List<Itens> itens = itensRepository.findByEmpresa(empresaId);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    @Cacheable(value = "itens", key = "'search_' + #searchTerm")
    public ItensListDTO searchItens(String searchTerm) {
        List<Itens> itens = itensRepository.searchByTerm(searchTerm);
        return itensModelMapper.toListDTO(itens);
    }

    @Override
    public List<Itens> getItemsNearDonationDeadline(int daysFromNow) {
        return itensRepository.findItemsNearDonationDeadline(daysFromNow);
    }

    @Override
    public List<Itens> getExpiredItems(int daysExpired) {
        return itensRepository.findExpiredItems(daysExpired);
    }

    @Override
    public boolean markItemAsDonated(int itemId) {
        Itens item = itensRepository.findById(itemId);
        if (item != null) {
            // Status 3 = "Doado" (conforme aux_status_item)
            item.setStatus_Item_Id(3);
            itensRepository.save(item);
            return true;
        }
        return false;
    }

    @Override
    public Itens getItemEntityById(int id) {
        return itensRepository.findById(id);
    }
}
