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
public class Report {

    private UUID id;

    private UUID userId;
    private UUID gameId;
    private UUID analysisId;
    private String type;
    private String title;
    private String content;
    private String status;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
