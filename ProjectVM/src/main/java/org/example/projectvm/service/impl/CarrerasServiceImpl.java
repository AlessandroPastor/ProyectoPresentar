package org.example.projectvm.service.impl;

import org.example.projectvm.dtos.CarreraDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Carreras;
import org.example.projectvm.exceptions.AppException;
import org.example.projectvm.mappers.UsuarioMapper;
import org.example.projectvm.repository.CarrerasRepository;
import org.example.projectvm.service.CarrerasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service

public class CarrerasServiceImpl implements CarrerasService {


    public CarrerasServiceImpl(CarrerasRepository carrerasRepository, UsuarioMapper userMapper) {
        this.carrerasRepository = carrerasRepository;
        this.userMapper = userMapper;
    }

    @Autowired
    private CarrerasRepository carrerasRepository;
    private final UsuarioMapper userMapper;
    @Override
    public List<Carreras> listar() {
        return carrerasRepository.findAll();
    }
    @Override
    public Carreras guardar(Carreras carreras) {
        return carrerasRepository.save(carreras);
    }
    @Override
    public Carreras actualizar(Carreras carreras) {
        return carrerasRepository.save(carreras);
    }
    @Override
    public Optional<Carreras> listById(Integer id) {
        return carrerasRepository.findById(id);
    }
    @Override
    public void eliminar(Integer id) {
        carrerasRepository.deleteById(id);
    }
    @Override
    public Optional<CarreraDto> listByIdDto(Integer id) {
        return carrerasRepository.findByIdWithUsuarios(id).map(carrera -> {
            List<UsuarioDto> usuariosDto = carrera.getUsuarios().stream()
                    .map(usuario -> new UsuarioDto(
                            usuario.getId(),
                            usuario.getNombres(),
                            usuario.getApellidos(),
                            usuario.getCorreo(),
                            usuario.getDni(),
                            usuario.getEstado(),
                            usuario.getCodigo(),
                            usuario.getCantidad_de_horas(),
                            carrera.getId(),
                            carrera.getNombre_facultad()
                    ))
                    .collect(Collectors.toList());
            return new CarreraDto(carrera.getId(), carrera.getNombre_facultad(), usuariosDto);
        });
    }

    @Override
    public CarreraDto obtenerCarreraConUsuarios(Integer id) {
        Carreras carrera = carrerasRepository.findById(id)
                .orElseThrow(() -> new AppException("Carrera no encontrada", HttpStatus.NOT_FOUND));

        List<UsuarioDto> usuariosDto = carrera.getUsuarios().stream()
                .map(userMapper::toUserDto)
                .collect(Collectors.toList());

        return new CarreraDto(carrera.getId(), carrera.getNombre_facultad(), usuariosDto);
    }

}
