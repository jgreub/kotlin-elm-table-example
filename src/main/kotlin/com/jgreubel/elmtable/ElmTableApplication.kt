package com.jgreubel.elmtable

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication
class ElmTableApplication

fun main(args: Array<String>) {
    SpringApplication.run(ElmTableApplication::class.java, *args)
}
