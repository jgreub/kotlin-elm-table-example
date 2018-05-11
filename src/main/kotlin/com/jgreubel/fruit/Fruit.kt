package com.jgreubel.fruit

import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.Entity
import javax.persistence.Id

@Entity
data class Fruit(
        @Id
        @JsonIgnore
        val id: Long,
        val name: String,
        val color: String
)