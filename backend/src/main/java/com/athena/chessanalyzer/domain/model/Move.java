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
public class Move {

    private UUID id;

    private UUID gameId;
    private Integer moveNumber;
    private String san;
    private String uci;
    private String fenBefore;
    private String fenAfter;
    private String evaluation;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
