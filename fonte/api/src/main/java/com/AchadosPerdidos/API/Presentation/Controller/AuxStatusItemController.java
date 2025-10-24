package com.AchadosPerdidos.API.Presentation.Controller;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxStatusItemListDTO;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IAuxStatusItemService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/aux-status-item")
@CrossOrigin(origins = "*")
public class AuxStatusItemController {
    
    private final IAuxStatusItemService auxStatusItemService;
    
    public AuxStatusItemController(IAuxStatusItemService auxStatusItemService) {
        this.auxStatusItemService = auxStatusItemService;
    }
    
    @GetMapping("/buscar-descricao/{descricao}")
    public ResponseEntity<AuxStatusItemListDTO> buscarPorDescricao(@PathVariable String descricao) {
        try {
            AuxStatusItemListDTO auxStatusItem = auxStatusItemService.buscarPorDescricao(descricao);
            if (auxStatusItem != null) {
                return ResponseEntity.ok(auxStatusItem);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(null);
        }
    }

    @PostMapping("/criar")  
    public ResponseEntity<AuxStatusItemListDTO> criarAuxStatusItem(@Valid @RequestBody AuxStatusItemDTO dto) {
        try {
            if (dto == null)
            {
                throw new IllegalArgumentException("Corpo da requisição ausente");
            }
            if (dto.getDescricao_Status_Item() == null || dto.getDescricao_Status_Item().trim().isEmpty()) {
                throw new IllegalArgumentException("Descricao_Status_Item é obrigatória");
            }
            AuxStatusItemListDTO auxStatusItemCriado = auxStatusItemService.criarAuxStatusItem(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(auxStatusItemCriado);
        }
        catch (Exception e)
        {
            throw new RuntimeException(String.format("Erro ao criar status de item: %s", e.getMessage()));
        }
    }
    
    @GetMapping("/listar/{id}")
    public ResponseEntity<AuxStatusItemListDTO> buscarAuxStatusItem(@PathVariable int id) {
        try
        {
            if (id <= 0) {
                throw new IllegalArgumentException("Id do Status de Item não encontrado");
            }

            AuxStatusItemListDTO auxStatusItem = auxStatusItemService.buscarPorId(id);
            if (auxStatusItem != null) {
                return ResponseEntity.ok(auxStatusItem);
            }
            return ResponseEntity.notFound().build();
        }
        catch (Exception e)
        {
            throw new RuntimeException(String.format("Erro ao buscar status de item por ID: %s", e.getMessage()));
        }
    }
    
    @GetMapping("/listar")
    public ResponseEntity<List<AuxStatusItemListDTO>> listarTodos() {
        try 
        {
            List<AuxStatusItemListDTO> auxStatusItems = auxStatusItemService.listarTodos();
            return ResponseEntity.ok(auxStatusItems);
        } 
        catch (Exception e) 
        {
            throw new RuntimeException(String.format("Erro ao listar status de item: %s", e.getMessage()));
        }
    }
    
    @PutMapping("/atualizar/{id}")
    public ResponseEntity<AuxStatusItemListDTO> atualizarAuxStatusItem(@PathVariable int id, @Valid @RequestBody AuxStatusItemDTO dto) {
        if (id <= 0) 
        {
            throw new IllegalArgumentException("Id do Status de Item não encontrado");
        }
            try 
            {
                AuxStatusItemListDTO auxStatusItemAtualizado = auxStatusItemService.atualizarAuxStatusItem(id, dto);
                return ResponseEntity.ok(auxStatusItemAtualizado);
            } 
            catch (IllegalArgumentException e)
            {
                throw new RuntimeException(String.format("Erro ao atualizar status de item: %s", e.getMessage()));
            }
    }

    @DeleteMapping("/deletar/{id}")
    public ResponseEntity<Void> deletarAuxStatusItem(@PathVariable int id) {
        if (id <= 0) {
            return ResponseEntity.badRequest().build();
        }
        
        try {
            boolean sucesso = auxStatusItemService.deletarAuxStatusItem(id);
            if (sucesso) {
                return ResponseEntity.ok().build();
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
