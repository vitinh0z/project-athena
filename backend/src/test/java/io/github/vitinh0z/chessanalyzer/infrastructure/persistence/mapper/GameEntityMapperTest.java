package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class GameEntityMapperTest {

    private final GameEntityMapper mapper = new GameEntityMapper();

    @Test
    void shouldMapDomainToEntityAndBack() {
        var playedAt = LocalDateTime.now().minusDays(1);
        var createdAt = LocalDateTime.now();
        var id = UUID.randomUUID();
        var userId = UUID.randomUUID();

        var domain = Game.builder()
                .id(id)
                .userId(userId)
                .lichessGameId("abc123")
                .whitePlayer("white")
                .blackPlayer("black")
                .result("1-0")
                .pgn("1. e4 e5")
                .initialFen("startpos")
                .totalMoves(42)
                .playedAt(playedAt)
                .createdAt(createdAt)
                .build();

        var entity = mapper.toEntity(domain);
        assertNotNull(entity);
        assertEquals(id, entity.getId());
        assertEquals(userId, entity.getUserId());

        var mappedBack = mapper.toDomain(entity);
        assertNotNull(mappedBack);
        assertEquals(domain.getLichessGameId(), mappedBack.getLichessGameId());
        assertEquals(domain.getTotalMoves(), mappedBack.getTotalMoves());
        assertEquals(domain.getCreatedAt(), mappedBack.getCreatedAt());
    }

    @Test
    void shouldMapEntityListToDomainList() {
        var entity = io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game.builder()
                .id(UUID.randomUUID())
                .userId(UUID.randomUUID())
                .lichessGameId("game-1")
                .build();

        var result = mapper.toDomainList(List.of(entity));

        assertEquals(1, result.size());
        assertEquals("game-1", result.getFirst().getLichessGameId());
    }
}

