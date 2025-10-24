package com.AchadosPerdidos.API.Infrastruture.DataBase;

import com.AchadosPerdidos.API.Domain.Entity.Fotos;
import com.AchadosPerdidos.API.Domain.Enum.Provedor_Armazenamento;
import com.AchadosPerdidos.API.Infrastruture.DataBase.Interfaces.IFotosQueries;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class FotosQueries implements IFotosQueries {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Fotos> rowMapper = new RowMapper<Fotos>() {
        @Override
        public Fotos mapRow(ResultSet rs, int rowNum) throws SQLException {
            Fotos fotos = new Fotos();
            fotos.setId_Foto(rs.getInt("Id_Foto"));
            fotos.setUsuario_Id(rs.getInt("Usuario_Id"));
            fotos.setItem_Id(rs.getInt("Item_Id"));
            fotos.setProvedor_Armazenamento(Provedor_Armazenamento.valueOf(rs.getString("Provedor_Armazenamento")));
            fotos.setNome_Bucket(rs.getString("Nome_Bucket"));
            fotos.setChave_Objeto(rs.getString("Chave_Objeto"));
            fotos.setUrl_Arquivo(rs.getString("Url_Arquivo"));
            fotos.setNome_Original(rs.getString("Nome_Original"));
            fotos.setLargura(rs.getInt("Largura"));
            fotos.setAltura(rs.getInt("Altura"));
            fotos.setPerfil_Usuario(rs.getBoolean("Perfil_Usuario"));
            fotos.setFoto_Item(rs.getBoolean("Foto_Item"));
            fotos.setFlg_Inativo(rs.getBoolean("Flg_Inativo"));
            fotos.setData_Envio(rs.getDate("Data_Envio"));
            fotos.setData_Exclusao(rs.getDate("Data_Exclusao"));
            fotos.setData_Atualizacao(rs.getDate("Data_Atualizacao"));
            return fotos;
        }
    };

    @Override
    public List<Fotos> findAll() {
        String sql = "SELECT * FROM Fotos ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public Fotos findById(int id) {
        String sql = "SELECT * FROM Fotos WHERE Id_Foto = ?";
        List<Fotos> fotos = jdbcTemplate.query(sql, rowMapper, id);
        return fotos.isEmpty() ? null : fotos.get(0);
    }

    @Override
    public Fotos insert(Fotos fotos) {
        String sql = "INSERT INTO Fotos (Usuario_Id, Item_Id, Provedor_Armazenamento, Nome_Bucket, Chave_Objeto, Url_Arquivo, Nome_Original, Largura, Altura, Perfil_Usuario, Foto_Item, Flg_Inativo, Data_Envio, Data_Exclusao, Data_Atualizacao) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            fotos.getUsuario_Id(),
            fotos.getItem_Id(),
            fotos.getProvedor_Armazenamento(),
            fotos.getNome_Bucket(),
            fotos.getChave_Objeto(),
            fotos.getUrl_Arquivo(),
            fotos.getNome_Original(),
            fotos.getLargura(),
            fotos.getAltura(),
            fotos.getPerfil_Usuario(),
            fotos.getFoto_Item(),
            fotos.getFlg_Inativo(),
            fotos.getData_Envio(),
            fotos.getData_Exclusao(),
            fotos.getData_Atualizacao());
        
        // Buscar o registro inserido para retornar com o ID
        String selectSql = "SELECT * FROM Fotos WHERE Url_Arquivo = ? AND Data_Envio = ? ORDER BY Id_Foto DESC LIMIT 1";
        List<Fotos> inserted = jdbcTemplate.query(selectSql, rowMapper, 
            fotos.getUrl_Arquivo(), 
            fotos.getData_Envio());
        
        return inserted.isEmpty() ? null : inserted.get(0);
    }

    @Override
    public Fotos update(Fotos fotos) {
        String sql = "UPDATE Fotos SET Usuario_Id = ?, Item_Id = ?, Provedor_Armazenamento = ?, Nome_Bucket = ?, Chave_Objeto = ?, Url_Arquivo = ?, Nome_Original = ?, Largura = ?, Altura = ?, Perfil_Usuario = ?, Foto_Item = ?, Flg_Inativo = ?, Data_Exclusao = ?, Data_Atualizacao = ? WHERE Id_Foto = ?";
        jdbcTemplate.update(sql, 
            fotos.getUsuario_Id(),
            fotos.getItem_Id(),
            fotos.getProvedor_Armazenamento(),
            fotos.getNome_Bucket(),
            fotos.getChave_Objeto(),
            fotos.getUrl_Arquivo(),
            fotos.getNome_Original(),
            fotos.getLargura(),
            fotos.getAltura(),
            fotos.getPerfil_Usuario(),
            fotos.getFoto_Item(),
            fotos.getFlg_Inativo(),
            fotos.getData_Exclusao(),
            fotos.getData_Atualizacao(),
            fotos.getId_Foto());
        
        return findById(fotos.getId_Foto());
    }

    @Override
    public boolean deleteById(int id) {
        String sql = "DELETE FROM Fotos WHERE Id_Foto = ?";
        int rowsAffected = jdbcTemplate.update(sql, id);
        return rowsAffected > 0;
    }

    @Override
    public List<Fotos> findActive() {
        String sql = "SELECT * FROM Fotos WHERE Flg_Inativo = false ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Fotos> findByUser(int userId) {
        String sql = "SELECT * FROM Fotos WHERE Usuario_Id = ? ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    @Override
    public List<Fotos> findByItem(int itemId) {
        String sql = "SELECT * FROM Fotos WHERE Item_Id = ? ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper, itemId);
    }

    @Override
    public List<Fotos> findProfilePhotos(int userId) {
        String sql = "SELECT * FROM Fotos WHERE Usuario_Id = ? AND Perfil_Usuario = true ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    @Override
    public List<Fotos> findItemPhotos(int itemId) {
        String sql = "SELECT * FROM Fotos WHERE Item_Id = ? AND Foto_Item = true ORDER BY Data_Envio DESC";
        return jdbcTemplate.query(sql, rowMapper, itemId);
    }

    @Override
    public Fotos findMainItemPhoto(int itemId) {
        String sql = "SELECT * FROM Fotos WHERE Item_Id = ? AND Foto_Item = true AND Flg_Inativo = false ORDER BY Data_Envio DESC LIMIT 1";
        List<Fotos> fotos = jdbcTemplate.query(sql, rowMapper, itemId);
        return fotos.isEmpty() ? null : fotos.get(0);
    }

    @Override
    public Fotos findProfilePhoto(int userId) {
        String sql = "SELECT * FROM Fotos WHERE Usuario_Id = ? AND Perfil_Usuario = true AND Flg_Inativo = false ORDER BY Data_Envio DESC LIMIT 1";
        List<Fotos> fotos = jdbcTemplate.query(sql, rowMapper, userId);
        return fotos.isEmpty() ? null : fotos.get(0);
    }
}
