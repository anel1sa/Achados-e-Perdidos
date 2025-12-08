# 📋 Plano de Migração para Nova API

> **Data de Análise:** 05 de Dezembro de 2025  
> **Status:** Em Planejamento  
> **Branch:** Feature/implementando-nova-arquitetura

---

## 📊 Visão Geral

Este documento detalha as mudanças necessárias para adequar o aplicativo Flutter à nova estrutura da API (`https://api-achadosperdidos.com.br`).

### Estatísticas da Migração

| Categoria | Quantidade |
|-----------|------------|
| **Rotas a Adequar** | ~35 endpoints |
| **Rotas a Criar no Backend** | ~6 endpoints |
| **Novos Endpoints Disponíveis** | ~50 endpoints |
| **Novas Entidades** | 7 entidades |
| **DTOs a Refatorar** | ~15 DTOs |

---

## 🔴 PRIORIDADE ALTA - Rotas Críticas

### 1. 🔐 Autenticação

#### Mudanças Obrigatórias

| Status | Rota Atual | Nova Rota | Ação |
|--------|-----------|-----------|------|
| ⚠️ | `POST /api/usuarios/login` | `POST /api/auth/login` | **MIGRAR** |
| ⚠️ | `POST /api/google-auth/login` | `GET /api/auth/google/login` | **MIGRAR** |
| ⚠️ | `GET /api/google-auth/callback` | `GET /api/auth/google/callback` | **MIGRAR** |
| 🆕 | - | `POST /api/auth/logout` | **IMPLEMENTAR** |
| 🆕 | - | `POST /api/auth/redefinir-senha` | **IMPLEMENTAR** |
| 🆕 | - | `GET /api/auth/validate` | **IMPLEMENTAR** |

#### Mudanças nos DTOs

**LoginRequestDTO** - Campos Alterados:
```dart
// ❌ ANTES
class LoginRequestDTO {
  final String email;
  final String senha;
}

// ✅ DEPOIS
class LoginRequestDTO {
  final String Email_Usuario;      // Mudou o nome
  final String Senha_Hash;         // Mudou o nome
  final String? Device_Token;      // 🆕 NOVO - Para push notifications
  final String? Plataforma;        // 🆕 NOVO - "ANDROID" ou "IOS"
}
```

**TokenResponseDTO** - Simplificado:
```dart
// ❌ ANTES
class TokenResponseDTO {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
}

// ✅ DEPOIS
class TokenResponseDTO {
  final String token;  // Apenas o token JWT
}
```

#### Arquivos Impactados
- [ ] `lib/data/datasources/auth_remote_datasource.dart`
- [ ] `lib/data/datasources/google_auth_remote_datasource.dart`
- [ ] `lib/data/DTOs/auth_dto.dart`
- [ ] `lib/data/DTOs/login_request_dto.dart`
- [ ] `lib/core/constants/api_constants.dart`
- [ ] `lib/presentation/pages/login_page.dart`

---

### 2. 👤 Usuários

#### Mudanças Estruturais

| Status | Rota Atual | Nova Rota | Ação |
|--------|-----------|-----------|------|
| ❌ | `POST /api/usuarios` | - | **REMOVER** |
| 🆕 | - | `POST /api/usuarios/aluno` | **IMPLEMENTAR** |
| 🆕 | - | `POST /api/usuarios/servidor` | **IMPLEMENTAR** |
| ❌ | `POST /api/usuarios/{id}/alterar-senha` | - | **REMOVER** (usar `/api/auth/redefinir-senha`) |
| ✅ | `GET /api/usuarios` | `GET /api/usuarios` | **MANTER** |
| ✅ | `GET /api/usuarios/active` | `GET /api/usuarios/active` | **MANTER** |
| ✅ | `GET /api/usuarios/{id}` | `GET /api/usuarios/{id}` | **MANTER** |
| ✅ | `PUT /api/usuarios/{id}` | `PUT /api/usuarios/{id}` | **MANTER** |
| ✅ | `DELETE /api/usuarios/{id}` | `DELETE /api/usuarios/{id}` | **MANTER** |

