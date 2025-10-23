package com.AchadosPerdidos.API.Application.Config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.annotation.PostConstruct;

@Configuration
@PropertySource(value = "file:.env", ignoreResourceNotFound = true)
public class EnvironmentConfig {

    private static final Logger _log = LoggerFactory.getLogger(EnvironmentConfig.class);

    @PostConstruct
    public void loadEnvironmentVariables() {
        _log.info("Iniciando as variaveis de ambiente");
        
        try {
            Dotenv dotenv = Dotenv.configure()
                    .directory("./")
                    .ignoreIfMalformed()
                    .ignoreIfMissing()
                    .load();

            int loadedCount = 0;
            int skippedCount = 0;
            
            for (var entry : dotenv.entries()) {
                String key = entry.getKey();
                String value = entry.getValue();

                if (System.getenv(key) == null) {
                    System.setProperty(key, value);
                    loadedCount++;
                } else {
                    skippedCount++;
                }
            }
            _log.info("Variáveis de ambiente carregadas com sucesso do arquivo .env - Carregadas: {}, Ignoradas: {}", loadedCount, skippedCount);

        } catch (RuntimeException e) {
            _log.error("Erro ao carregar arquivo .env: {}", e.getMessage(), e);
        }
    }
}