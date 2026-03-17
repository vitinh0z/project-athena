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
public class Analysis {

    private UUID id;

    private UUID gameId;
    private UUID userId;
    private String summary;
    private String bestMove;
    private String worstMove;
    private String engineName;
    private Integer accuracyScore;
    private Integer blunders;
    private Integer mistakes;
    private Integer inaccuracies;

    @Builder.Default
    private LocalDateTime analyzedAt = LocalDateTime.now();
}