#### Mudanças nos DTOs

**UsuariosDTO** - Campos Adicionados/Removidos:
```dart
// ❌ CAMPOS REMOVIDOS
// final String? hashSenha;
// final String? numeroTelefone;
// final int? empresaId;

// ✅ CAMPOS NOVOS
class UsuariosDTO {
  // ... campos existentes ...
  final List<CampusDTO> campus;          // 🆕 NOVO - Lista de campus do usuário
  final FotosDTO? fotoPerfil;            // 🆕 NOVO - Foto de perfil
}
```

**UsuariosCreateDTO** - Campos Alterados:
```dart
// ❌ ANTES
class UsuariosCreateDTO {
  final String nome;
  final String email;
  final String senha;
  final String? cpf;
  final String? matricula;
  final int? empresaId;           // ❌ REMOVIDO
  final int? campusId;
}

// ✅ DEPOIS
class UsuariosCreateDTO {
  final String nome;
  final String email;
  final String senha;
  final String? cpf;
  final String? matricula;
  final int campusId;             // ✅ AGORA É OBRIGATÓRIO
}
```

**🆕 AlunoCreateDTO** - Novo DTO Específico:
```dart
class AlunoCreateDTO {
  final String nome;
  final String email;
  final String senha;
  final String matricula;        // Obrigatório para alunos
  final int campusId;
  // ❌ NÃO TEM CPF
}
```

**🆕 ServidorCreateDTO** - Novo DTO Específico:
```dart
class ServidorCreateDTO {
  final String nome;
  final String email;
  final String senha;
  final String cpf;              // Obrigatório para servidores
  final int campusId;
  // ❌ NÃO TEM MATRÍCULA
}
```

#### Arquivos Impactados
- [ ] `lib/data/datasources/usuario_remote_datasource.dart`
- [ ] `lib/data/DTOs/usuario_dto.dart`
- [ ] `lib/data/DTOs/usuario_create_dto.dart`
- [ ] `lib/data/DTOs/aluno_create_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/servidor_create_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/usuario_service.dart`
- [ ] `lib/presentation/pages/cadastro_usuario_page.dart` - **AJUSTAR** (separar cadastro aluno/servidor)

---

### 3. 📦 Itens

#### Mudanças de Endpoints

| Status | Rota Atual | Nova Rota | Ação |
|--------|-----------|-----------|------|
| ✅ | `GET /api/itens` | `GET /api/itens` | **MANTER** |
| ✅ | `GET /api/itens/{id}` | `GET /api/itens/{id}` | **MANTER** |
| ⚠️ | `PUT /api/itens/{id}` | `PUT /api/itens/update/{id}` | **MIGRAR** |
| ⚠️ | `DELETE /api/itens/{id}` | `DELETE /api/itens/delete/{id}` | **MIGRAR** |
| ❌ | `POST /api/itens` | - | **REMOVER** |
| 🆕 | - | `POST /api/itens/perdidos` | **IMPLEMENTAR** |
| 🆕 | - | `POST /api/itens/achados` | **IMPLEMENTAR** (multipart obrigatório) |
| ❌ | `GET /api/itens/empresa/{empresaId}` | - | **REMOVER OU CRIAR NO BACKEND** |
| ❌ | `GET /api/itens/user/{userId}` | - | **REMOVER OU CRIAR NO BACKEND** |

#### Mudanças nos DTOs

**ItemDTO** - Campos Alterados:
```dart
// ❌ CAMPOS REMOVIDOS
// final int? statusItemId;
// final int? localId;
// final DateTime? encontradoEm;

// ✅ CAMPOS NOVOS
class ItemDTO {
  final int id;
  final String nome;
  final String descricao;
  final String tipoItem;              // 🆕 NOVO - "ACHADO" ou "PERDIDO"
  final String descLocalItem;         // 🆕 NOVO - Descrição textual do local
  final int usuarioRelatorId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
  final List<FotosDTO> fotos;         // 🆕 NOVO - Lista de fotos do item
}
```

