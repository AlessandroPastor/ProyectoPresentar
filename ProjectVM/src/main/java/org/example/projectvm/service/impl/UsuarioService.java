package org.example.projectvm.service.impl;

import lombok.RequiredArgsConstructor;
import org.example.projectvm.dtos.CredencialesDto;
import org.example.projectvm.dtos.UsuarioCrearDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Carreras;
import org.example.projectvm.entity.Rol;
import org.example.projectvm.entity.Usuario;
import org.example.projectvm.exceptions.AppException;
import org.example.projectvm.mappers.UsuarioMapper;
import org.example.projectvm.repository.CarrerasRepository;
import org.example.projectvm.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.nio.CharBuffer;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class UsuarioService {

    private final UsuarioRepository userRepository;

    private final RolService rolService;

    private final CarrerasRepository carrerasRepository;

    private final PasswordEncoder passwordEncoder;

    private final UsuarioMapper userMapper;

    public UsuarioDto login(CredencialesDto credentialsDto) {
        Usuario user = userRepository.findByCorreo(credentialsDto.correo())
                .orElseThrow(() -> new AppException("Usuario Desconocido", HttpStatus.NOT_FOUND));

        if (passwordEncoder.matches(CharBuffer.wrap(credentialsDto.password()), user.getPassword())) {
            return userMapper.toUserDto(user);
        }
        throw new AppException("Contraseña Invalida", HttpStatus.BAD_REQUEST);
    }

    public UsuarioDto register(UsuarioCrearDto userDto) {
        Optional<Usuario> optionalUser = userRepository.findByCorreo(userDto.correo());

        if (optionalUser.isPresent()) {
            throw new AppException("Usuario Existente", HttpStatus.BAD_REQUEST);
        }

        Usuario user = userMapper.usuarioCrearDtoToUser(userDto);
        user.setPassword(passwordEncoder.encode(CharBuffer.wrap(userDto.password())));
        System.out.println("Ingreso Correctamenta");
        System.out.println(userDto.token());

        // Asignar roles
        Set<Rol> roles = new HashSet<>();
        roles.add(rolService.getByRolNombre(Rol.RolNombre.ROLE_USER).orElseThrow(() ->
                new AppException("Rol de usuario no encontrado", HttpStatus.NOT_FOUND)));
        if ("admin".equals(userDto.token())) {
            roles.add(rolService.getByRolNombre(Rol.RolNombre.ROLE_ADMIN).orElseThrow(() ->
                    new AppException("Rol de administrador no encontrado", HttpStatus.NOT_FOUND)));
        }
        user.setRoles(roles);

        Carreras carrera = carrerasRepository.findById(Math.toIntExact(userDto.carreraId()))
                .orElseThrow(() -> new AppException("Carrera no encontrada", HttpStatus.NOT_FOUND));
        user.setCarrera(carrera);
        Usuario savedUser = userRepository.save(user);
        return userMapper.toUserDto(savedUser);
    }

    @Transactional
    public UsuarioDto findByLogin(String correo) {
        Usuario user = userRepository.findByCorreo(correo)
                .orElseThrow(() -> new AppException("Usuario Desconocido", HttpStatus.NOT_FOUND));
        return userMapper.toUserDto(user);
    }

    public Optional<Usuario> buscarPorDni(String dni) {
        return userRepository.findByDni(dni);
    }

    public Optional<Usuario> buscarPorCodigo(String codigo) {
        return userRepository.findByCodigo(codigo);
    }

    public Optional<Usuario> obtenerPorId(Integer usuarioId) {
        return null;
    }
}
