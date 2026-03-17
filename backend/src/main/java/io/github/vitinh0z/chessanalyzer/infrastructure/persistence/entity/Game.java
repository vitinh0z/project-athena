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
@Table(name = "games")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Game {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "lichess_game_id", unique = true, length = 100)
    private String lichessGameId;

    @Column(name = "white_player", length = 100)
    private String whitePlayer;

    @Column(name = "black_player", length = 100)
    private String blackPlayer;

    @Column(name = "result", length = 20)
    private String result;

    @Column(name = "pgn", columnDefinition = "TEXT")
    private String pgn;

    @Column(name = "initial_fen", columnDefinition = "TEXT")
    private String initialFen;

    @Column(name = "total_moves")
    private Integer totalMoves;

    @Column(name = "played_at")
    private LocalDateTime playedAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
