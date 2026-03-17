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
@Table(name = "openings")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Opening {

    @Id
    @GeneratedValue
    @UuidGenerator(style = UuidGenerator.Style.VERSION_7)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "eco_code", length = 10)
    private String ecoCode;

    @Column(name = "name", nullable = false, length = 150)
    private String name;

    @Column(name = "variation", length = 150)
    private String variation;

    @Column(name = "fen", columnDefinition = "TEXT")
    private String fen;
}
