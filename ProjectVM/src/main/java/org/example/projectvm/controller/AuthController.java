package org.example.projectvm.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.example.projectvm.configuration.UserAuthenticationProvider;
import org.example.projectvm.dtos.CredencialesDto;
import org.example.projectvm.dtos.UsuarioCrearDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Usuario;
import org.example.projectvm.service.impl.UsuarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.Optional;

@RequiredArgsConstructor
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UsuarioService userService;
    private final UserAuthenticationProvider userAuthenticationProvider;

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @PostMapping("/login")
    public ResponseEntity<UsuarioDto> login(@RequestBody @Valid CredencialesDto credentialsDto, HttpServletRequest request) {
        UsuarioDto userDto = userService.login(credentialsDto);
        userDto.setToken(userAuthenticationProvider.createToken(userDto));
        request.getSession().setAttribute("USER_SESSION", userDto.getCorreo());
        return ResponseEntity.ok(userDto);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/register")
    public ResponseEntity<UsuarioDto> register(@RequestBody @Valid UsuarioCrearDto user) {
        System.out.println("Usuario Creado con Exito" + user.token());
        UsuarioDto createdUser = userService.register(user);
        createdUser.setToken(userAuthenticationProvider.createToken(createdUser));
        return ResponseEntity.created(URI.create("/users/" + createdUser.getId())).body(createdUser);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("codigo/{codigo}")
    public ResponseEntity<Usuario> buscarPorCodigo(@PathVariable String codigo) {
        Optional<Usuario> carrera = userService.buscarPorCodigo(codigo);
        return carrera.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("dni/{dni}")
    public ResponseEntity<Usuario> buscarPorDni(@PathVariable String dni) {
        Optional<Usuario> carrera = userService.buscarPorDni(dni);
        return carrera.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
