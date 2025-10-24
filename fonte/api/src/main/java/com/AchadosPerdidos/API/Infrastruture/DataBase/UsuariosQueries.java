package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Usuarios;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IUsuariosQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UsuariosQueries implements IUsuariosQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Usuarios> rowMapper = (rs, _) -> {
        Usuarios usuarios = new Usuarios();
        usuarios.setId_Usuario(rs.getInt("id_usuario"));
        usuarios.setNome_Usuario(rs.getString("nome_usuario"));
        usuarios.setCPF_Usuario(rs.getString("cpf_usuario"));
        usuarios.setEmail_Usuario(rs.getString("email_usuario"));
        usuarios.setSenha_Usuario(rs.getString("senha_usuario"));
        usuarios.setMatricula_Usuario(rs.getString("matricula_usuario"));
        usuarios.setTelefone_Usuario(rs.getString("telefone_usuario"));
        usuarios.setData_Cadastro(rs.getDate("data_cadastro"));
        usuarios.setTipo_Role_Id(rs.getInt("tipo_role_id"));
        usuarios.setFoto_item_id(rs.getInt("foto_item_id"));
        usuarios.setFoto_perfil_usuario(rs.getInt("foto_perfil_usuario"));
        usuarios.setFlg_Inativo(rs.getBoolean("flg_inativo"));
        usuarios.setId_Instituicao(rs.getInt("id_instituicao"));
        usuarios.setId_Empresa(rs.getInt("id_empresa"));
        usuarios.setId_Campus(rs.getInt("id_campus"));
        return usuarios;
    };

    @Override
    public List<Usuarios> findAll() {
        String sql = "SELECT * FROM ap.usuarios ORDER BY nome_usuario";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Usuarios findById(int id) {
        String sql = "SELECT * FROM ap.usuarios WHERE id_usuario = ?";
        List<Usuarios> usuarios = jdbcTemplate.query(sql, rowMapper, id);
        return usuarios.isEmpty() ? null : usuarios.get(0);
    }

    @Override
    public Usuarios findByEmail(String email) {
        String sql = "SELECT * FROM ap.usuarios WHERE email_usuario = ?";
        List<Usuarios> usuarios = jdbcTemplate.query(sql, rowMapper, email);
        return usuarios.isEmpty() ? null : usuarios.get(0);
    }

    @Override
    public Usuarios findByEmailAndPassword(String email, String senha) {
        String sql = "SELECT * FROM ap.usuarios WHERE email_usuario = ? AND senha_usuario = ?";
        List<Usuarios> usuarios = jdbcTemplate.query(sql, rowMapper, email, senha);
        return usuarios.isEmpty() ? null : usuarios.get(0);
    }

    @Override
    public Usuarios insert(Usuarios usuarios) {
        String sql = "INSERT INTO ap.usuarios (nome_usuario, cpf_usuario, email_usuario, senha_usuario, matricula_usuario, telefone_usuario, data_cadastro, tipo_role_id, foto_item_id, foto_perfil_usuario, flg_inativo, id_instituicao, id_empresa, id_campus) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            usuarios.getNome_Usuario(),
            usuarios.getCPF_Usuario(),
            usuarios.getEmail_Usuario(),
            usuarios.getSenha_Usuario(),
            usuarios.getMatricula_Usuario(),
            usuarios.getTelefone_Usuario(),
            usuarios.getData_Cadastro(),
            usuarios.getTipo_Role_Id(),
            usuarios.getFoto_item_id(),
            usuarios.getFoto_perfil_usuario(),
            usuarios.getFlg_Inativo(),
            usuarios.getId_Instituicao(),
            usuarios.getId_Empresa(),
            usuarios.getId_Campus());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM ap.usuarios WHERE email_usuario = ? AND data_cadastro = ? ORDER BY id_usuario DESC LIMIT 1";
        List<Usuarios> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            usuarios.getEmail_Usuario(), 
            usuarios.getData_Cadastro());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Usuarios update(Usuarios usuarios) {
        String sql = "UPDATE ap.usuarios SET nome_usuario = ?, cpf_usuario = ?, email_usuario = ?, senha_usuario = ?, matricula_usuario = ?, telefone_usuario = ?, tipo_role_id = ?, foto_item_id = ?, foto_perfil_usuario = ?, flg_inativo = ?, id_instituicao = ?, id_empresa = ?, id_campus = ? WHERE id_usuario = ?";
        jdbcTemplate.update(sql, 
            usuarios.getNome_Usuario(),
            usuarios.getCPF_Usuario(),
            usuarios.getEmail_Usuario(),
            usuarios.getSenha_Usuario(),
            usuarios.getMatricula_Usuario(),
            usuarios.getTelefone_Usuario(),
            usuarios.getTipo_Role_Id(),
            usuarios.getFoto_item_id(),
            usuarios.getFoto_perfil_usuario(),
            usuarios.getFlg_Inativo(),
            usuarios.getId_Instituicao(),
            usuarios.getId_Empresa(),
            usuarios.getId_Campus(),
            usuarios.getId_Usuario());
        
        return findById(usuarios.getId_Usuario());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM ap.usuarios WHERE id_usuario = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Usuarios> findActive() {
        String sql = "SELECT * FROM ap.usuarios WHERE flg_inativo = false ORDER BY nome_usuario";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Usuarios> findByRole(int tipoRoleId) {
        String sql = "SELECT * FROM ap.usuarios WHERE tipo_role_id = ? ORDER BY nome_usuario";
        return jdbcTemplate.query(sql, rowMapper, tipoRoleId);
    }

    @Override
    public List<Usuarios> findByInstitution(int instituicaoId) {
        String sql = "SELECT * FROM ap.usuarios WHERE id_instituicao = ? ORDER BY nome_usuario";
        return jdbcTemplate.query(sql, rowMapper, instituicaoId);
    }

    @Override
    public List<Usuarios> findByCampus(int campusId) {
        String sql = "SELECT * FROM ap.usuarios WHERE id_campus = ? ORDER BY nome_usuario";
        return jdbcTemplate.query(sql, rowMapper, campusId);
    }
}