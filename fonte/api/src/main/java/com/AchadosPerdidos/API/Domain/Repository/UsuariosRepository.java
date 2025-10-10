package com.AchadosPerdidos.API.Domain.Repository;

import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import com.AchadosPerdidos.API.Domain.Repository.Interfaces.IUsuariosRepository;
import com.AchadosPerdidos.API.Infrastruture.Mysql.Interfaces.IUsuariosQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

/**
 * Implementação do Repository de Usuários usando JdbcTemplate
 * Similar ao Dapper do .NET - SQL queries diretas
 */
@Repository
public class UsuariosRepository implements IUsuariosRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    private IUsuariosQueries usuariosQueries;
    
    /**
     * RowMapper para converter ResultSet em Usuarios
     */
    private final RowMapper<Usuarios> usuarioRowMapper = new RowMapper<Usuarios>() {
        @Override
        public Usuarios mapRow(ResultSet rs, int rowNum) throws SQLException {
            Usuarios usuario = new Usuarios();
            usuario.setId_Usuario(rs.getInt("Id_Usuario"));
            usuario.setNome_Usuario(rs.getString("Nome_Usuario"));
            usuario.setCPF_Usuario(rs.getString("CPF_Usuario"));
            usuario.setEmail_Usuario(rs.getString("Email_Usuario"));
            usuario.setSenha_Usuario(rs.getString("Senha_Usuario"));
            usuario.setMatricula_Usuario(rs.getString("Matricula_Usuario"));
            usuario.setTelefone_Usuario(rs.getString("Telefone_Usuario"));
            usuario.setData_Cadastro(rs.getTimestamp("Data_Cadastro"));
            usuario.setTipo_Role_Id(rs.getInt("Tipo_Role_Id"));
            usuario.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
            Object fotoItem = rs.getObject("foto_item_id");
            usuario.setFoto_item_id(fotoItem != null ? rs.getInt("foto_item_id") : null);
            Object fotoPerfil = rs.getObject("foto_perfil_usuario");
            usuario.setFoto_perfil_usuario(fotoPerfil != null ? rs.getInt("foto_perfil_usuario") : null);
            Object idInst = rs.getObject("Id_Instituicao");
            usuario.setId_Instituicao(idInst != null ? rs.getInt("Id_Instituicao") : null);
            Object idEmp = rs.getObject("Id_Empresa");
            usuario.setId_Empresa(idEmp != null ? rs.getInt("Id_Empresa") : null);
            Object idCamp = rs.getObject("Id_Campus");
            usuario.setId_Campus(idCamp != null ? rs.getInt("Id_Campus") : null);
            return usuario;
        }
    };
    
    @Override
    public int inserir(Usuarios usuario) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(usuariosQueries.getInsertUsuario(), Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, usuario.getNome_Usuario());
            ps.setString(2, usuario.getCPF_Usuario());
            ps.setString(3, usuario.getEmail_Usuario());
            ps.setString(4, usuario.getSenha_Usuario());
            ps.setString(5, usuario.getMatricula_Usuario());
            ps.setString(6, usuario.getTelefone_Usuario());
            ps.setTimestamp(7, new java.sql.Timestamp(usuario.getData_Cadastro().getTime()));
            ps.setInt(8, usuario.getTipo_Role_Id());
            if (usuario.getFoto_item_id() != null) ps.setInt(9, usuario.getFoto_item_id()); else ps.setNull(9, java.sql.Types.INTEGER);
            if (usuario.getFoto_perfil_usuario() != null) ps.setInt(10, usuario.getFoto_perfil_usuario()); else ps.setNull(10, java.sql.Types.INTEGER);
            ps.setBoolean(11, usuario.getFlg_Inativo() != null ? usuario.getFlg_Inativo() : false);
            if (usuario.getId_Instituicao() != null) ps.setInt(12, usuario.getId_Instituicao()); else ps.setNull(12, java.sql.Types.INTEGER);
            if (usuario.getId_Empresa() != null) ps.setInt(13, usuario.getId_Empresa()); else ps.setNull(13, java.sql.Types.INTEGER);
            if (usuario.getId_Campus() != null) ps.setInt(14, usuario.getId_Campus()); else ps.setNull(14, java.sql.Types.INTEGER);
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().intValue();
    }
    
    @Override
    public Usuarios buscarPorId(int id) {
        List<Usuarios> usuarios = jdbcTemplate.query(usuariosQueries.getSelectById(), usuarioRowMapper, id);
        return usuarios.isEmpty() ? null : usuarios.get(0);
    }
    
    
    @Override
    public List<Usuarios> listarTodos() {
        return jdbcTemplate.query(usuariosQueries.getSelectAll(), usuarioRowMapper);
    }
    
    
    @Override
    public boolean atualizar(Usuarios usuario) {
        int rowsAffected = jdbcTemplate.update(usuariosQueries.getUpdateUsuario(),
            usuario.getNome_Usuario(),
            usuario.getCPF_Usuario(),
            usuario.getEmail_Usuario(),
            usuario.getSenha_Usuario(),
            usuario.getMatricula_Usuario(),
            usuario.getTelefone_Usuario(),
            usuario.getTipo_Role_Id(),
            usuario.getFoto_item_id(),
            usuario.getFoto_perfil_usuario(),
            usuario.getFlg_Inativo(),
            usuario.getId_Instituicao(),
            usuario.getId_Empresa(),
            usuario.getId_Campus(),
            usuario.getId_Usuario()
        );
        
        return rowsAffected > 0;
    }
    
    @Override
    public boolean deletar(int id) {
        int rowsAffected = jdbcTemplate.update(usuariosQueries.getDeleteUsuario(), id);
        return rowsAffected > 0;
    }
    
    
}