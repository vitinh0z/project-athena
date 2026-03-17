package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Puzzle {

    private final UUID id;

    private final UUID userId;
    private final String lichessPuzzleId;
    private final String fen;
    private final String solution;
    private final String motifs;
    private final Integer rating;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
