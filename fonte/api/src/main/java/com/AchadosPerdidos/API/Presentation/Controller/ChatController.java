package com.AchadosPerdidos.API.Presentation.Controller;

import com.AchadosPerdidos.API.Application.Services.ChatService;
import com.AchadosPerdidos.API.Domain.Entity.Chat.ChatMessage;
import com.AchadosPerdidos.API.Domain.Enum.Tipo_Menssagem;
import com.AchadosPerdidos.API.Domain.Enum.Status_Menssagem;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/chat")
@Tag(name = "Chat WebSocket + REST", description = "Endpoints híbridos para chat com WebSocket e REST API")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    /**
     * Endpoint para enviar mensagem para um chat específico
     * Rota: /app/chat.sendMessage
     * Broadcast: /topic/chat.{chatId}
     */
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessage chatMessage) {
        // Define valores padrão se não fornecidos
        if (chatMessage.getData_Hora_Menssagem() == null) {
            chatMessage.setData_Hora_Menssagem(LocalDateTime.now());
        }
        if (chatMessage.getStatus() == null) {
            chatMessage.setStatus(Status_Menssagem.SENT);
        }
        if (chatMessage.getTipo() == null) {
            chatMessage.setTipo(Tipo_Menssagem.CHAT);
        }
        
        // Salva a mensagem no MongoDB
        ChatMessage savedMessage = chatService.saveMessage(chatMessage);
        
        // Envia a mensagem para todos os usuários do chat específico
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
    }

    /**
     * Endpoint para quando um usuário se conecta ao chat
     * Rota: /app/chat.addUser
     * Broadcast: /topic/chat.{chatId}
     */
    @MessageMapping("/chat.addUser")
    public void addUser(@Payload ChatMessage chatMessage) {
        // Define chatId padrão se não fornecido
        if (chatMessage.getId_Chat() == null) {
            chatMessage.setId_Chat("public");
        }
        
        // Define tipo de mensagem como JOIN
            chatMessage.setTipo(Tipo_Menssagem.JOIN);
            chatMessage.setData_Hora_Menssagem(LocalDateTime.now());
            chatMessage.setStatus(Status_Menssagem.SENT);
        
        // Salva a mensagem de JOIN no MongoDB
        ChatMessage savedMessage = chatService.saveMessage(chatMessage);
        
        // Envia a mensagem de JOIN para o chat
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
    }

    /**
     * Endpoint para quando um usuário sai do chat
     * Rota: /app/chat.leaveUser
     * Broadcast: /topic/chat.{chatId}
     */
    @MessageMapping("/chat.leaveUser")
    public void leaveUser(@Payload ChatMessage chatMessage) {
        // Define chatId padrão se não fornecido
        if (chatMessage.getId_Chat() == null) {
            chatMessage.setId_Chat("public");
        }
        
        // Define tipo de mensagem como LEAVE
            chatMessage.setTipo(Tipo_Menssagem.LEAVE);
            chatMessage.setData_Hora_Menssagem(LocalDateTime.now());
            chatMessage.setStatus(Status_Menssagem.SENT);
        
        // Salva a mensagem de LEAVE no MongoDB
        ChatMessage savedMessage = chatService.saveMessage(chatMessage);
        
        // Envia a mensagem de LEAVE para o chat
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
    }

    /**
     * Endpoint para enviar mensagem privada entre dois usuários
     * Rota: /app/chat.sendPrivateMessage
     * Broadcast: /topic/private.{userId}
     */
    @MessageMapping("/chat.sendPrivateMessage")
    public void sendPrivateMessage(@Payload ChatMessage chatMessage) {
        // Define valores padrão
        chatMessage.setData_Hora_Menssagem(LocalDateTime.now());
        chatMessage.setStatus(Status_Menssagem.SENT);
        chatMessage.setTipo(Tipo_Menssagem.CHAT);
        
        // Salva a mensagem no MongoDB
        ChatMessage savedMessage = chatService.saveMessage(chatMessage);
        
        // Envia a mensagem privada para o destinatário
        String destination = "/topic/private." + savedMessage.getId_Usuario_Destino();
        messagingTemplate.convertAndSend(destination, savedMessage);
    }

    /**
     * Endpoint para marcar mensagens como lidas
     * Rota: /app/chat.markAsRead
     * Broadcast: /topic/private.{userId}
     */
    @MessageMapping("/chat.markAsRead")
    public void markAsRead(@Payload ChatMessage chatMessage) {
        // Busca mensagens não lidas do usuário
        List<ChatMessage> unreadMessages = chatService.getUnreadMessages(chatMessage.getId_Usuario_Destino());
        
        if (!unreadMessages.isEmpty()) {
            // Marca como lidas
            chatService.markMessagesAsRead(
                unreadMessages.stream()
                    .map(ChatMessage::getId)
                    .toList()
            );
            
            // Notifica o remetente que as mensagens foram lidas
            String destination = "/topic/private." + chatMessage.getId_Usuario_Remetente();
            ChatMessage notificationMessage = new ChatMessage();
            notificationMessage.setId_Chat("");
            notificationMessage.setId_Usuario_Remetente("");
            notificationMessage.setId_Usuario_Destino("");
            notificationMessage.setMenssagem("Mensagens marcadas como lidas");
            notificationMessage.setData_Hora_Menssagem(LocalDateTime.now());
            notificationMessage.setStatus(Status_Menssagem.READ);
            notificationMessage.setTipo(Tipo_Menssagem.SYSTEM);
            messagingTemplate.convertAndSend(destination, notificationMessage);
        }
    }

    /**
     * Endpoint para indicar que o usuário está digitando
     * Rota: /app/chat.typing
     * Broadcast: /topic/chat.{chatId}
     */
    @MessageMapping("/chat.typing")
    public void typing(@Payload ChatMessage chatMessage) {
        // Cria mensagem de "digitando"
        ChatMessage typingMessage = new ChatMessage();
        typingMessage.setId_Chat(chatMessage.getId_Chat());
        typingMessage.setId_Usuario_Remetente(chatMessage.getId_Usuario_Remetente());
        typingMessage.setMenssagem("está digitando...");
        typingMessage.setTipo(Tipo_Menssagem.TYPING);
        typingMessage.setData_Hora_Menssagem(LocalDateTime.now());
        typingMessage.setStatus(Status_Menssagem.SENT);
        
        // Envia indicação de digitação para o chat
        String destination = "/topic/chat." + chatMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, typingMessage);
    }

    /**
     * Endpoint para parar indicação de digitação
     * Rota: /app/chat.stopTyping
     * Broadcast: /topic/chat.{chatId}
     */
    @MessageMapping("/chat.stopTyping")
    public void stopTyping(@Payload ChatMessage chatMessage) {
        // Cria mensagem de "parou de digitar"
        ChatMessage stopTypingMessage = new ChatMessage();
        stopTypingMessage.setId_Chat(chatMessage.getId_Chat());
        stopTypingMessage.setId_Usuario_Remetente(chatMessage.getId_Usuario_Remetente());
        stopTypingMessage.setMenssagem("parou de digitar");
        stopTypingMessage.setTipo(Tipo_Menssagem.STOP_TYPING);
        stopTypingMessage.setData_Hora_Menssagem(LocalDateTime.now());
        stopTypingMessage.setStatus(Status_Menssagem.SENT);
        
        // Envia indicação de parada de digitação para o chat
        String destination = "/topic/chat." + chatMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, stopTypingMessage);
    }

    // ==================== ENDPOINTS REST API ====================

    /**
     * REST: Enviar mensagem via HTTP (também envia via WebSocket)
     */
    @Operation(summary = "Enviar mensagem", description = "Envia mensagem via REST e WebSocket")
    @PostMapping("/send")
    public ResponseEntity<ChatMessage> sendMessageRest(@RequestBody ChatMessage message) {
        // Define valores padrão
        if (message.getData_Hora_Menssagem() == null) {
            message.setData_Hora_Menssagem(LocalDateTime.now());
        }
        if (message.getStatus() == null) {
            message.setStatus(Status_Menssagem.SENT);
        }
        if (message.getTipo() == null) {
            message.setTipo(Tipo_Menssagem.CHAT);
        }
        
        // Salva no MongoDB
        ChatMessage savedMessage = chatService.saveMessage(message);
        
        // Envia via WebSocket para tempo real
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
        
        return ResponseEntity.ok(savedMessage);
    }

    /**
     * REST: Entrar no chat via HTTP
     */
    @Operation(summary = "Entrar no chat", description = "Usuário entra no chat via REST")
    @PostMapping("/join")
    public ResponseEntity<ChatMessage> joinChatRest(@RequestBody ChatMessage message) {
        message.setTipo(Tipo_Menssagem.JOIN);
        message.setData_Hora_Menssagem(LocalDateTime.now());
        message.setStatus(Status_Menssagem.SENT);
        
        ChatMessage savedMessage = chatService.saveMessage(message);
        
        // Envia via WebSocket
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
        
        return ResponseEntity.ok(savedMessage);
    }

    /**
     * REST: Sair do chat via HTTP
     */
    @Operation(summary = "Sair do chat", description = "Usuário sai do chat via REST")
    @PostMapping("/leave")
    public ResponseEntity<ChatMessage> leaveChatRest(@RequestBody ChatMessage message) {
        message.setTipo(Tipo_Menssagem.LEAVE);
        message.setData_Hora_Menssagem(LocalDateTime.now());
        message.setStatus(Status_Menssagem.SENT);
        
        ChatMessage savedMessage = chatService.saveMessage(message);
        
        // Envia via WebSocket
        String destination = "/topic/chat." + savedMessage.getId_Chat();
        messagingTemplate.convertAndSend(destination, savedMessage);
        
        return ResponseEntity.ok(savedMessage);
    }

    /**
     * REST: Enviar mensagem privada via HTTP
     */
    @Operation(summary = "Enviar mensagem privada", description = "Envia mensagem privada via REST e WebSocket")
    @PostMapping("/private")
    public ResponseEntity<ChatMessage> sendPrivateMessageRest(@RequestBody ChatMessage message) {
        message.setData_Hora_Menssagem(LocalDateTime.now());
        message.setStatus(Status_Menssagem.SENT);
        message.setTipo(Tipo_Menssagem.CHAT);
        
        ChatMessage savedMessage = chatService.saveMessage(message);
        
        // Envia via WebSocket para o destinatário
        String destination = "/topic/private." + savedMessage.getId_Usuario_Destino();
        messagingTemplate.convertAndSend(destination, savedMessage);
        
        return ResponseEntity.ok(savedMessage);
    }

    /**
     * REST: Indicar que está digitando
     */
    @Operation(summary = "Indicar digitação", description = "Indica que usuário está digitando")
    @PostMapping("/typing")
    public ResponseEntity<ChatMessage> typingRest(@RequestBody ChatMessage message) {
        message.setMenssagem("está digitando...");
        message.setTipo(Tipo_Menssagem.TYPING);
        message.setData_Hora_Menssagem(LocalDateTime.now());
        message.setStatus(Status_Menssagem.SENT);
        
        // Envia via WebSocket
        String destination = "/topic/chat." + message.getId_Chat();
        messagingTemplate.convertAndSend(destination, message);
        
        return ResponseEntity.ok(message);
    }

    /**
     * REST: Parar indicação de digitação
     */
    @Operation(summary = "Parar digitação", description = "Para indicação de digitação")
    @PostMapping("/stop-typing")
    public ResponseEntity<ChatMessage> stopTypingRest(@RequestBody ChatMessage message) {
        message.setMenssagem("parou de digitar");
        message.setTipo(Tipo_Menssagem.STOP_TYPING);
        message.setData_Hora_Menssagem(LocalDateTime.now());
        message.setStatus(Status_Menssagem.SENT);
        
        // Envia via WebSocket
        String destination = "/topic/chat." + message.getId_Chat();
        messagingTemplate.convertAndSend(destination, message);
        
        return ResponseEntity.ok(message);
    }

    /**
     * REST: Buscar mensagens do chat
     */
    @Operation(summary = "Buscar mensagens do chat", description = "Retorna mensagens de um chat específico")
    @GetMapping("/messages/{chatId}")
    public ResponseEntity<List<ChatMessage>> getChatMessages(
            @Parameter(description = "ID do chat") @PathVariable String chatId) {
        List<ChatMessage> messages = chatService.getMessagesByChatId(chatId);
        return ResponseEntity.ok(messages);
    }

    /**
     * REST: Buscar mensagens entre usuários
     */
    @Operation(summary = "Buscar mensagens entre usuários", description = "Retorna mensagens entre dois usuários")
    @GetMapping("/messages/users/{userId1}/{userId2}")
    public ResponseEntity<List<ChatMessage>> getMessagesBetweenUsers(
            @Parameter(description = "ID do primeiro usuário") @PathVariable String userId1,
            @Parameter(description = "ID do segundo usuário") @PathVariable String userId2) {
        List<ChatMessage> messages = chatService.getMessagesBetweenUsers(userId1, userId2);
        return ResponseEntity.ok(messages);
    }

    /**
     * REST: Marcar mensagens como lidas
     */
    @Operation(summary = "Marcar como lidas", description = "Marca mensagens como lidas")
    @PutMapping("/mark-read")
    public ResponseEntity<String> markAsReadRest(@RequestBody ChatMessage message) {
        List<ChatMessage> unreadMessages = chatService.getUnreadMessages(message.getId_Usuario_Destino());
        
        if (!unreadMessages.isEmpty()) {
            chatService.markMessagesAsRead(
                unreadMessages.stream()
                    .map(ChatMessage::getId)
                    .toList()
            );
            
            // Notifica via WebSocket
            String destination = "/topic/private." + message.getId_Usuario_Remetente();
            ChatMessage notificationMessage = new ChatMessage();
            notificationMessage.setId_Chat("");
            notificationMessage.setId_Usuario_Remetente("");
            notificationMessage.setId_Usuario_Destino("");
            notificationMessage.setMenssagem("Mensagens marcadas como lidas");
            notificationMessage.setData_Hora_Menssagem(LocalDateTime.now());
            notificationMessage.setStatus(Status_Menssagem.READ);
            notificationMessage.setTipo(Tipo_Menssagem.SYSTEM);
            messagingTemplate.convertAndSend(destination, notificationMessage);
        }
        
        return ResponseEntity.ok("Mensagens marcadas como lidas");
    }

    /**
     * REST: Buscar mensagem por ID
     */
    @Operation(summary = "Buscar mensagem por ID", description = "Retorna uma mensagem específica")
    @GetMapping("/message/{messageId}")
    public ResponseEntity<ChatMessage> getMessageById(
            @Parameter(description = "ID da mensagem") @PathVariable String messageId) {
        Optional<ChatMessage> message = chatService.getMessageById(messageId);
        return message.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * REST: Contar mensagens do chat
     */
    @Operation(summary = "Contar mensagens", description = "Retorna número de mensagens em um chat")
    @GetMapping("/count/{chatId}")
    public ResponseEntity<Long> getMessageCount(
            @Parameter(description = "ID do chat") @PathVariable String chatId) {
        long count = chatService.getMessageCountByChat(chatId);
        return ResponseEntity.ok(count);
    }
}
