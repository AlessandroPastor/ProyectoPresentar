package org.example.projectvm.configuration;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserAuthenticationEntryPoint userAuthenticationEntryPoint;
    private final UserAuthenticationProvider userAuthenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .exceptionHandling(customizer -> customizer.authenticationEntryPoint(userAuthenticationEntryPoint))
                .addFilterBefore(new JwtAuthFilter(userAuthenticationProvider), BasicAuthenticationFilter.class)
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(customizer -> customizer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests((requests) -> requests
                        // Permitir el login para todos los usuarios sin autenticación
                        .requestMatchers(HttpMethod.POST, "/auth/login").permitAll()
                        // Restringir el registro solo para el rol ADMIN
                        .requestMatchers(HttpMethod.POST, "/auth/register").permitAll()

                        // Autorizaciones abiertas al público
                        .requestMatchers(HttpMethod.GET, "/v3/**", "/doc/**", "/asis/messages", "/image/**").permitAll()

                        // Controlador de autenticación (AuthController)
                        .requestMatchers("/auth/**").hasRole("ADMIN")

                        // Controlador de Carreras (CarrerasController)
                        .requestMatchers(HttpMethod.GET, "/carreras/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/carreras/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/carreras/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/carreras/**").hasRole("ADMIN")

                        // Controlador de Eventos (EventoController)
                        .requestMatchers(HttpMethod.GET, "/evento/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/evento/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/evento/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/evento/**").hasRole("ADMIN")


                        // Controlador de Inscripciones (InscripcionesController)
                        .requestMatchers(HttpMethod.GET, "/inscripciones/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/inscripciones/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.PUT, "/inscripciones/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/inscripciones/**").hasAnyRole("ADMIN", "USER")

                        // Cualquier otra solicitud debe estar autenticada
                        .anyRequest().authenticated()
                );
        return http.build();
    }
}
