package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Empresa.EmpresaDTO;
import com.AchadosPerdidos.API.Application.DTOs.Empresa.EmpresaListDTO;
import com.AchadosPerdidos.API.Application.Mapper.EmpresaModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IEmpresaService;
import com.AchadosPerdidos.API.Domain.Entity.Empresa;
import com.AchadosPerdidos.API.Domain.Repository.EmpresaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmpresaService implements IEmpresaService {

    @Autowired
    private EmpresaRepository empresaRepository;

    @Autowired
    private EmpresaModelMapper empresaModelMapper;

    @Override
    public EmpresaListDTO getAllEmpresas() {
        List<Empresa> empresas = empresaRepository.findAll();
        return empresaModelMapper.toListDTO(empresas);
    }

    @Override
    public EmpresaDTO getEmpresaById(int id) {
        Empresa empresa = empresaRepository.findById(id);
        return empresaModelMapper.toDTO(empresa);
    }

    @Override
    public EmpresaDTO createEmpresa(EmpresaDTO empresaDTO) {
        Empresa empresa = empresaModelMapper.toEntity(empresaDTO);
        empresa.setData_Cadastro(new Date());
        empresa.setFlg_Ativo(true);
        
        Empresa savedEmpresa = empresaRepository.save(empresa);
        return empresaModelMapper.toDTO(savedEmpresa);
    }

    @Override
    public EmpresaDTO updateEmpresa(int id, EmpresaDTO empresaDTO) {
        Empresa existingEmpresa = empresaRepository.findById(id);
        if (existingEmpresa == null) {
            return null;
        }
        
        existingEmpresa.setNome_Empresa(empresaDTO.getNome_Empresa());
        existingEmpresa.setCNPJ_Matriz(empresaDTO.getCNPJ_Empresa());
        existingEmpresa.setPais_Sede(empresaDTO.getEndereco_Empresa()); // Mapeando Endereco_Empresa para Pais_Sede
        existingEmpresa.setWebsite(empresaDTO.getEmail_Empresa()); // Mapeando Email_Empresa para Website
        existingEmpresa.setContato_Principal(empresaDTO.getTelefone_Empresa()); // Mapeando Telefone_Empresa para Contato_Principal
        existingEmpresa.setFlg_Ativo(empresaDTO.getFlg_Ativo());
        
        Empresa updatedEmpresa = empresaRepository.save(existingEmpresa);
        return empresaModelMapper.toDTO(updatedEmpresa);
    }

    @Override
    public boolean deleteEmpresa(int id) {
        Empresa empresa = empresaRepository.findById(id);
        if (empresa == null) {
            return false;
        }
        
        return empresaRepository.deleteById(id);
    }

    @Override
    public EmpresaListDTO getActiveEmpresas() {
        List<Empresa> activeEmpresas = empresaRepository.findActive();
        return empresaModelMapper.toListDTO(activeEmpresas);
    }

    @Override
    public EmpresaListDTO getEmpresasByCountry(String paisSede) {
        List<Empresa> empresas = empresaRepository.findByCountry(paisSede);
        return empresaModelMapper.toListDTO(empresas);
    }
}
