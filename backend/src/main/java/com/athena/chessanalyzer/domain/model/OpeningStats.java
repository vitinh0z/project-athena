package com.athena.chessanalyzer.domain.model;

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
public class OpeningStats {

    private UUID id;

    private UUID openingId;
    private Integer whiteWins;
    private Integer blackWins;
    private Integer draws;
    private Integer gamesCount;
}
