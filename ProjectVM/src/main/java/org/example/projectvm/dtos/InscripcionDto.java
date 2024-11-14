package org.example.projectvm.dtos;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
public class InscripcionDto {
    private Long id;
    private Long usuarioId;
    private String nombreUsuario;
    private String estado;
    private LocalDate fechaInscripcion;
    private Integer horasEditadas;
    private List<UsuarioMinDto> usuarioinfo;

    public InscripcionDto(Long id, Long usuarioId, String nombreUsuario, String estado, LocalDate fechaInscripcion, List<UsuarioMinDto> usuarioinfo) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.nombreUsuario = nombreUsuario;
        this.estado = estado;
        this.fechaInscripcion = fechaInscripcion;
        this.usuarioinfo = usuarioinfo;
    }

}
