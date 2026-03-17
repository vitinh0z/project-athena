package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Move {

    private final UUID id;

    private final UUID gameId;
    private final Integer moveNumber;
    private final String san;
    private final String uci;
    private final String fenBefore;
    private final String fenAfter;
    private final String evaluation;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
