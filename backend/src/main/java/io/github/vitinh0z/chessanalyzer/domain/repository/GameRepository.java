package io.github.vitinh0z.chessanalyzer.domain.repository;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GameRepository {

    Game save(Game game);

    Optional<Game> findById(UUID id);

    Optional<Game> findByLichessGameId(String lichessGameId);

    List<Game> findByUserId(UUID userId);

    boolean existsByLichessGameId(String lichessGameId);
}
