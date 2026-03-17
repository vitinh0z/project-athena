package io.github.vitinh0z.chessanalyzer.domain.model;

import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class OpeningStats {

    private final UUID id;

    private final UUID openingId;
    private final Integer whiteWins;
    private final Integer blackWins;
    private final Integer draws;
    private final Integer gamesCount;
}
