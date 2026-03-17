package com.athena.chessanalyzer.infrastructure.persistence.entity;

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
@Table(name = "moves")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Move {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "game_id", nullable = false)
    private UUID gameId;

    @Column(name = "move_number")
    private Integer moveNumber;

    @Column(name = "san", length = 20)
    private String san;

    @Column(name = "uci", length = 20)
    private String uci;

    @Column(name = "fen_before", columnDefinition = "TEXT")
    private String fenBefore;

    @Column(name = "fen_after", columnDefinition = "TEXT")
    private String fenAfter;

    @Column(name = "evaluation", length = 50)
    private String evaluation;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