**ItemCreateDTO** - Simplificado:
```dart
// ❌ ANTES
class ItemCreateDTO {
  final String nome;
  final String descricao;
  final int statusItemId;
  final int localId;
  final DateTime? encontradoEm;
  final int usuarioRelatorId;
  final List<FotosCreateDTO>? fotos;
}

// ✅ DEPOIS
class ItemCreateDTO {
  final String nome;
  final String descricao;
  final String tipoItem;              // "ACHADO" ou "PERDIDO"
  final String descLocalItem;         // Texto livre
  final int usuarioRelatorId;
  // Fotos são enviadas separadamente via multipart
}
```

**🆕 ItemUpdateDTO** - Novo DTO:
```dart
class ItemUpdateDTO {
  final String? nome;
  final String? descricao;
  final String? tipoItem;
  final String? descLocalItem;
}
```

#### Upload de Fotos para Itens

**Itens Perdidos** (`POST /api/itens/perdidos`):
- ✅ Aceita JSON ou multipart
- ✅ Fotos são **opcionais**
- ✅ Content-Type: `application/json` ou `multipart/form-data`

**Itens Achados** (`POST /api/itens/achados`):
- ⚠️ **OBRIGATÓRIO** multipart
- ⚠️ Fotos são **obrigatórias**
- ⚠️ Content-Type: `multipart/form-data`

```dart
// Exemplo de uso
FormData formData = FormData.fromMap({
  'nome': 'Mochila preta',
  'descricao': 'Mochila encontrada no laboratório',
  'tipoItem': 'ACHADO',
  'descLocalItem': 'Laboratório de informática, bloco A',
  'usuarioRelatorId': userId,
  'fotos': [
    await MultipartFile.fromFile(foto1Path, filename: 'foto1.jpg'),
    await MultipartFile.fromFile(foto2Path, filename: 'foto2.jpg'),
  ],
});
```

#### Arquivos Impactados
- [ ] `lib/data/datasources/item_remote_datasource.dart`
- [ ] `lib/data/DTOs/item_dto.dart`
- [ ] `lib/data/DTOs/item_create_dto.dart`
- [ ] `lib/data/DTOs/item_update_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/item_service.dart`
- [ ] `lib/presentation/pages/cadastro_item_achado_page.dart`
- [ ] `lib/presentation/pages/cadastro_item_perdido_page.dart`
- [ ] `lib/presentation/pages/achados_page.dart`
- [ ] `lib/presentation/pages/perdidos_page.dart`

---

### 4. 📸 Fotos - Sistema Completamente Novo

#### Novos Endpoints de Upload

| Status | Endpoint | Descrição | Params |
|--------|----------|-----------|--------|
| 🆕 | `POST /api/fotos/upload` | Upload genérico | `file`, `userId` |
| 🆕 | `POST /api/fotos/upload/profile` | Upload de perfil | `file`, `userId` |
| ✅ | `POST /api/fotos/upload/item` | Upload de item | `file`, `userId`, `itemId` |
| 🆕 | `GET /api/fotos/download/{id}` | Download de foto | `id` |

#### Novos Endpoints CRUD de Fotos

| Status | Endpoint | Descrição |
|--------|----------|-----------|
| 🆕 | `GET /api/fotos` | Listar todas as fotos |
| 🆕 | `GET /api/fotos/active` | Listar fotos ativas |
| 🆕 | `GET /api/fotos/{id}` | Buscar foto por ID |
| 🆕 | `PUT /api/fotos/{id}` | Atualizar foto |
| 🆕 | `DELETE /api/fotos/{id}` | Soft delete |
| 🆕 | `DELETE /api/fotos/delete/{id}` | Hard delete |

#### Novos Endpoints de Relacionamento Foto-Item

