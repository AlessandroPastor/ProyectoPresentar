package org.example.projectvm.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;

import java.util.*;

@Entity
@Data
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Evento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String nombre_del_evento;
    private String direccion_lugar;
    private String referencia;
    //Formateamos Para que muestre
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd-MM-yy")
    private Date fecha;
    private String hora;
    private String horas_obtenidas;
    private String observaciones;
    @Enumerated(EnumType.STRING)
    private Evento.Status status;
    public enum Status {
        Activo,
        Finalizado,
    }
    @JsonIgnore
    @OneToMany(mappedBy = "evento", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<Inscripciones> inscripciones = new ArrayList<>();

}
