package com.AchadosPerdidos.API.Application.Services.Interfaces;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemListDTO;

import java.util.List;


public interface IAuxLocalItemService {
    
    AuxLocalItemListDTO criarAuxLocalItem(AuxLocalItemDTO dto);
    
    AuxLocalItemListDTO buscarPorId(int id);
    
    AuxLocalItemListDTO buscarPorNome(String nome);
    
    List<AuxLocalItemListDTO> listarTodos();
    
    AuxLocalItemListDTO atualizarAuxLocalItem(int id, AuxLocalItemDTO dto);
    
    boolean deletarAuxLocalItem(int id);
}
