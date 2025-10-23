package com.AchadosPerdidos.API.Presentation.Controller;

import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleDTO;
import com.AchadosPerdidos.API.Application.DTOs.Auxiliares.AuxTipoRoleListDTO;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IAuxTipoRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/aux-tipo-role")
@CrossOrigin(origins = "*")
public class AuxTipoRoleController {

    @Autowired
    private IAuxTipoRoleService auxTipoRoleService;

    @GetMapping
    public ResponseEntity<AuxTipoRoleListDTO> getAllAuxTipoRoles() {
        AuxTipoRoleListDTO auxTipoRoles = auxTipoRoleService.getAllAuxTipoRoles();
        return ResponseEntity.ok(auxTipoRoles);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AuxTipoRoleDTO> getAuxTipoRoleById(@PathVariable int id) {
        AuxTipoRoleDTO auxTipoRole = auxTipoRoleService.getAuxTipoRoleById(id);
        if (auxTipoRole != null) {
            return ResponseEntity.ok(auxTipoRole);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<AuxTipoRoleDTO> createAuxTipoRole(@RequestBody AuxTipoRoleDTO auxTipoRoleDTO) {
        AuxTipoRoleDTO createdAuxTipoRole = auxTipoRoleService.createAuxTipoRole(auxTipoRoleDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdAuxTipoRole);
    }

    @PutMapping("/{id}")
    public ResponseEntity<AuxTipoRoleDTO> updateAuxTipoRole(@PathVariable int id, @RequestBody AuxTipoRoleDTO auxTipoRoleDTO) {
        AuxTipoRoleDTO updatedAuxTipoRole = auxTipoRoleService.updateAuxTipoRole(id, auxTipoRoleDTO);
        if (updatedAuxTipoRole != null) {
            return ResponseEntity.ok(updatedAuxTipoRole);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAuxTipoRole(@PathVariable int id) {
        boolean deleted = auxTipoRoleService.deleteAuxTipoRole(id);
        if (deleted) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/active")
    public ResponseEntity<AuxTipoRoleListDTO> getActiveAuxTipoRoles() {
        AuxTipoRoleListDTO activeAuxTipoRoles = auxTipoRoleService.getActiveAuxTipoRoles();
        return ResponseEntity.ok(activeAuxTipoRoles);
    }
}
