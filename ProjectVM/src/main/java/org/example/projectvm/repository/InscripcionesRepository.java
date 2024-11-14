package org.example.projectvm.repository;

import org.example.projectvm.entity.Inscripciones;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InscripcionesRepository extends JpaRepository<Inscripciones, Integer> {
    List<Inscripciones> findByEventoId(Long eventoId);
    boolean existsByEventoIdAndUsuarioId(Integer eventoId, Long usuarioId);
    boolean existsByUsuarioIdAndEventoId(Long usuarioId, Long eventoId);
}
