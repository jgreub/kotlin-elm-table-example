package com.jgreubel

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.data.web.config.EnableSpringDataWebSupport

@SpringBootApplication
@EnableSpringDataWebSupport
class KotlinElmTableExampleApplication

fun main(args: Array<String>) {
    SpringApplication.run(KotlinElmTableExampleApplication::class.java, *args)
}
