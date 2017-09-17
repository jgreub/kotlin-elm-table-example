package com.jgreubel.fruit

import com.querydsl.core.types.Predicate
import org.springframework.data.querydsl.binding.QuerydslPredicate
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class FruitRestController(val fruitRepository: FruitRepository) {

    @GetMapping("/fruit")
    fun findAll(@QuerydslPredicate predicate: Predicate): Iterable<Fruit> {
        return fruitRepository.findAll(predicate)
    }

}