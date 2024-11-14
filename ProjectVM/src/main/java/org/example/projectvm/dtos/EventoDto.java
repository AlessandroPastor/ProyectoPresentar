package org.example.projectvm.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventoDto {
    private Long id;
    private String nombreDelEvento;
    private String direccionLugar;
    private String referencia;
    private Date fecha;
    private String hora;
    private String horasObtenidas;
    private String observaciones;
    private String status;
    private List<InscripcionDto> inscripciones;
}
