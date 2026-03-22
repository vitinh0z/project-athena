package io.github.vitinh0z.chessanalyzer.api.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record GameDTO(
        UUID id,
        UUID userId,
        String lichessGameId,
        String whitePlayer,
        String blackPlayer,
        String result,
        String pgn,
        String initialFen,
        Integer totalMoves,
        LocalDateTime playedAt,
        LocalDateTime createdAt) {}
