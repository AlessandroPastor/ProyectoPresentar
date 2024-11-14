package org.example.projectvm.service.impl;

import org.example.projectvm.dtos.EventoDto;
import org.example.projectvm.dtos.InscripcionDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.dtos.UsuarioMinDto;
import org.example.projectvm.entity.Evento;
import org.example.projectvm.entity.Usuario;
import org.example.projectvm.exceptions.AppException;
import org.example.projectvm.repository.EventoRepository;
import org.example.projectvm.repository.UsuarioRepository;
import org.example.projectvm.service.EventoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service

public class EventoServiceImpl implements EventoService {

    @Autowired
    private EventoRepository eventoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;
    @Override
    public List<Evento> listar() {
        return eventoRepository.findAll();
    }

    @Override
    public Evento guardar(Evento evento) {
        return eventoRepository.save(evento);
    }

    @Override
    public Evento actualizar(Evento evento) {
        return eventoRepository.save(evento);
    }

    @Override
    public Optional<Evento> listaPorld(Integer id) {
        return eventoRepository.findById(id);
    }

    @Override
    public void eliminar(Integer id) {
        eventoRepository.deleteById(id);
    }

    public EventoDto obtenerEventoConInscripciones(Integer eventoId) {
        Evento evento = eventoRepository.findEventoWithInscripcionesAndUsuarios(eventoId)
                .orElseThrow(() -> new RuntimeException("Evento no encontrado"));

        List<InscripcionDto> inscripcionesDto = evento.getInscripciones().stream()
                .map(inscripcion -> {
                    List<UsuarioMinDto> usuarioInfo = new ArrayList<>();
                    if (inscripcion.getUsuario() != null) {
                        Usuario usuario = inscripcion.getUsuario();
                        usuarioInfo.add(new UsuarioMinDto(
                                usuario.getId(),
                                usuario.getNombres(),
                                usuario.getApellidos(),
                                usuario.getCorreo(),
                                usuario.getDni(),
                                usuario.getCodigo()
                        ));
                    }
                    return new InscripcionDto(
                            inscripcion.getId() != null ? inscripcion.getId().longValue() : null,
                            inscripcion.getUsuario() != null ? inscripcion.getUsuario().getId() : null,
                            inscripcion.getUsuario() != null ? inscripcion.getUsuario().getNombres() : null,
                            inscripcion.getEstado(),
                            inscripcion.getFechaInscripcion(),
                            usuarioInfo
                    );
                })
                .collect(Collectors.toList());

        return new EventoDto(
                evento.getId() != null ? evento.getId().longValue() : null,
                evento.getNombre_del_evento(),
                evento.getDireccion_lugar(),
                evento.getReferencia(),
                evento.getFecha(),
                evento.getHora(),
                evento.getHoras_obtenidas(),
                evento.getObservaciones(),
                evento.getStatus().name(),
                inscripcionesDto
        );
    }


    @Override
    public void finalizarEvento(Integer eventoId) {
        Evento evento = eventoRepository.findById(eventoId)
                .orElseThrow(() -> new AppException("Evento no encontrado", HttpStatus.NOT_FOUND));

        if (evento.getStatus() == Evento.Status.Activo) {
            evento.setStatus(Evento.Status.Finalizado);

            int horasObtenidas = Integer.parseInt(evento.getHoras_obtenidas());

            evento.getInscripciones().forEach(inscripcion -> {
                Usuario usuario = inscripcion.getUsuario();
                int horasParaAsignar = (inscripcion.getHorasEditadas() != null) ? inscripcion.getHorasEditadas() : horasObtenidas;

                int horasActuales = Integer.parseInt(usuario.getCantidad_de_horas());
                usuario.setCantidad_de_horas(String.valueOf(horasActuales + horasParaAsignar));
                usuarioRepository.save(usuario);
            });

            eventoRepository.save(evento);
        } else {
            throw new AppException("El evento ya está finalizado", HttpStatus.BAD_REQUEST);
        }
    }



    @Override
    public Optional<Evento> obtenerPorId(Integer eventoId) {
        return Optional.empty();
    }

}
