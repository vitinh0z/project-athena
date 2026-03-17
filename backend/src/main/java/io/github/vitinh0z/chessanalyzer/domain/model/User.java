package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class User {

    private final UUID id;

    private final String username;
    private final String email;
    private final String passwordHash;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();

    @Builder.Default
    private final LocalDateTime updatedAt = LocalDateTime.now();
}
