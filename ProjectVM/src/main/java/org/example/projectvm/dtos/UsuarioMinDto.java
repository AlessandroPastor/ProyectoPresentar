package org.example.projectvm.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UsuarioMinDto {
    private Long id;
    private String nombres;
    private String apellidos;
    private String correo;
    private String dni;
    private String codigo;

}
