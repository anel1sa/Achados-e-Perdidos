# Rotas Configuradas e Utilizadas no Sistema

## 📱 Rotas de Navegação Flutter (AppRoutes)

Todas as rotas abaixo estão **CONFIGURADAS E SENDO UTILIZADAS** no `main.dart`:

### ✅ Rotas Ativas

1. **`/login`** → `LoginPage`
   - Rota inicial do app
   - Usada em: `main.dart` (initialRoute)

2. **`/achados`** → `AchadosPage`
   - Usada em: `app_bottom_navigation.dart`, `login_page.dart`, `item_achado.dart`

3. **`/perdidos`** → `PerdidosPage`
   - Usada em: `app_bottom_navigation.dart`, `login_page.dart`, `item_achado.dart`

4. **`/cadastro-item`** → `CadastroItemAchadoPage`
   - Usada em: `achados_page.dart`, `item_achado.dart`

5. **`/cadastro-item-perdido`** → `CadastroItemPerdidoPage`
   - Usada em: `perdidos_page.dart`, `item_achado.dart`

6. **`/detalhes-item`** → `ItemAchadoPage`
   - Usada em: `item_card.dart`, `detalhes_item_page.dart`

7. **`/chat`** → `ChatPage`
   - Usada em: `app_bottom_navigation.dart`, `login_page.dart`, `item_achado.dart`, `chat_page.dart`

8. **`/perfil`** → `PerfilPage`
   - Usada em: `user_header.dart`, `app_bar_with_menu.dart`, `perfil_page.dart`

9. **`/configuracoes`** → `ConfiguracoesPage`
   - Usada em: `user_header.dart`, `app_bar_with_menu.dart`, `configuracoes_page.dart`

10. **`/notificacoes`** → `NotificacoesPage`
    - Usada em: `user_header.dart`, `notificacoes_page.dart`

---

## 🌐 Rotas da API (ApiConstants)

### ✅ Autenticação - EM USO

- ✅ **POST** `/api/usuarios/login` - Login com email/senha
  - Usado em: `auth_remote_datasource.dart`

- ✅ **POST** `/api/google-auth/login` - Login com Google
  - Usado em: `auth_remote_datasource.dart`, `google_auth_remote_datasource.dart`

- ✅ **GET** `/api/google-auth/callback` - Callback OAuth Google
  - Usado em: `auth_remote_datasource.dart`, `google_auth_remote_datasource.dart`

---

### ✅ Usuários - EM USO

- ✅ **GET** `/api/usuarios` - Lista todos os usuários
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **GET** `/api/usuarios/active` - Lista usuários ativos
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **GET** `/api/usuarios/{id}` - Busca usuário por ID
  - Usado em: `usuario_remote_datasource.dart` (getById, update, delete)

- ✅ **GET** `/api/usuarios/email/{email}` - Busca usuário por email
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **POST** `/api/usuarios` - Cria usuário genérico
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **POST** `/api/usuarios/aluno` - Cria usuário do tipo ALUNO
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **POST** `/api/usuarios/servidor` - Cria usuário do tipo SERVIDOR
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **PUT** `/api/usuarios/{id}` - Atualiza usuário
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **POST** `/api/usuarios/{id}/alterar-senha` - Altera senha do usuário
  - Usado em: `usuario_remote_datasource.dart`

- ✅ **DELETE** `/api/usuarios/{id}` - Deleta usuário
  - Usado em: `usuario_remote_datasource.dart`

---

### ✅ Itens - EM USO

- ✅ **GET** `/api/itens` - Lista todos os itens
  - Usado em: `item_remote_datasource.dart`

- ✅ **GET** `/api/itens/active` - Lista itens ativos
  - Usado em: `item_remote_datasource.dart`

- ✅ **GET** `/api/itens/{id}` - Busca item por ID
  - Usado em: `item_remote_datasource.dart` (getById, update, delete, createItemPerdido, createItemAchado)

- ✅ **GET** `/api/itens/campus/{campusId}` - Itens por campus
  - Usado em: `item_remote_datasource.dart`

- ✅ **GET** `/api/itens/user/{userId}` - Itens por usuário
  - Usado em: `item_remote_datasource.dart`

- ✅ **GET** `/api/itens/empresa/{empresaId}` - Itens por empresa
  - Usado em: `item_remote_datasource.dart`

- ✅ **GET** `/api/itens/search?term=xxx` - Busca de itens
  - Usado em: `item_remote_datasource.dart`

