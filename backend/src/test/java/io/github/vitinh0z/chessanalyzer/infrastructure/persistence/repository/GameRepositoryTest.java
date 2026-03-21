package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper.GameEntityMapper;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class GameRepositoryTest {

    @Mock
    private GameJpaRepository gameJpaRepository;

    @Mock
    private GameEntityMapper mapper;

    @InjectMocks
    private GameRepository repository;

    @Test
    void shouldSaveUsingMapperAndJpaRepository() {
        var domain = sampleDomain("game-save");
        var entity = sampleEntity("game-save");
        var savedEntity = sampleEntity("game-save");

        when(mapper.toEntity(domain)).thenReturn(entity);
        when(gameJpaRepository.save(entity)).thenReturn(savedEntity);
        when(mapper.toDomain(savedEntity)).thenReturn(domain);

        var result = repository.save(domain);

        assertEquals(domain, result);
        verify(mapper).toEntity(domain);
        verify(gameJpaRepository).save(entity);
        verify(mapper).toDomain(savedEntity);
    }

    @Test
    void shouldReturnMappedGamesByUserId() {
        var userId = UUID.randomUUID();
        var entity = sampleEntity("game-by-user");
        var domain = sampleDomain("game-by-user");

        when(gameJpaRepository.findByUserIdOrderByPlayedAtDesc(userId)).thenReturn(List.of(entity));
        when(mapper.toDomainList(List.of(entity))).thenReturn(List.of(domain));

        var result = repository.findByUserId(userId);

        assertEquals(1, result.size());
        assertEquals("game-by-user", result.getFirst().getLichessGameId());
    }

    @Test
    void shouldFindByLichessIdAndCheckExists() {
        var lichessId = "lichess-1";
        var entity = sampleEntity(lichessId);
        var domain = sampleDomain(lichessId);

        when(gameJpaRepository.findByLichessGameId(lichessId)).thenReturn(Optional.of(entity));
        when(mapper.toDomain(entity)).thenReturn(domain);
        when(gameJpaRepository.existsByLichessGameId(lichessId)).thenReturn(true);

        var found = repository.findByLichessGameId(lichessId);
        var exists = repository.existsByLichessGameId(lichessId);

        assertTrue(found.isPresent());
        assertEquals(lichessId, found.get().getLichessGameId());
        assertTrue(exists);
    }

    private static Game sampleDomain(String lichessId) {
        return Game.builder()
                .id(UUID.randomUUID())
                .userId(UUID.randomUUID())
                .lichessGameId(lichessId)
                .whitePlayer("white")
                .blackPlayer("black")
                .result("1-0")
                .pgn("1. d4 d5")
                .initialFen("startpos")
                .totalMoves(36)
                .playedAt(LocalDateTime.now().minusDays(1))
                .createdAt(LocalDateTime.now())
                .build();
    }

    private static io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game sampleEntity(String lichessId) {
        return io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game.builder()
                .id(UUID.randomUUID())
                .userId(UUID.randomUUID())
                .lichessGameId(lichessId)
                .whitePlayer("white")
                .blackPlayer("black")
                .result("1-0")
                .pgn("1. d4 d5")
                .initialFen("startpos")
                .totalMoves(36)
                .playedAt(LocalDateTime.now().minusDays(1))
                .createdAt(LocalDateTime.now())
                .build();
    }
}

