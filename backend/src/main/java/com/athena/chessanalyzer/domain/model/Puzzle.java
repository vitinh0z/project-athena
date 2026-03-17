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
public class Puzzle {

    private UUID id;

    private UUID userId;
    private String lichessPuzzleId;
    private String fen;
    private String solution;
    private String motifs;
    private Integer rating;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
