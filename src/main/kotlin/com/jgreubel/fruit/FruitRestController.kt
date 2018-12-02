package com.jgreubel.fruit

import com.querydsl.core.types.Predicate
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.querydsl.binding.QuerydslPredicate
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class FruitRestController(val fruitRepository: FruitRepository) {

    @GetMapping("/fruit")
    fun findAll(@QuerydslPredicate(bindings = FruitQuerydslBindingCustomizer::class) predicate: Predicate?, pageable: Pageable): Page<Fruit> {
        return if (predicate != null) fruitRepository.findAll(predicate, pageable) else fruitRepository.findAll(pageable)
    }

}