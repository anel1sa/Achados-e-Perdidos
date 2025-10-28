package com.AchadosPerdidos.API.Application.DTOs.Auth;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "DTO para dados do usuário do Google")
public class GoogleUserDTO {
    
    @Schema(description = "ID do usuário no Google", example = "123456789")
    private String id;
    
    @Schema(description = "Email do usuário", example = "joao@gmail.com")
    private String email;
    
    @Schema(description = "Nome do usuário", example = "João Silva")
    private String name;
    
    @Schema(description = "URL da foto de perfil", example = "https://lh3.googleusercontent.com/...")
    private String picture;
    
    @Schema(description = "Email verificado", example = "true")
    private boolean verified_email;

    // Getters e Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }

    public boolean isVerified_email() { return verified_email; }
    public void setVerified_email(boolean verified_email) { this.verified_email = verified_email; }
}