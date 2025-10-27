package com.AchadosPerdidos.API.Application.Services.Interfaces;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxLocalItemListDTO;

import java.util.List;


public interface IAuxLocalItemService {
    
    AuxLocalItemListDTO CriarAuxLocalItem(AuxLocalItemDTO dto);
    
    AuxLocalItemListDTO BuscarPorId(int id);
    
    List<AuxLocalItemListDTO> ListarTodos();
    
    AuxLocalItemListDTO AtualizarAuxLocalItem(int id, AuxLocalItemDTO dto);
    
    boolean DeletarAuxLocalItem(int id);
}
