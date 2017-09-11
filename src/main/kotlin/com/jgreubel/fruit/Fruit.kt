package com.jgreubel.fruit

import javax.persistence.Entity
import javax.persistence.Id

@Entity
data class Fruit(
        @Id
        val id: Long,
        val name: String
)