package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper.GameEntityMapper;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class GameRepository implements io.github.vitinh0z.chessanalyzer.domain.repository.GameRepository {

    private final GameJpaRepository gameJpaRepository;
    private final GameEntityMapper mapper;

    @Override
    public Game save(Game game) {
        var entityToSave = mapper.toEntity(game);
        var savedEntity = gameJpaRepository.save(entityToSave);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<Game> findById(UUID id) {
        return gameJpaRepository.findById(id).map(mapper::toDomain);
    }

    @Override
    public Optional<Game> findByLichessGameId(String lichessGameId) {
        return gameJpaRepository.findByLichessGameId(lichessGameId).map(mapper::toDomain);
    }

    @Override
    public List<Game> findByUserId(UUID userId) {
        return mapper.toDomainList(gameJpaRepository.findByUserIdOrderByPlayedAtDesc(userId));
    }

    @Override
    public boolean existsByLichessGameId(String lichessGameId) {
        return gameJpaRepository.existsByLichessGameId(lichessGameId);
    }
}
