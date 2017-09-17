package com.jgreubel.fruit

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.querydsl.QueryDslPredicateExecutor

interface FruitRepository: JpaRepository<Fruit, Int>, QueryDslPredicateExecutor<Fruit>