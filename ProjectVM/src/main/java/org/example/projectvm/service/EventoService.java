package org.example.projectvm.service;

import org.example.projectvm.dtos.EventoDto;
import org.example.projectvm.entity.Evento;

import java.util.List;
import java.util.Optional;

public interface EventoService {
    public List<Evento> listar();
    public Evento guardar(Evento evento);
    public Evento actualizar(Evento evento);
    public Optional<Evento> listaPorld(Integer id);
    public void eliminar(Integer id);
    EventoDto obtenerEventoConInscripciones(Integer eventoId);
    void finalizarEvento(Integer eventoId);
    Optional<Evento> obtenerPorId(Integer eventoId);
}
