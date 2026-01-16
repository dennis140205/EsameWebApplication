package com.example.progettowebapplication.config;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    // Configura la catena di filtri di sicurezza
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // Crea sessione se serve (Login)
                )
                .cors(Customizer.withDefaults())
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // Registrazione pubblica
                        .requestMatchers("/utente/register", "/utente/login").permitAll()
                        .requestMatchers("/api/**").permitAll()
                        // Sblocca la lettura dei calciatori per tutti, così Angular può vederli
                        .requestMatchers(org.springframework.http.HttpMethod.GET, "/calciatori/**").permitAll()
                        // Endpoint esclusivi per ADMIN (importazione, upload voti, sync)
                        .requestMatchers(
                                "/calciatori/import",
                                "/calciatori/upload-stati",
                                "/calciatori/upload-voti",
                                "/calciatori/sync-images"
                        ).hasAuthority("ROLE_ADMIN") // Solo chi ha ruolo ADMIN nel DB passa qui
                        // Richiesta autenticazione per tutte le altre richieste
                        .anyRequest().authenticated()
                )
                .httpBasic(basic -> basic
                        // Questo pezzo impedisce al browser di aprire il popup nativo sugli errori 401
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, authException.getMessage());
                        })
                );

        return http.build();
    }

    // Configurazione CORS
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // L'URL di default di Angular
        configuration.setAllowedOrigins(List.of("http://localhost:4200"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));
        // abilita l'uso dei cookie (with credentials)
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}