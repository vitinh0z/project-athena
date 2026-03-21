package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

interface GameJpaRepository extends JpaRepository<Game, UUID> {

    Optional<Game> findByLichessGameId(String lichessGameId);

    List<Game> findByUserIdOrderByPlayedAtDesc(UUID userId);

    boolean existsByLichessGameId(String lichessGameId);
}

