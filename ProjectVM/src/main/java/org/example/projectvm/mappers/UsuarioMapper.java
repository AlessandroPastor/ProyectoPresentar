package org.example.projectvm.mappers;


import org.example.projectvm.dtos.UsuarioCrearDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;



@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    @Mapping(source = "carrera.id", target = "carreraId")
    @Mapping(source = "carrera.nombre_facultad", target = "carreraNombre")
    UsuarioDto toUserDto(Usuario user);

    @Mapping(target = "password", ignore = true)
    Usuario usuarioCrearDtoToUser(UsuarioCrearDto usuarioCrearDto);

}
