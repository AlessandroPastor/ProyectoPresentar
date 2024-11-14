package org.example.projectvm.configuration;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Rol;
import org.example.projectvm.entity.Usuario;
import org.example.projectvm.service.impl.UsuarioService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Component
public class UserAuthenticationProvider {

    @Value("${security.jwt.token.secret-key:secret-key}")
    private String secretKey;

    private final UsuarioService userService;

    @PostConstruct
    protected void init() {
        // this is to avoid having the raw secret key available in the JVM
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String createToken(UsuarioDto user) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + 3600000); // 1 hour

        Algorithm algorithm = Algorithm.HMAC256(secretKey);

        // Extrae roles del usuario y conviértelos en una lista de strings
        Set<String> roles = user.getRoles().stream()
                .map(rol -> rol.getRolNombre().name())
                .collect(Collectors.toSet());

        return JWT.create()
                .withIssuer(user.getCorreo())
                .withIssuedAt(now)
                .withExpiresAt(validity)
                .withClaim("nombres", user.getNombres())
                .withClaim("apellidos", user.getApellidos())
                .withClaim("roles", new ArrayList<>(roles)) // Incluye los roles en el token
                .sign(algorithm);
    }


    public Authentication validateToken(String token) {
        Algorithm algorithm = Algorithm.HMAC256(secretKey);
        JWTVerifier verifier = JWT.require(algorithm).build();
        DecodedJWT decoded = verifier.verify(token);

        // Construye el UsuarioDto
        UsuarioDto user = UsuarioDto.builder()
                .correo(decoded.getIssuer())
                .nombres(decoded.getClaim("nombres").asString())
                .apellidos(decoded.getClaim("apellidos").asString())
                .build();

        // Extrae los roles desde el token
        List<String> roles = decoded.getClaim("roles").asList(String.class);
        Set<SimpleGrantedAuthority> authorities = roles.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toSet());

        return new UsernamePasswordAuthenticationToken(user, null, authorities);
    }


    public Authentication validateTokenStrongly(String token) {
        Algorithm algorithm = Algorithm.HMAC256(secretKey);
        JWTVerifier verifier = JWT.require(algorithm).build();
        DecodedJWT decoded = verifier.verify(token);

        UsuarioDto user = userService.findByLogin(decoded.getIssuer());

        // Extrae los roles desde el token
        List<String> roles = decoded.getClaim("roles").asList(String.class);
        Set<SimpleGrantedAuthority> authorities = roles.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toSet());

        return new UsernamePasswordAuthenticationToken(user, null, authorities);
    }



}
