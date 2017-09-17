package com.jgreubel

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.data.web.config.EnableSpringDataWebSupport

@SpringBootApplication
@EnableSpringDataWebSupport
class KotlineElmTableExampleApplication

fun main(args: Array<String>) {
    SpringApplication.run(KotlineElmTableExampleApplication::class.java, *args)
}
