package com.jgreubel.fruit

import com.querydsl.core.types.dsl.StringPath
import org.springframework.data.querydsl.binding.QuerydslBinderCustomizer
import org.springframework.data.querydsl.binding.QuerydslBindings
import org.springframework.data.querydsl.binding.SingleValueBinding

class FruitQuerydslBindingCustomizer: QuerydslBinderCustomizer<QFruit> {
    override fun customize(bindings: QuerydslBindings?, root: QFruit?) {
        bindings?.bind(String::class.java)?.first(SingleValueBinding<StringPath, String> { path, value -> path.containsIgnoreCase(value) })
        bindings?.excluding(root?.id)
    }
}