package org.example.projectvm.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Entity
@Data
public class Carreras {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String nombre_facultad;
    @JsonIgnore
    @OneToMany(mappedBy = "carrera",cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Usuario> usuarios = new ArrayList<>();

}