- ✅ **POST** `/api/itens` - Cria item genérico
  - Usado em: `item_remote_datasource.dart`

- ✅ **PUT** `/api/itens/{id}` - Atualiza item
  - Usado em: `item_remote_datasource.dart`

- ✅ **DELETE** `/api/itens/{id}` - Deleta item
  - Usado em: `item_remote_datasource.dart`

---

### ✅ Itens Perdidos - EM USO

- ✅ **GET** `/api/itens/perdidos` - Lista itens perdidos
  - Usado em: `item_remote_datasource.dart`

- ✅ **POST** `/api/itens/perdidos` - Cria item perdido (JSON ou multipart)
  - Usado em: `item_remote_datasource.dart`

---

### ✅ Itens Achados - EM USO

- ✅ **GET** `/api/itens/achados` - Lista itens achados
  - Usado em: `item_remote_datasource.dart`

- ✅ **POST** `/api/itens/achados` - Cria item achado (multipart obrigatório)
  - Usado em: `item_remote_datasource.dart`

---

### ✅ Itens Doados - EM USO

- ✅ **GET** `/api/itens-doados` - Lista itens doados
  - Usado em: `item_remote_datasource.dart`

---

### ✅ Chat - EM USO

- ✅ **POST** `/api/chat/send` - Envia mensagem
  - Usado em: `chat_remote_datasource.dart`

- ✅ **POST** `/api/chat/private` - Envia mensagem privada
  - Usado em: `chat_remote_datasource.dart`

- ✅ **GET** `/api/chat/messages/{chatId}` - Mensagens de um chat
  - Usado em: `chat_remote_datasource.dart`

- ✅ **GET** `/api/chat/messages/users/{userId1}/{userId2}` - Mensagens entre usuários
  - Usado em: `chat_remote_datasource.dart`

- ✅ **GET** `/api/chat/message/{messageId}` - Busca mensagem por ID
  - Usado em: `chat_remote_datasource.dart`, `notificacao_remote_datasource.dart`

- ✅ **GET** `/api/chat/count/{chatId}` - Conta mensagens
  - Usado em: `chat_remote_datasource.dart`

- ✅ **GET** `/api/chat/chats/{userId}` - Lista conversas do usuário
  - Usado em: `chat_remote_datasource.dart`

- ✅ **GET** `/api/chat/unread/{userId}` - Mensagens não lidas
  - Usado em: `chat_remote_datasource.dart`

- ✅ **PUT** `/api/chat/mark-read` - Marca mensagens como lidas
  - Usado em: `chat_remote_datasource.dart`, `notificacao_remote_datasource.dart`

- ✅ **POST** `/api/chat/typing` - Indica que está digitando
  - Usado em: `chat_remote_datasource.dart`

- ✅ **POST** `/api/chat/stop-typing` - Para indicação de digitação
  - Usado em: `chat_remote_datasource.dart`

- ✅ **POST** `/api/chat/online` - Notifica que está online
  - Usado em: `chat_remote_datasource.dart`

- ✅ **POST** `/api/chat/offline` - Notifica que está offline
  - Usado em: `chat_remote_datasource.dart`

- ✅ **WebSocket** `/ws` - Conexão WebSocket STOMP
  - Usado em: `chat_remote_datasource.dart`

- ✅ **WebSocket** `/app/chat` - Destino para envio de mensagens via WebSocket
  - Usado em: `chat_remote_datasource.dart`

- ✅ **WebSocket** `/topic/private.{userId}` - Tópico privado do usuário
  - Usado em: `chat_remote_datasource.dart`

---

### ✅ Notificações - EM USO

- ✅ **GET** `/api/chat/message/{messageId}` - Busca mensagem (usado para marcar como lida)
  - Usado em: `notificacao_remote_datasource.dart`

- ✅ **PUT** `/api/chat/mark-read` - Marca notificação como lida
  - Usado em: `notificacao_remote_datasource.dart`

- ✅ **PUT** `/api/chat/messages/read-all/{userId}` - Marca todas como lidas
  - Usado em: `notificacao_remote_datasource.dart`

---

### ✅ Fotos - EM USO

- ✅ **POST** `/api/fotos/upload/item` - Upload de foto de item
  - Usado em: `foto_remote_datasource.dart`

- ✅ **GET** `/api/fotos/item/{itemId}` - Busca fotos de um item
  - Usado em: `foto_remote_datasource.dart`

