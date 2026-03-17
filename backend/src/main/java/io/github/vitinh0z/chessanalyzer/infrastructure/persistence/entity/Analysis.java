package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table(name = "analysis")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Analysis {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "game_id", nullable = false)
    private UUID gameId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "summary", columnDefinition = "TEXT")
    private String summary;

    @Column(name = "best_move", length = 20)
    private String bestMove;

    @Column(name = "worst_move", length = 20)
    private String worstMove;

    @Column(name = "engine_name", length = 100)
    private String engineName;

    @Column(name = "accuracy_score")
    private Integer accuracyScore;

    @Column(name = "blunders")
    private Integer blunders;

    @Column(name = "mistakes")
    private Integer mistakes;

    @Column(name = "inaccuracies")
    private Integer inaccuracies;

    @CreationTimestamp
    @Column(name = "analyzed_at", nullable = false, updatable = false)
    private LocalDateTime analyzedAt;
}
