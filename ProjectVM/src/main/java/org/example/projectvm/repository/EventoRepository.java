package org.example.projectvm.repository;

import org.example.projectvm.entity.Evento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface EventoRepository extends JpaRepository<Evento, Integer> {

    @Query("SELECT e FROM Evento e " +
            "LEFT JOIN FETCH e.inscripciones i " +
            "LEFT JOIN FETCH i.usuario u " +
            "WHERE e.id = :eventoId")
    Optional<Evento> findEventoWithInscripcionesAndUsuarios(@Param("eventoId") Integer eventoId);


}
