package org.example.projectvm.dtos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.projectvm.entity.Rol;

import java.util.Set;

@Data
@JsonIgnoreProperties   (ignoreUnknown = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UsuarioDto {

    private Long id;
    private String nombres;
    private String apellidos;
    private String correo;
    private String token;
    private String dni;
    private String codigo;
    private String estado;
    private String cantidad_de_horas;
    private Integer carreraId;
    private String carreraNombre;
    private String rolx;
    private Set<Rol> roles;

    public UsuarioDto(Long id, String nombres, String apellidos, String correo, String dni, String estado, String codigo, String cantidadDeHoras) {
    }

    public UsuarioDto(Long id, String nombres, String apellidos, String correo, String dni, String estado, String codigo, String cantidadDeHoras, Integer id1, String nombreFacultad) {
    }

    public UsuarioDto(Long id, String nombres, String apellidos, String correo, String dni, String codigo) {
    }
}
