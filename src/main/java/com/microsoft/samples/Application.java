package com.microsoft.samples;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * An example Spring Boot application.
 *
 * @see <a href="https://spring.io/guides/gs/spring-boot-docker/">Spring Boot with Docker</a>
 */
@SpringBootApplication
@RestController
public class Application {
    @RequestMapping("/")
    public String home() {
        return "Hello, Societe Generale!";
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
