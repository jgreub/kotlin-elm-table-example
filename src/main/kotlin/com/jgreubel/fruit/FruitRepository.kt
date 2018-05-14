package com.jgreubel.fruit

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.querydsl.QuerydslPredicateExecutor

interface FruitRepository: JpaRepository<Fruit, Int>, QuerydslPredicateExecutor<Fruit>