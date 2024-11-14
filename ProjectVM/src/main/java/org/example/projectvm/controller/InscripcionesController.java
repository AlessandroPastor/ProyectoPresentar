package org.example.projectvm.controller;


import lombok.RequiredArgsConstructor;
import org.example.projectvm.entity.Inscripciones;
import org.example.projectvm.repository.InscripcionesRepository;
import org.example.projectvm.service.InscripcionesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;


import java.util.List;
@RequiredArgsConstructor
@RestController
@RequestMapping("/inscripciones")
public class InscripcionesController {

    @Autowired
    private InscripcionesService inscripcionesService;

    @Autowired
    private InscripcionesRepository inscripcionesRepository;

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping
    public ResponseEntity<List<Inscripciones>> list(){
        return ResponseEntity.ok().body(inscripcionesService.listar());
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @PostMapping()
    public ResponseEntity<Inscripciones> save(@RequestBody Inscripciones inscripciones){
        return  ResponseEntity.ok(inscripcionesService.guardar(inscripciones));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping()
    public ResponseEntity<Inscripciones> update(@RequestBody Inscripciones inscripciones){
        return  ResponseEntity.ok(inscripcionesService.actualizar(inscripciones));
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping("/{id}")
    public ResponseEntity<Inscripciones> listById(@PathVariable(required = true) Integer id){
        return ResponseEntity.ok().body(inscripcionesService.listaPorld(id).get());
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @DeleteMapping("/{id}")
    public ResponseEntity<List<Inscripciones>> eliminar(@PathVariable(required = true) Integer id){
        inscripcionesService.eliminar(id);
        return ResponseEntity.ok(inscripcionesService.listar());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}/editarHoras")
    public ResponseEntity<String> editarHoras(@PathVariable Integer id, @RequestParam Integer horasEditadas) {
        Inscripciones inscripcion = inscripcionesRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inscripción no encontrada"));

        inscripcion.setHorasEditadas(horasEditadas);
        inscripcionesRepository.save(inscripcion);

        return ResponseEntity.ok("Horas editadas con éxito");
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @PostMapping("/inscribirse")
    public ResponseEntity<String> inscribirseEnEvento(
            @RequestParam Integer usuarioId,
            @RequestParam Integer eventoId) {
        try {
            String resultado = inscripcionesService.inscribirUsuarioAEvento(usuarioId, eventoId);
            return ResponseEntity.ok(resultado);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping("/isRegistered")
    public ResponseEntity<Boolean> isUserRegisteredForEvent(
            @RequestParam Long usuarioId,
            @RequestParam Long eventoId) {
        boolean isRegistered = inscripcionesService.isUserRegisteredForEvent(usuarioId, eventoId);
        return ResponseEntity.ok(isRegistered);
    }

}
