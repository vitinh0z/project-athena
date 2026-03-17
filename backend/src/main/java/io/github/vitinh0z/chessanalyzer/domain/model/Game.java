package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Game {

    private final UUID id;

    private final UUID userId;
    private final String lichessGameId;
    private final String whitePlayer;
    private final String blackPlayer;
    private final String result;
    private final String pgn;
    private final String initialFen;
    private final Integer totalMoves;
    private final LocalDateTime playedAt;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
