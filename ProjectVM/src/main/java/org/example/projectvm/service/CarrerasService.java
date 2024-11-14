package org.example.projectvm.service;

import org.example.projectvm.dtos.CarreraDto;
import org.example.projectvm.entity.Carreras;

import java.util.List;
import java.util.Optional;

public interface CarrerasService {

    public List<Carreras> listar();
    public Carreras guardar(Carreras carreras);
    public Carreras actualizar(Carreras carreras);
    public Optional<Carreras> listById(Integer id);
    public void eliminar(Integer id);
    Optional<CarreraDto> listByIdDto(Integer id);
    CarreraDto obtenerCarreraConUsuarios(Integer id);
}
