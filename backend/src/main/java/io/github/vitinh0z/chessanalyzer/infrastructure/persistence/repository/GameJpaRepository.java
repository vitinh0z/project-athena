package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

interface GameJpaRepository extends JpaRepository<Game, UUID> {

    Optional<Game> findByLichessGameId(String lichessGameId);

    boolean existsByLichessGameId(String lichessGameId);
}

