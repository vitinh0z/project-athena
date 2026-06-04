package io.github.vitinh0z.chessanalyzer.infrastructure.config.properties;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.lichess")
public record LichessProperties(
        @NotBlank String apiToken,
        @NotBlank String baseUrl
) {}
