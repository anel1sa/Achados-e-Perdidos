package com.AchadosPerdidos.API.Application.Services;

import com.AchadosPerdidos.API.Domain.Entity.Chat.ChatMessage;
import com.AchadosPerdidos.API.Domain.Repository.ChatMessageRepository;
import com.AchadosPerdidos.API.Infrastruture.MongoDB.Interfaces.IChatQuery;
import com.AchadosPerdidos.API.Application.Services.Interfaces.IChatService;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ChatService implements IChatService {

    @Autowired
    private ChatMessageRepository chatMessageRepository;
    
    @Autowired
    private IChatQuery chatQuery;

    /**
     * Salva uma mensagem no MongoDB
     * @param message A mensagem a ser salva
     * @return A mensagem salva
     */
    public ChatMessage saveMessage(ChatMessage message) {
        return chatMessageRepository.save(message);
    }

    /**
     * Busca mensagens por chatId
     * @param chatId ID do chat
     * @return Lista de mensagens do chat
     */
    public List<ChatMessage> getMessagesByChatId(String chatId) {
        return chatQuery.findMessagesByChatId(chatId);
    }

    /**
     * Busca mensagens entre dois usuários
     * @param userId1 ID do primeiro usuário
     * @param userId2 ID do segundo usuário
     * @return Lista de mensagens entre os usuários
     */
    public List<ChatMessage> getMessagesBetweenUsers(String userId1, String userId2) {
        return chatQuery.findMessagesBetweenUsers(userId1, userId2);
    }

    /**
     * Busca as últimas N mensagens de um chat
     * @param chatId ID do chat
     * @param limit Número de mensagens a retornar
     * @return Lista das últimas mensagens
     */
    public List<ChatMessage> getRecentMessages(String chatId, int limit) {
        return chatQuery.findRecentMessages(chatId, limit);
    }

    /**
     * Busca mensagens por período
     * @param chatId ID do chat
     * @param startTime Data/hora inicial
     * @param endTime Data/hora final
     * @return Lista de mensagens no período
     */
    public List<ChatMessage> getMessagesByPeriod(String chatId, LocalDateTime startTime, LocalDateTime endTime) {
        return chatQuery.findMessagesByPeriod(chatId, startTime, endTime);
    }

    /**
     * Busca mensagens não lidas de um usuário
     * @param receiverId ID do receptor
     * @return Lista de mensagens não lidas
     */
    public List<ChatMessage> getUnreadMessages(String receiverId) {
        return chatQuery.findUnreadMessages(receiverId);
    }

    /**
     * Marca mensagens como entregues
     * @param messageIds Lista de IDs das mensagens
     */
    public void markMessagesAsDelivered(List<String> messageIds) {
        List<ChatMessage> messages = chatMessageRepository.findAllById(messageIds);
        messages.forEach(message -> message.setStatus(com.AchadosPerdidos.API.Domain.Enum.Status_Menssagem.DELIVERED));
        chatMessageRepository.saveAll(messages);
    }

    /**
     * Marca mensagens como lidas
     * @param messageIds Lista de IDs das mensagens
     */
    public void markMessagesAsRead(List<String> messageIds) {
        List<ChatMessage> messages = chatMessageRepository.findAllById(messageIds);
        messages.forEach(message -> message.setStatus(com.AchadosPerdidos.API.Domain.Enum.Status_Menssagem.READ));
        chatMessageRepository.saveAll(messages);
    }

    /**
     * Conta mensagens por chat
     * @param chatId ID do chat
     * @return Número de mensagens
     */
    public long getMessageCountByChat(String chatId) {
        return chatQuery.countMessagesByChat(chatId);
    }

    /**
     * Busca uma mensagem por ID
     * @param messageId ID da mensagem
     * @return Mensagem encontrada ou Optional.empty()
     */
    public Optional<ChatMessage> getMessageById(String messageId) {
        return chatMessageRepository.findById(messageId);
    }

    /**
     * Deleta uma mensagem
     * @param messageId ID da mensagem
     */
    public void deleteMessage(String messageId) {
        chatMessageRepository.deleteById(messageId);
    }
}
