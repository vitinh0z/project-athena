package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class EngineResult {

    private final UUID id;

    private final UUID analysisId;
    private final Integer depth;
    private final Integer multiPv;
    private final Integer mateIn;
    private final Double scoreCp;
    private final String bestMove;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
