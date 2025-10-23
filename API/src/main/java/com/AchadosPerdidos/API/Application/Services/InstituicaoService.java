package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Application.DTOs.Instituicao.InstituicaoDTO;
import com.AchadosPerdidos.API.Application.DTOs.Instituicao.InstituicaoListDTO;
import com.AchadosPerdidos.API.Application.DTOs.Instituicao.InstituicaoCreateDTO;
import com.AchadosPerdidos.API.Application.DTOs.Instituicao.InstituicaoUpdateDTO;
import com.AchadosPerdidos.API.Application.Mapper.InstituicaoModelMapper;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IInstituicaoService;
import com.AchadosPerdidos.API.Domain.Entity.Instituicao;
import com.AchadosPerdidos.API.Domain.Repository.InstituicaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class InstituicaoService implements IInstituicaoService {

    @Autowired
    private InstituicaoRepository instituicaoRepository;

    @Autowired
    private InstituicaoModelMapper instituicaoModelMapper;

    @Override
    public InstituicaoListDTO getAllInstituicoes() {
        List<Instituicao> instituicoes = instituicaoRepository.findAll();
        return instituicaoModelMapper.toListDTO(instituicoes);
    }

    @Override
    public InstituicaoDTO getInstituicaoById(int id) {
        Instituicao instituicao = instituicaoRepository.findById(id);
        return instituicaoModelMapper.toDTO(instituicao);
    }

    @Override
    public InstituicaoDTO createInstituicao(InstituicaoDTO instituicaoDTO) {
        Instituicao instituicao = instituicaoModelMapper.toEntity(instituicaoDTO);
        instituicao.setData_Cadastro(new Date());
        instituicao.setFlg_Inativo(false);
        
        Instituicao savedInstituicao = instituicaoRepository.save(instituicao);
        return instituicaoModelMapper.toDTO(savedInstituicao);
    }

    @Override
    public InstituicaoDTO createInstituicaoFromDTO(InstituicaoCreateDTO createDTO) {
        Instituicao instituicao = new Instituicao();
        instituicao.setTipo_Instituicao(createDTO.getTipo_Instituicao());
        instituicao.setNome_Instituicao(createDTO.getNome_Instituicao());
        instituicao.setCNPJ_Filial(createDTO.getCNPJ_Filial());
        instituicao.setData_Cadastro(new Date());
        instituicao.setFlg_Inativo(false);
        
        Instituicao savedInstituicao = instituicaoRepository.save(instituicao);
        return instituicaoModelMapper.toDTO(savedInstituicao);
    }

    @Override
    public InstituicaoDTO updateInstituicao(int id, InstituicaoDTO instituicaoDTO) {
        Instituicao existingInstituicao = instituicaoRepository.findById(id);
        if (existingInstituicao == null) {
            return null;
        }
        
        existingInstituicao.setTipo_Instituicao(instituicaoDTO.getTipo_Instituicao());
        existingInstituicao.setNome_Instituicao(instituicaoDTO.getNome_Instituicao());
        existingInstituicao.setCNPJ_Filial(instituicaoDTO.getCNPJ_Filial());
        
        Instituicao updatedInstituicao = instituicaoRepository.save(existingInstituicao);
        return instituicaoModelMapper.toDTO(updatedInstituicao);
    }

    @Override
    public InstituicaoDTO updateInstituicaoFromDTO(int id, InstituicaoUpdateDTO updateDTO) {
        Instituicao existingInstituicao = instituicaoRepository.findById(id);
        if (existingInstituicao == null) {
            return null;
        }
        
        // Atualizar apenas os campos fornecidos
        if (updateDTO.getTipo_Instituicao() != null) {
            existingInstituicao.setTipo_Instituicao(updateDTO.getTipo_Instituicao());
        }
        if (updateDTO.getNome_Instituicao() != null) {
            existingInstituicao.setNome_Instituicao(updateDTO.getNome_Instituicao());
        }
        if (updateDTO.getCNPJ_Filial() != null) {
            existingInstituicao.setCNPJ_Filial(updateDTO.getCNPJ_Filial());
        }
        
        Instituicao updatedInstituicao = instituicaoRepository.save(existingInstituicao);
        return instituicaoModelMapper.toDTO(updatedInstituicao);
    }

    @Override
    public boolean deleteInstituicao(int id) {
        Instituicao instituicao = instituicaoRepository.findById(id);
        if (instituicao == null) {
            return false;
        }
        
        return instituicaoRepository.deleteById(id);
    }

    @Override
    public InstituicaoListDTO getActiveInstituicoes() {
        List<Instituicao> activeInstituicoes = instituicaoRepository.findActive();
        return instituicaoModelMapper.toListDTO(activeInstituicoes);
    }

    @Override
    public InstituicaoListDTO getInstituicoesByType(String tipoInstituicao) {
        List<Instituicao> instituicoes = instituicaoRepository.findByType(tipoInstituicao);
        return instituicaoModelMapper.toListDTO(instituicoes);
    }
}
