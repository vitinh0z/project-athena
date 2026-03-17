package io.github.vitinh0z.chessanalyzer.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Report {

    private final UUID id;

    private final UUID userId;
    private final UUID gameId;
    private final UUID analysisId;
    private final String type;
    private final String title;
    private final String content;
    private final ReportStatus status;

    @Builder.Default
    private final LocalDateTime createdAt = LocalDateTime.now();
}
