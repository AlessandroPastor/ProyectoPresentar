/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package org.example.projectvm.service.impl;

import org.example.projectvm.entity.Rol;
import org.example.projectvm.repository.RolRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Optional;


@Service
@Transactional
public class RolService {
    @Autowired
    RolRepository rolRepository;
    public Optional<Rol> getByRolNombre(Rol.RolNombre rolNombre){
        return rolRepository.findByRolNombre(rolNombre);
    }
    public void save(Rol rol){
        rolRepository.save(rol);
    }    
}
