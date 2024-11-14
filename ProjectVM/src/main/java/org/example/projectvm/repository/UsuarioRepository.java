package org.example.projectvm.repository;


import org.example.projectvm.entity.Usuario;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    @Query("SELECT u FROM Usuario u JOIN FETCH u.carrera WHERE u.correo = :correo")
    Optional<Usuario> findByCorreoWithCarrera(@Param("correo") String correo);

    @EntityGraph(attributePaths = {"carrera", "inscripciones", "roles"})
    Optional<Usuario> findById(Long id);
    Optional<Usuario> findByCorreo(String correo);
    Optional<Usuario> findByDni(String dni);
    Optional<Usuario> findByCodigo(String codigo);
}
