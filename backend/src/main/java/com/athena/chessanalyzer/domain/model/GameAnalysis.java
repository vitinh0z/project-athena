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
public class GameAnalysis {

    private UUID id;

    private UUID gameId;
    private UUID analysisId;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
