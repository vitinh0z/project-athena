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
public class EngineResult {

    private UUID id;

    private UUID analysisId;
    private Integer depth;
    private Integer multiPv;
    private Integer mateIn;
    private Double scoreCp;
    private String bestMove;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
