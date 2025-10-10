package com.AchadosPerdidos.API.Application.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Habilita um broker de mensagens simples baseado em memória
        // com o destino "/topic" para mensagens de broadcast
        config.enableSimpleBroker("/topic");
        // Define o prefixo "/app" para mensagens que são roteadas para métodos anotados com @MessageMapping
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // Registra o endpoint "/ws" para conexões WebSocket
        // Permite origens de qualquer lugar (para desenvolvimento)
        // Em produção, especifique os domínios permitidos
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }
}