| Status | Endpoint | Descrição |
|--------|----------|-----------|
| 🆕 | `GET /api/fotos-item` | Listar todos os relacionamentos |
| 🆕 | `GET /api/fotos-item/active` | Listar relacionamentos ativos |
| 🆕 | `GET /api/fotos-item/{id}` | Buscar relacionamento por ID |
| 🆕 | `POST /api/fotos-item` | Criar relacionamento |
| 🆕 | `PUT /api/fotos-item/{id}` | Atualizar relacionamento |
| 🆕 | `DELETE /api/fotos-item/{id}` | Soft delete |
| 🆕 | `DELETE /api/fotos-item/delete/{id}` | Hard delete |

#### Novos Endpoints de Relacionamento Foto-Usuário

| Status | Endpoint | Descrição |
|--------|----------|-----------|
| 🆕 | `GET /api/fotos-usuario` | Listar todos os relacionamentos |
| 🆕 | `GET /api/fotos-usuario/active` | Listar relacionamentos ativos |
| 🆕 | `GET /api/fotos-usuario/{id}` | Buscar relacionamento por ID |
| 🆕 | `POST /api/fotos-usuario` | Criar relacionamento |
| 🆕 | `PUT /api/fotos-usuario/{id}` | Atualizar relacionamento |
| 🆕 | `DELETE /api/fotos-usuario/{id}` | Soft delete |
| 🆕 | `DELETE /api/fotos-usuario/delete/{id}` | Hard delete |

#### Novos DTOs de Fotos

