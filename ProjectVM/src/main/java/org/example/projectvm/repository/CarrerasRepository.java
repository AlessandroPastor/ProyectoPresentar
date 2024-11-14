package org.example.projectvm.repository;

import org.example.projectvm.entity.Carreras;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface CarrerasRepository extends JpaRepository<Carreras, Integer> {

    @Query("SELECT c FROM Carreras c LEFT JOIN FETCH c.usuarios WHERE c.id = :id")
    Optional<Carreras> findByIdWithUsuarios(@Param("id") Integer id);
}
