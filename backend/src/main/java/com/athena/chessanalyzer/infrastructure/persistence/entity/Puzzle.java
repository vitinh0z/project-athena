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
@Table(name = "puzzles")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Puzzle {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "lichess_puzzle_id", unique = true, length = 100)
    private String lichessPuzzleId;

    @Column(name = "fen", nullable = false, columnDefinition = "TEXT")
    private String fen;

    @Column(name = "solution", columnDefinition = "TEXT")
    private String solution;

    @Column(name = "motifs", length = 255)
    private String motifs;

    @Column(name = "rating")
    private Integer rating;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