---

### ✅ Campus - EM USO

- ✅ **GET** `/api/campus` - Lista todos os campus
  - Usado em: `campus_remote_datasource.dart`

- ✅ **GET** `/api/campus/active` - Lista campus ativos
  - Usado em: `campus_remote_datasource.dart`

- ✅ **GET** `/api/campus/{id}` - Busca campus por ID
  - Usado em: `campus_remote_datasource.dart` (getById, update, delete)

- ✅ **GET** `/api/campus/institution/{instituicaoId}` - Campus por instituição
  - Usado em: `campus_remote_datasource.dart`

- ✅ **POST** `/api/campus` - Cria campus
  - Usado em: `campus_remote_datasource.dart`

- ✅ **PUT** `/api/campus/{id}` - Atualiza campus
  - Usado em: `campus_remote_datasource.dart`

- ✅ **DELETE** `/api/campus/{id}` - Deleta campus
  - Usado em: `campus_remote_datasource.dart`

---

### ✅ Deadline (Prazos) - EM USO

- ✅ **GET** `/api/deadline/near-deadline` - Itens próximos do prazo
  - Usado em: `deadline_remote_datasource.dart`

- ✅ **GET** `/api/deadline/expired` - Itens expirados
  - Usado em: `deadline_remote_datasource.dart`

- ✅ **POST** `/api/deadline/mark-donated/{itemId}` - Marca item como doado
  - Usado em: `deadline_remote_datasource.dart`

- ✅ **POST** `/api/deadline/notify-deadlines` - Força notificações
  - Usado em: `deadline_remote_datasource.dart`

- ✅ **POST** `/api/deadline/mark-expired-donated` - Marca expirados como doados
  - Usado em: `deadline_remote_datasource.dart`

- ✅ **GET** `/api/deadline/stats` - Estatísticas de prazos
  - Usado em: `deadline_remote_datasource.dart`

---

### ✅ Device Tokens (Push Notifications) - EM USO

- ✅ **POST** `/api/device-tokens/register` - Registra/atualiza token
  - Usado em: `device_token_remote_datasource.dart`

- ✅ **POST** `/api/device-tokens` - Cria token (método completo)
  - Usado em: `device_token_remote_datasource.dart`

- ✅ **GET** `/api/device-tokens/usuario/{usuarioId}/active` - Tokens ativos do usuário
  - Usado em: `device_token_remote_datasource.dart`

- ✅ **DELETE** `/api/device-tokens/{id}` - Deleta token
  - Usado em: `device_token_remote_datasource.dart`

---

## ✅ Limpeza Realizada

**Todas as rotas não utilizadas foram removidas do arquivo `ApiConstants`.**

As seguintes rotas foram **REMOVIDAS** do projeto:

### Autenticação
- ✅ Todas mantidas (todas estão em uso)

### Usuários
- ✅ Todas mantidas (todas estão em uso)

### Itens
- ❌ `/api/itens/{id}/doar` - Marcar item como doado
- ❌ `/api/itens/{id}/devolver` - Devolver item

### Itens Perdidos
- ❌ `/api/itens-perdidos/active` - Itens perdidos ativos
- ❌ `/api/itens-perdidos/{id}` - Item perdido por ID
- ❌ `/api/itens-perdidos/item/{itemId}` - Item perdido por itemId

### Itens Achados
- ❌ `/api/itens-achados/active` - Itens achados ativos
- ❌ `/api/itens-achados/{id}` - Item achado por ID
- ❌ `/api/itens-achados/item/{itemId}` - Item achado por itemId

### Itens Doados
- ❌ `/api/itens-doados/active` - Itens doados ativos

### Reivindicações
- ❌ `/api/reivindicacoes` - Todas as rotas de reivindicação (definidas mas não implementadas nos datasources)
  - `/api/reivindicacoes/{id}`
  - `/api/reivindicacoes/item/{itemId}`
  - `/api/reivindicacoes/user/{userId}`
  - `/api/reivindicacoes/proprietario/{proprietarioId}`
  - `/api/reivindicacoes/item/{itemId}/user/{userId}`

### Itens Devolvidos
- ❌ Todas as rotas de itens devolvidos (definidas mas não implementadas)
  - `/api/itens-devolvidos`
  - `/api/itens-devolvidos/{id}`
  - `/api/itens-devolvidos/item/{itemId}`

