package io.github.vitinh0z.chessanalyzer.api.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record UserDTO(
        UUID id,
        String username,
        String email,
        LocalDateTime createdAt,
        LocalDateTime updatedAt) {}
