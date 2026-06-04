package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
@Getter
@Builder
@AllArgsConstructor
public class Analysis {

    private final UUID id;

    private final UUID gameId;
    private final String summary;
    private final String bestMove;
    private final String worstMove;
    private final String engineName;
    private final Integer accuracyScore;
    private final Integer blunders;
    private final Integer mistakes;
    private final Integer inaccuracies;

    @Builder.Default
    private final LocalDateTime analyzedAt = LocalDateTime.now();
}
