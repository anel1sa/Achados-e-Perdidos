package com.AchadosPerdidos.API.Domain.Repository.Interfaces;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Local_Item;

import java.util.List;


public interface IAuxLocalItemRepository {

    int inserir(Aux_Local_Item auxLocalItem);
    
    Aux_Local_Item buscarPorId(int id);

    Aux_Local_Item buscarPorNome(String nome);

    List<Aux_Local_Item> listarTodos();

    boolean atualizar(Aux_Local_Item auxLocalItem);

    boolean deletar(int id);
}
