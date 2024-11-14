package org.example.projectvm.dtos;

public record UsuarioCrearDto (String nombres, String apellidos, String correo, char[] password, String token, 
String dni, String estado, String codigo, String cantidad_de_horas, Integer carreraId, String rolx) { }
