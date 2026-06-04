package io.github.vitinh0z.chessanalyzer.infrastructure.config.properties;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.llm")
public record LlmProperties(
        @NotBlank String apiKey,
        @NotBlank String provider
) {}
