package org.example.projectvm.service;

import org.example.projectvm.entity.Inscripciones;

import java.util.List;
import java.util.Optional;

public interface InscripcionesService {
    public List<Inscripciones> listar();
    public Inscripciones guardar(Inscripciones inscripciones);
    public Inscripciones actualizar(Inscripciones inscripciones);
    public Optional<Inscripciones> listaPorld(Integer id);
    public void eliminar(Integer id);
    Optional<Inscripciones> modificarHorasInscripcion(Long inscripcionId, String nuevasHoras);
    List<Inscripciones> obtenerTodas();
    Optional<Inscripciones> obtenerPorId(Integer id);
    String inscribirUsuarioAEvento(Integer usuarioId, Integer eventoId);
    boolean isUserRegisteredForEvent(Long usuarioId, Long eventoId);
}
