package org.example.projectvm.controller;


import lombok.RequiredArgsConstructor;
import org.example.projectvm.dtos.CarreraDto;
import org.example.projectvm.dtos.EventoDto;
import org.example.projectvm.dtos.UsuarioDto;
import org.example.projectvm.entity.Carreras;
import org.example.projectvm.exceptions.AppException;
import org.example.projectvm.repository.CarrerasRepository;
import org.example.projectvm.service.CarrerasService;
import org.example.projectvm.service.EventoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;
@RequiredArgsConstructor
@RestController
@RequestMapping("/carreras")
public class CarrerasController {


    public CarrerasController(CarrerasService carrerasService) {
        this.carrerasService = carrerasService;
    }
    @Autowired
    private CarrerasService carrerasService;

    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    @GetMapping()
    public ResponseEntity<List<Carreras>> list(){
        return ResponseEntity.ok().body(carrerasService.listar());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping()
    public ResponseEntity<Carreras> save(@RequestBody Carreras carreras){
        return  ResponseEntity.ok(carrerasService.guardar(carreras));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping()
    public ResponseEntity<Carreras> update(@RequestBody Carreras carreras){
        return  ResponseEntity.ok(carrerasService.actualizar(carreras));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<CarreraDto> obtenerCarreraPorId(@PathVariable Integer id) {
        CarreraDto carreraDto = carrerasService.obtenerCarreraConUsuarios(id);
        return ResponseEntity.ok(carreraDto);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<List<Carreras>> eliminar(@PathVariable(required = true) Integer id){
        carrerasService.eliminar(id);
        return ResponseEntity.ok(carrerasService.listar());
    }

}
