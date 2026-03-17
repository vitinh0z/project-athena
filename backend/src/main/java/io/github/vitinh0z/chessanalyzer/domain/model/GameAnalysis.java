package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class GameAnalysis {

    private final UUID id;

    private final UUID gameId;
    private final UUID analysisId;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