### Fotos
- ❌ `/api/fotos` - Lista todas as fotos
- ❌ `/api/fotos/active` - Fotos ativas
- ❌ `/api/fotos/{id}` - Foto por ID
- ❌ `/api/fotos/user/{userId}` - Fotos por usuário
- ❌ `/api/fotos/profile/{userId}` - Fotos de perfil
- ❌ `/api/fotos/item-photos/{itemId}` - Fotos de item
- ❌ `/api/fotos/main-item-photo/{itemId}` - Foto principal do item
- ❌ `/api/fotos/profile-photo/{userId}` - Foto de perfil
- ❌ `/api/fotos/upload/profile` - Upload de foto de perfil
- ❌ `/api/fotos/upload` - Upload genérico
- ❌ `/api/fotos/download/{id}` - Download de foto
- ❌ `/api/fotos/delete/{id}` - Deleta foto

### Instituições
- ❌ Todas as rotas de instituições (definidas mas não implementadas)
  - `/api/instituicao`
  - `/api/instituicao/active`
  - `/api/instituicao/{id}`
  - `/api/instituicao/type/{tipo}`

### Empresas
- ❌ Todas as rotas de empresas (definidas mas não implementadas)
  - `/api/empresa`
  - `/api/empresa/active`
  - `/api/empresa/{id}`

### Endereços
- ❌ Todas as rotas de endereços (definidas mas não implementadas)
  - `/api/enderecos`
  - `/api/enderecos/{id}`
  - `/api/enderecos/cidade/{cidadeId}`

### Cidades
- ❌ Todas as rotas de cidades (definidas mas não implementadas)
  - `/api/cidades`
  - `/api/cidades/{id}`
  - `/api/cidades/estado/{estadoId}`

### Estados
- ❌ Todas as rotas de estados (definidas mas não implementadas)
  - `/api/estados`
  - `/api/estados/{id}`
  - `/api/estados/uf/{uf}`

### Roles
- ❌ Todas as rotas de roles (definidas mas não implementadas)
  - `/api/roles`
  - `/api/roles/active`
  - `/api/roles/{id}`
  - `/api/roles/nome/{nome}`

### Status Item
- ❌ Todas as rotas de status item (definidas mas não implementadas)
  - `/api/status-item`
  - `/api/status-item/{id}`

### Usuario Campus
- ❌ Todas as rotas de usuario-campus (definidas mas não implementadas)
  - `/api/usuario-campus`
  - `/api/usuario-campus/usuario/{usuarioId}`

### Chat (não utilizadas)
- ❌ `/api/chat/message/{messageId}/read` - Marcar mensagem específica como lida
- ❌ `/api/chat/messages/system/{userId}` - Mensagens do sistema

### Device Tokens (não utilizadas)
- ❌ `/api/device-tokens/active` - Tokens ativos
- ❌ `/api/device-tokens/{id}` - Token por ID
- ❌ `/api/device-tokens/usuario/{usuarioId}` - Tokens por usuário (sem /active)

---

## 📊 Resumo

### Rotas Flutter (Navegação)
- **Total definidas:** 10
- **Total em uso:** 10 ✅
- **Não utilizadas:** 0

### Rotas API
- **Total definidas:** ~50 ✅
- **Total em uso:** ~50 ✅
- **Removidas:** ~50 ✅

### Principais Funcionalidades Ativas
1. ✅ Autenticação (login, Google OAuth)
2. ✅ Gerenciamento de usuários (CRUD completo)
3. ✅ Gerenciamento de itens (achados, perdidos, doados)
4. ✅ Sistema de chat (REST + WebSocket)
5. ✅ Notificações
6. ✅ Upload de fotos de itens
7. ✅ Gerenciamento de campus
8. ✅ Sistema de prazos (deadline)
9. ✅ Push notifications (device tokens)

### Funcionalidades Não Implementadas
1. ❌ Sistema de reivindicações completo
2. ❌ Sistema de itens devolvidos
3. ❌ Gerenciamento de fotos completo (apenas upload básico)
4. ❌ Gerenciamento de instituições, empresas, endereços, cidades, estados
5. ❌ Gerenciamento de roles e status item
6. ❌ Ações de doar/devolver itens via API

---

---

## ✅ Limpeza Concluída

Todas as rotas não utilizadas foram removidas do arquivo `lib/core/constants/api_constants.dart`.

**Arquivo limpo e otimizado!** ✨

**Última atualização:** Limpeza realizada - todas as rotas não utilizadas foram removidas

