package com.AchadosPerdidos.API.Application.Config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.context.event.ApplicationEnvironmentPreparedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.Environment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

public class EnvironmentConfig implements ApplicationListener<ApplicationEnvironmentPreparedEvent> {

    private static final Logger _log = LoggerFactory.getLogger(EnvironmentConfig.class);

    @Override
    public void onApplicationEvent(ApplicationEnvironmentPreparedEvent event) {
        Environment environment = event.getEnvironment();
        String[] activeProfiles = environment.getActiveProfiles();
        boolean isProduction = activeProfiles.length > 0 && "prd".equals(activeProfiles[0]);
        
        if (isProduction) {
            _log.info("Modo PRODUÇÃO detectado - Carregando variáveis de ambiente do arquivo .env");
        } else {
            _log.info("Modo DESENVOLVIMENTO detectado - Carregando variáveis de ambiente do arquivo .env");
        }
        
        try {
            Dotenv dotenv = Dotenv.configure()
                    .directory("./")
                    .ignoreIfMalformed()
                    .ignoreIfMissing()
                    .load();

            int loadedCount = 0;
            Map<String, Object> envProperties = new HashMap<>();
            
            for (var entry : dotenv.entries()) {
                String key = entry.getKey();
                String value = entry.getValue();

                System.setProperty(key, value);
                envProperties.put(key, value);
                loadedCount++;
            }
            
            MutablePropertySources propertySources = ((org.springframework.core.env.ConfigurableEnvironment) environment).getPropertySources();
            propertySources.addFirst(new MapPropertySource("dotenv", envProperties));
            
            _log.info("Variáveis de ambiente carregadas com sucesso do arquivo .env - Total: {} - Perfil: {}", 
                     loadedCount, isProduction ? "PRODUÇÃO" : "DESENVOLVIMENTO");

        } catch (RuntimeException e) {
            _log.error("ERRO CRÍTICO: Não foi possível carregar arquivo .env: {}", e.getMessage(), e);
            throw new RuntimeException("Aplicação não pode iniciar sem o arquivo .env", e);
        }
    }
}