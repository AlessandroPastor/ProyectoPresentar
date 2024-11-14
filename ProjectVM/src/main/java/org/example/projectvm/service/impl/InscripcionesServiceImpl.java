package org.example.projectvm.service.impl;

import org.example.projectvm.entity.Evento;
import org.example.projectvm.entity.Inscripciones;
import org.example.projectvm.entity.Usuario;
import org.example.projectvm.repository.EventoRepository;
import org.example.projectvm.repository.InscripcionesRepository;
import org.example.projectvm.repository.UsuarioRepository;
import org.example.projectvm.service.InscripcionesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;


@Service
public class InscripcionesServiceImpl implements InscripcionesService {
    @Autowired
    private InscripcionesRepository inscripcionesRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EventoRepository eventoRepository;


    @Override
    public List<Inscripciones> listar() {
        return inscripcionesRepository.findAll();
    }

    @Override
    public Inscripciones guardar(Inscripciones inscripciones) {
        return inscripcionesRepository.save(inscripciones);
    }

    @Override
    public Inscripciones actualizar(Inscripciones inscripciones) {

        return inscripcionesRepository.save(inscripciones);
    }

    @Override
    public Optional<Inscripciones> listaPorld(Integer id) {
        return inscripcionesRepository.findById(id);
    }

    @Override
    public void eliminar(Integer id) {
        inscripcionesRepository.deleteById(id);
    }

    @Override
    public Optional<Inscripciones> modificarHorasInscripcion(Long inscripcionId, String nuevasHoras) {
        Optional<Inscripciones> inscripcionOpt = inscripcionesRepository.findById(Math.toIntExact(inscripcionId));

        if (inscripcionOpt.isPresent()) {
            Inscripciones inscripcion = inscripcionOpt.get();
            inscripcion.setHorasEditadas(Integer.valueOf(nuevasHoras));
            inscripcionesRepository.save(inscripcion);
            return Optional.of(inscripcion);
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Inscripción no encontrada");
        }
    }

    public Optional<Inscripciones> crearInscripcion(Integer usuarioId, Integer eventoId) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findById(Long.valueOf(usuarioId));
        Optional<Evento> eventoOpt = eventoRepository.findById(eventoId);

        if (usuarioOpt.isPresent() && eventoOpt.isPresent()) {
            Inscripciones inscripcion = new Inscripciones();
            inscripcion.setUsuario(usuarioOpt.get());
            inscripcion.setEvento(eventoOpt.get());
            inscripcion.setFechaInscripcion(LocalDate.now());
            inscripcion.setEstado("Activo");
            inscripcion.setHorasEditadas(0);

            return Optional.of(inscripcionesRepository.save(inscripcion));
        } else {
            return Optional.empty();
        }
    }

    @Override
    public List<Inscripciones> obtenerTodas() {
        return null;
    }

    @Override
    public Optional<Inscripciones> obtenerPorId(Integer id) {
        return Optional.empty();
    }

    public String inscribirUsuarioAEvento(Integer usuarioId, Integer eventoId) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findById(Long.valueOf(usuarioId));
        Optional<Evento> eventoOpt = eventoRepository.findById(eventoId);

        if (usuarioOpt.isEmpty() || eventoOpt.isEmpty()) {
            throw new RuntimeException("Usuario o evento no encontrado");
        }

        Usuario usuario = usuarioOpt.get();
        Evento evento = eventoOpt.get();

        boolean isAlreadyRegistered = inscripcionesRepository.existsByEventoIdAndUsuarioId(eventoId, usuario.getId());
        if (isAlreadyRegistered) {
            return "El usuario " + usuario.getNombres() + " ya está inscrito en el evento " + evento.getNombre_del_evento();
        }

        Inscripciones inscripcion = new Inscripciones();
        inscripcion.setUsuario(usuario);
        inscripcion.setEvento(evento);
        inscripcion.setUsuario_inscrito(usuario.getNombres());
        inscripcion.setEstado("Activo");
        inscripcion.setFechaInscripcion(LocalDate.now());

        inscripcionesRepository.save(inscripcion);

        return "Usuario " + usuario.getNombres() + " inscrito exitosamente al evento " + evento.getNombre_del_evento();
    }

    public boolean isUserRegisteredForEvent(Long usuarioId, Long eventoId) {

        return inscripcionesRepository.existsByUsuarioIdAndEventoId(usuarioId, eventoId);
    }

}
