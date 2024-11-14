package org.example.projectvm.controller;


import lombok.RequiredArgsConstructor;
import org.example.projectvm.dtos.EventoDto;
import org.example.projectvm.entity.Evento;
import org.example.projectvm.service.EventoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/evento")
public class EventoController {

    @Autowired
    private EventoService eventoService;

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping()
    public ResponseEntity<List<Evento>> list(){
        return ResponseEntity.ok().body(eventoService.listar());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping()
    public ResponseEntity<Evento> save(@RequestBody Evento evento){
        return  ResponseEntity.ok(eventoService.guardar(evento));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping()
    public ResponseEntity<Evento> update(@RequestBody Evento evento){
        return  ResponseEntity.ok(eventoService.actualizar(evento));
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping("/{id}")
    public ResponseEntity<Evento> listById(@PathVariable(required = true) Integer id){
        return ResponseEntity.ok().body(eventoService.listaPorld(id).get());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<List<Evento>> eliminar(@PathVariable(required = true) Integer id){
        eventoService.eliminar(id);
        return ResponseEntity.ok(eventoService.listar());
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping("/{id}/inscripciones")
    public ResponseEntity<EventoDto> obtenerEventoConInscripciones(@PathVariable Integer id) {
        EventoDto eventoDto = eventoService.obtenerEventoConInscripciones(id);
        return ResponseEntity.ok(eventoDto);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}/finalizar")
    public ResponseEntity<String> finalizarEvento(@PathVariable Integer id) {
        eventoService.finalizarEvento(id);
        return ResponseEntity.ok("Evento finalizado y horas transferidas a los usuarios inscritos.");
    }
}
