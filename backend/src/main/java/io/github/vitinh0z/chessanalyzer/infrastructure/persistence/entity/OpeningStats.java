package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table(name = "opening_stats")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OpeningStats {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "opening_id", nullable = false)
    private UUID openingId;

    @Column(name = "white_wins")
    private Integer whiteWins;

    @Column(name = "black_wins")
    private Integer blackWins;

    @Column(name = "draws")
    private Integer draws;

    @Column(name = "games_count")
    private Integer gamesCount;
}
