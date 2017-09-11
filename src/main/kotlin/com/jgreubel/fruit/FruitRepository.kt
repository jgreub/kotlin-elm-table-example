package com.jgreubel.fruit

import org.springframework.data.jpa.repository.JpaRepository

interface FruitRepository: JpaRepository<Fruit, Int>