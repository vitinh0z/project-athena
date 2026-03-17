package com.athena.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Game {

    private UUID id;

    private UUID userId;
    private String lichessGameId;
    private String whitePlayer;
    private String blackPlayer;
    private String result;
    private String pgn;
    private String initialFen;
    private Integer totalMoves;
    private LocalDateTime playedAt;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
