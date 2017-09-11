package com.jgreubel.fruit

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class FruitRestController(val fruitRepository: FruitRepository) {

    @GetMapping("/fruit")
    fun findAll() = fruitRepository.findAll()

}