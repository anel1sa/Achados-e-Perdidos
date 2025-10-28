package com.AchadosPerdidos.API.Application.DTOs.Auth;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO de resposta de autenticação")
public class AuthResponseDTO {
    
    @Schema(description = "Token JWT de autenticação", example = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    private String token;
    
    @Schema(description = "Tipo do token", example = "Bearer")
    private String tokenType;
    
    @Schema(description = "Tempo de expiração em segundos", example = "3600")
    private long expiresIn;
    
    @Schema(description = "Informações do usuário autenticado")
    private UserInfoDTO user;
    
    // Getters e Setters
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getTokenType() { return tokenType; }
    public void setTokenType(String tokenType) { this.tokenType = tokenType; }

    public long getExpiresIn() { return expiresIn; }
    public void setExpiresIn(long expiresIn) { this.expiresIn = expiresIn; }

    public UserInfoDTO getUser() { return user; }
    public void setUser(UserInfoDTO user) { this.user = user; }

    @Schema(description = "Informações do usuário")
    public static class UserInfoDTO {
        
        @Schema(description = "ID do usuário", example = "1")
        private int id;
        
        @Schema(description = "Nome do usuário", example = "João Silva")
        private String nome;
        
        @Schema(description = "Email do usuário", example = "joao@ifpr.edu.br")
        private String email;
        
        @Schema(description = "Tipo de role do usuário", example = "Admin")
        private String role;
        
        @Schema(description = "Nome do campus", example = "IFPR - Sede Curitiba")
        private String campus;

        // Getters e Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }

        public String getCampus() { return campus; }
        public void setCampus(String campus) { this.campus = campus; }
    }
}