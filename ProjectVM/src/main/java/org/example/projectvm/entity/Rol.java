package org.example.projectvm.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

public class Rol {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "rol_nombre", nullable = false)
    @Enumerated(EnumType.STRING)
    private RolNombre rolNombre;
    public enum RolNombre {
        ROLE_ADMIN, ROLE_USER
    }

}
