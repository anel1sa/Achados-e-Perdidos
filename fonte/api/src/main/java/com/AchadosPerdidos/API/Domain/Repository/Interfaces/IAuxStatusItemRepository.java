package com.AchadosPerdidos.API.Domain.Repository.Interfaces;

import com.AchadosPerdidos.API.Domain.Entity.Aux_Status_Item;

import java.util.List;

public interface IAuxStatusItemRepository {

    int inserir(Aux_Status_Item auxStatusItem);
    
    Aux_Status_Item buscarPorId(int id);

    Aux_Status_Item buscarPorDescricao(String descricao);

    List<Aux_Status_Item> listarTodos();

    boolean atualizar(Aux_Status_Item auxStatusItem);

    boolean deletar(int id);
}