**FotosDTO** - Estrutura Completa:
```dart
class FotosDTO {
  final int id;
  final String url;
  final String provedorArmazenamento;    // Ex: "AWS_S3", "LOCAL"
  final String chaveArmazenamento;       // Path no S3
  final String nomeArquivoOriginal;
  final int tamanhoArquivoBytes;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

**🆕 FotoItemDTO** - Relacionamento Foto-Item:
```dart
class FotoItemDTO {
  final int id;
  final int fotoId;
  final int itemId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

**🆕 FotoUsuarioDTO** - Relacionamento Foto-Usuário:
```dart
class FotoUsuarioDTO {
  final int id;
  final int fotoId;
  final int usuarioId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

**🆕 FotoItemListDTO** - Lista de Relacionamentos:
```dart
class FotoItemListDTO {
  final List<FotoItemDTO> fotosItem;
  final int totalCount;
}
```

**🆕 FotoUsuarioListDTO** - Lista de Relacionamentos:
```dart
class FotoUsuarioListDTO {
  final List<FotoUsuarioDTO> fotosUsuario;
  final int totalCount;
}
```

#### Arquivos Impactados
- [ ] `lib/data/datasources/foto_remote_datasource.dart` - **EXPANDIR**
- [ ] `lib/data/DTOs/foto_dto.dart` - **AJUSTAR**
- [ ] `lib/data/DTOs/foto_item_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/foto_usuario_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/foto_item_list_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/foto_usuario_list_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/foto_service.dart` - **EXPANDIR**
- [ ] `lib/core/constants/api_constants.dart` - **ADICIONAR ENDPOINTS**

---

## 🟡 PRIORIDADE MÉDIA - Melhorias

### 5. 💬 Chat

#### Endpoints Removidos (Decidir se Mantém)

| Status | Endpoint | Ação Recomendada |
|--------|----------|------------------|
| ❌ | `GET /api/chat/messages/{chatId}` | Verificar uso e remover ou solicitar recriação |
| ❌ | `GET /api/chat/message/{messageId}` | Verificar uso e remover ou solicitar recriação |
| ❌ | `GET /api/chat/count/{chatId}` | Verificar uso e remover ou solicitar recriação |
| ❌ | `GET /api/chat/chats/{userId}` | Verificar uso e remover ou solicitar recriação |
| ❌ | `GET /api/chat/unread/{userId}` | Verificar uso e remover ou solicitar recriação |

#### Novos Endpoints Disponíveis

| Status | Endpoint | Descrição |
|--------|----------|-----------|
| 🆕 | `GET /api/chat/all` | Listar todas as mensagens |
| 🆕 | `PUT /api/chat/mark-unread` | Marcar mensagem como não lida |

#### Endpoints Mantidos

| Status | Endpoint | Status |
|--------|----------|--------|
| ✅ | `POST /api/chat/send` | **MANTER** |
| ✅ | `POST /api/chat/private` | **MANTER** |
| ✅ | `GET /api/chat/messages/users/{userId1}/{userId2}` | **MANTER** |
| ✅ | `PUT /api/chat/mark-read` | **MANTER** |
| ✅ | `POST /api/chat/typing` | **MANTER** |
| ✅ | `POST /api/chat/stop-typing` | **MANTER** |
| ✅ | `POST /api/chat/online` | **MANTER** |
| ✅ | `POST /api/chat/offline` | **MANTER** |

#### Arquivos Impactados
- [ ] `lib/data/datasources/chat_remote_datasource.dart`
- [ ] `lib/data/services/chat_service.dart`
- [ ] `lib/presentation/pages/chat_page.dart`

---

### 6. 📱 Device Tokens

#### Mudanças de Endpoints

| Status | Rota Atual | Nova Rota | Ação |
|--------|-----------|-----------|------|
| ❌ | `POST /api/device-tokens/register` | - | **REMOVER** |
| 🆕 | - | `POST /api/device-tokens` | **IMPLEMENTAR** |
| 🆕 | - | `GET /api/device-tokens` | **IMPLEMENTAR** |
| 🆕 | - | `GET /api/device-tokens/{id}` | **IMPLEMENTAR** |
| 🆕 | - | `PUT /api/device-tokens/{id}` | **IMPLEMENTAR** |
| 🆕 | - | `DELETE /api/device-tokens/{id}` | **IMPLEMENTAR** |
| ⚠️ | `GET /api/device-tokens/usuario/{usuarioId}/active` | `GET /api/device-tokens/usuario/{usuarioId}` | **MIGRAR** |
| ⚠️ | `DELETE /api/device-tokens/usuario/{usuarioId}` | `DELETE /api/device-tokens/usuario/{usuarioId}` | **MANTER** |

#### Novos DTOs

**🆕 DeviceTokenCreateDTO**:
```dart
class DeviceTokenCreateDTO {
  final String deviceToken;
  final int usuarioId;
  final String plataforma;           // "ANDROID" ou "IOS"
}
```

**🆕 DeviceTokenUpdateDTO**:
```dart
class DeviceTokenUpdateDTO {
  final String? deviceToken;
  final String? plataforma;
}
```

**🆕 DeviceTokenListDTO**:
```dart
class DeviceTokenListDTO {
  final List<DeviceTokenDTO> deviceTokens;
  final int totalCount;
}
```

#### Arquivos Impactados
- [ ] `lib/data/datasources/device_token_remote_datasource.dart`
- [ ] `lib/data/DTOs/device_token_dto.dart`
- [ ] `lib/data/DTOs/device_token_create_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/device_token_update_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/device_token_list_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/device_token_service.dart`

---

### 7. 🏫 Campus

#### Verificações Necessárias

| Status | Endpoint | Ação |
|--------|----------|------|
| ⚠️ | `GET /api/campus/institution/{institutionId}` | Verificar se mudou para `instituicaoId` |

#### Arquivos Impactados
- [ ] `lib/data/datasources/campus_remote_datasource.dart`
- [ ] `lib/data/services/campus_service.dart`

---

### 8. ⏰ Deadlines

✅ **Sem mudanças necessárias** - Todas as rotas mantidas

---

## 🟢 PRIORIDADE BAIXA - Novas Funcionalidades

### 9. 🏢 Instituições - Nova Entidade

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/instituicao` | Listar todas |
| GET | `/api/instituicao/active` | Listar ativas |
| GET | `/api/instituicao/{id}` | Buscar por ID |
| POST | `/api/instituicao` | Criar |
| PUT | `/api/instituicao/{id}` | Atualizar |
| DELETE | `/api/instituicao/{id}` | Soft delete |

#### DTOs Necessários

**🆕 InstituicaoDTO**:
```dart
class InstituicaoDTO {
  final int id;
  final String nome;
  final String? cnpj;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

**🆕 InstituicaoCreateDTO**:
```dart
class InstituicaoCreateDTO {
  final String nome;
  final String? cnpj;
}
```

**🆕 InstituicaoListDTO**:
```dart
class InstituicaoListDTO {
  final List<InstituicaoDTO> instituicoes;
  final int totalCount;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/instituicao_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/instituicao_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/instituicao_create_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/instituicao_list_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/instituicao_service.dart` - 🆕 **CRIAR**
- [ ] `lib/data/models/instituicao_model.dart` - 🆕 **CRIAR**
- [ ] `lib/domain/entities/instituicao.dart` - 🆕 **CRIAR**

---

### 10. 🗺️ Estados - Nova Entidade

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/estados` | Listar todos |
| GET | `/api/estados/{id}` | Buscar por ID |
| GET | `/api/estados/uf/{uf}` | Buscar por UF |
| POST | `/api/estados` | Criar |
| PUT | `/api/estados/{id}` | Atualizar |
| POST | `/api/estados/{id}/delete` | Soft delete |

#### DTOs Necessários

**🆕 EstadoDTO**:
```dart
class EstadoDTO {
  final int id;
  final String nome;
  final String uf;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/estado_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/estado_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/estado_service.dart` - 🆕 **CRIAR**

---

### 11. 🏙️ Cidades - Nova Entidade

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/cidades` | Listar todas |
| GET | `/api/cidades/{id}` | Buscar por ID |
| GET | `/api/cidades/estado/{estadoId}` | Buscar por estado |
| POST | `/api/cidades` | Criar |
| PUT | `/api/cidades/{id}` | Atualizar |
| POST | `/api/cidades/{id}/delete` | Soft delete |

#### DTOs Necessários

**🆕 CidadeDTO**:
```dart
class CidadeDTO {
  final int id;
  final String nome;
  final int estadoId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/cidade_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/cidade_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/cidade_service.dart` - 🆕 **CRIAR**

---

### 12. 📍 Endereços - Nova Entidade

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/enderecos` | Listar todos |
| GET | `/api/enderecos/{id}` | Buscar por ID |
| GET | `/api/enderecos/cidade/{cidadeId}` | Buscar por cidade |
| POST | `/api/enderecos` | Criar |
| PUT | `/api/enderecos/{id}` | Atualizar |
| POST | `/api/enderecos/{id}/delete` | Soft delete |

#### DTOs Necessários

**🆕 EnderecoDTO**:
```dart
class EnderecoDTO {
  final int id;
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cep;
  final int cidadeId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/endereco_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/endereco_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/endereco_service.dart` - 🆕 **CRIAR**

---

### 13. 🔐 Roles - Nova Entidade (Somente Leitura)

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/roles` | Listar todas |
| GET | `/api/roles/active` | Listar ativas |
| GET | `/api/roles/{id}` | Buscar por ID |
| GET | `/api/roles/nome/{nome}` | Buscar por nome |

#### DTOs Necessários

**🆕 RoleDTO**:
```dart
class RoleDTO {
  final int id;
  final String nome;
  final String? descricao;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/role_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/role_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/role_service.dart` - 🆕 **CRIAR**

---

### 14. 🔗 Usuário-Campus - Nova Entidade de Relacionamento

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/usuario-campus` | Listar todos |
| GET | `/api/usuario-campus/active` | Listar ativos |
| POST | `/api/usuario-campus` | Criar relacionamento |
| PUT | `/api/usuario-campus/usuario/{usuarioId}/campus/{campusId}` | Atualizar |
| DELETE | `/api/usuario-campus/usuario/{usuarioId}/campus/{campusId}` | Deletar |

#### DTOs Necessários

**🆕 UsuarioCampusDTO**:
```dart
class UsuarioCampusDTO {
  final int id;
  final int usuarioId;
  final int campusId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
}
```

#### Arquivos a Criar
- [ ] `lib/data/datasources/usuario_campus_remote_datasource.dart` - 🆕 **CRIAR**
- [ ] `lib/data/DTOs/usuario_campus_dto.dart` - 🆕 **CRIAR**
- [ ] `lib/data/services/usuario_campus_service.dart` - 🆕 **CRIAR**

---

### 15. 🗄️ Cache - Ferramenta de Administração

#### Endpoints Disponíveis (Uso Interno)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/cache/stats` | Estatísticas gerais |
| GET | `/api/cache/stats/{cacheName}` | Estatísticas específicas |
| GET | `/api/cache/names` | Listar nomes de caches |
| GET | `/api/cache/exists/{cacheName}/{key}` | Verificar se existe |
| POST | `/api/cache/clear/{cacheName}` | Limpar cache específico |
| POST | `/api/cache/clear-all` | Limpar todos |
| POST | `/api/cache/log-stats` | Logar estatísticas |
| DELETE | `/api/cache/evict/{cacheName}/{key}` | Remover entrada |

#### Arquivos a Criar (Opcional - Admin)
- [ ] `lib/data/datasources/cache_remote_datasource.dart` - 🆕 **CRIAR** (opcional)
- [ ] `lib/presentation/pages/admin/cache_management_page.dart` - 🆕 **CRIAR** (opcional)

---

## 🚨 Decisões Pendentes - Backend

### Endpoints que NÃO existem na Nova API

Você precisa **DECIDIR** se irá:
1. **Criar no backend** - Se forem necessários
2. **Remover do Flutter** - Se não forem mais usados
3. **Substituir por alternativa** - Se houver equivalente

#### 1. Notificações

| Endpoint Atual | Status | Decisão Recomendada |
|---------------|--------|---------------------|
| `PUT /api/chat/messages/read-all/{userId}` | ❌ Não existe | **CRIAR NO BACKEND** - Funcionalidade útil |

#### 2. Itens - Filtros Simplificados

| Endpoint Atual | Status | Decisão Recomendada |
|---------------|--------|---------------------|
| `GET /api/itens/user/{userId}` | ❌ Não existe | **CRIAR NO BACKEND** - Usado em "Meus Itens" |
| `GET /api/itens/empresa/{empresaId}` | ❌ Não existe | **AVALIAR** - Empresa foi removido do sistema? |

#### 3. Chat - Endpoints Removidos

| Endpoint Atual | Status | Decisão Recomendada |
|---------------|--------|---------------------|
| `GET /api/chat/message/{messageId}` | ❌ Não existe | **AVALIAR** - Substituir por `/api/chat/all` com filtro? |
| `GET /api/chat/count/{chatId}` | ❌ Não existe | **AVALIAR** - Contar no cliente? |
| `GET /api/chat/chats/{userId}` | ❌ Não existe | **CRIAR NO BACKEND** - Lista de conversas é essencial |
| `GET /api/chat/unread/{userId}` | ❌ Não existe | **CRIAR NO BACKEND** - Badge de não lidas é essencial |

---

## 📅 Cronograma Sugerido de Implementação

### Sprint 1 - Fundação (2 semanas)
- [ ] **Semana 1**: Autenticação completa
  - Migrar endpoints de login
  - Implementar logout e validação de token
  - Adicionar suporte a Device Token no login
  - Implementar redefinição de senha
- [ ] **Semana 2**: Usuários
  - Criar DTOs específicos (Aluno/Servidor)
  - Ajustar cadastro para separar tipos
  - Migrar campos (remover empresa, adicionar campus)
  - Testar fluxo completo de cadastro

### Sprint 2 - Core (2 semanas)
- [ ] **Semana 3**: Itens
  - Migrar endpoints (update, delete)
  - Implementar criação separada (achados/perdidos)
  - Adicionar suporte a multipart obrigatório para achados
  - Ajustar DTOs (tipoItem, descLocalItem)
- [ ] **Semana 4**: Fotos
  - Implementar sistema completo de fotos
  - Criar relacionamentos (foto-item, foto-usuário)
  - Adicionar download de fotos
  - Implementar soft/hard delete

### Sprint 3 - Complementos (1 semana)
- [ ] **Semana 5**: Chat e Device Tokens
  - Ajustar endpoints de chat
  - Implementar mark-unread
  - Migrar device tokens
  - Adicionar CRUD completo

### Sprint 4 - Novas Funcionalidades (2 semanas - Opcional)
- [ ] **Semana 6**: Entidades Básicas
  - Implementar Instituições
  - Implementar Estados e Cidades
  - Implementar Endereços
- [ ] **Semana 7**: Relacionamentos e Admin
  - Implementar Usuário-Campus
  - Implementar Roles
  - Implementar Cache (admin)

---

## 📊 Métricas de Progresso

### Por Categoria

| Categoria | Total de Tarefas | Concluídas | Progresso |
|-----------|------------------|------------|-----------|
| **Autenticação** | 6 | 0 | ![0%](https://progress-bar.dev/0) |
| **Usuários** | 8 | 0 | ![0%](https://progress-bar.dev/0) |
| **Itens** | 10 | 0 | ![0%](https://progress-bar.dev/0) |
| **Fotos** | 25+ | 0 | ![0%](https://progress-bar.dev/0) |
| **Chat** | 5 | 0 | ![0%](https://progress-bar.dev/0) |
| **Device Tokens** | 6 | 0 | ![0%](https://progress-bar.dev/0) |
| **Campus** | 1 | 0 | ![0%](https://progress-bar.dev/0) |
| **Novas Entidades** | 30+ | 0 | ![0%](https://progress-bar.dev/0) |
| **TOTAL** | **91+** | **0** | ![0%](https://progress-bar.dev/0) |

---

## 🔧 Ferramentas e Recursos

### Dependências a Adicionar

```yaml
dependencies:
  dio: ^5.4.0                          # HTTP client
  flutter_secure_storage: ^9.0.0      # Armazenamento seguro de tokens
  jwt_decoder: ^2.0.1                  # Decodificação de JWT
  image_picker: ^1.0.7                 # Upload de fotos
  path_provider: ^2.1.2                # Paths do sistema
  cached_network_image: ^3.3.1         # Cache de imagens
```

### Scripts Úteis

```bash
# Limpar build e cache
flutter clean
flutter pub get

# Rodar testes
flutter test

# Gerar DTOs freezed
flutter pub run build_runner build --delete-conflicting-outputs

# Verificar análise estática
flutter analyze
```

---

## 📝 Notas Importantes

### Compatibilidade com Backend Atual
- ⚠️ **Atenção**: Algumas rotas antigas ainda funcionam?
- ⚠️ **Decisão**: Manter compatibilidade retroativa ou migração total?
- ⚠️ **Rollback**: Planejar estratégia de rollback se houver problemas

### Testes
- ✅ Testar cada endpoint isoladamente
- ✅ Testar fluxos completos (cadastro → upload fotos → visualização)
- ✅ Testar cenários de erro (401, 403, 500)
- ✅ Testar com dados reais de produção (em staging)

### Segurança
- 🔒 JWT deve ser armazenado com `flutter_secure_storage`
- 🔒 Nunca logar tokens completos
- 🔒 Validar expiração antes de requests
- 🔒 Implementar refresh token se disponível

### Performance
- ⚡ Implementar cache para listas (campus, locais, etc.)
- ⚡ Usar paginação onde disponível
- ⚡ Lazy loading de imagens
- ⚡ Debounce em buscas

---

## 🆘 Suporte e Referências

### Documentação
- **API Docs**: `flutter/DOC_NOVA_API.md`
- **Rotas Atuais**: `flutter/ROTAS_UTILIZADAS.md`
- **Este Documento**: `flutter/MIGRACAO_NOVA_API.md`

### Contatos
- **Equipe Backend**: contato@achadosperdidos.com.br
- **URL Base**: `https://api-achadosperdidos.com.br`

---

**Última Atualização:** 05 de Dezembro de 2025  
**Versão:** 1.0.0  
**Status:** 📋 Planejamento Completo
