package io.github.vitinh0z.chessanalyzer.application.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class GameMapperTest {

    private final GameMapper mapper = new GameMapper();

    @Test
    void shouldMapToDtoFieldByField() {
        var domain = sampleDomain("lichess-1");

        var dto = mapper.toDto(domain);

        assertNotNull(dto);
        assertEquals(domain.getId(), dto.id());
        assertEquals(domain.getUserId(), dto.userId());
        assertEquals(domain.getLichessGameId(), dto.lichessGameId());
        assertEquals(domain.getWhitePlayer(), dto.whitePlayer());
        assertEquals(domain.getBlackPlayer(), dto.blackPlayer());
        assertEquals(domain.getResult(), dto.result());
        assertEquals(domain.getPgn(), dto.pgn());
        assertEquals(domain.getInitialFen(), dto.initialFen());
        assertEquals(domain.getTotalMoves(), dto.totalMoves());
        assertEquals(domain.getPlayedAt(), dto.playedAt());
        assertEquals(domain.getCreatedAt(), dto.createdAt());
    }

    @Test
    void shouldReturnNullWhenDomainIsNull() {
        assertNull(mapper.toDto(null));
    }

    @Test
    void shouldMapListToDtoList() {
        var domain = sampleDomain("lichess-2");

        var result = mapper.toDtoList(List.of(domain));

        assertEquals(1, result.size());
        assertEquals("lichess-2", result.getFirst().lichessGameId());
    }

    @Test
    void shouldReturnEmptyListForNullOrEmptyInput() {
        assertTrue(mapper.toDtoList(null).isEmpty());
        assertTrue(mapper.toDtoList(List.of()).isEmpty());
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
}

