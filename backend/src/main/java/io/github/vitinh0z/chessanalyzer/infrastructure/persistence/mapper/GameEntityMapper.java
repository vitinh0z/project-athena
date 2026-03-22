package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper;

import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class GameEntityMapper {

    public io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game toEntity(
            Game domain) {
        if (domain == null) {
            return null;
        }

        return io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game.builder()
                .id(domain.getId())
                .userId(domain.getUserId())
                .lichessGameId(domain.getLichessGameId())
                .whitePlayer(domain.getWhitePlayer())
                .blackPlayer(domain.getBlackPlayer())
                .result(domain.getResult())
                .pgn(domain.getPgn())
                .initialFen(domain.getInitialFen())
                .totalMoves(domain.getTotalMoves())
                .playedAt(domain.getPlayedAt())
                .createdAt(domain.getCreatedAt())
                .build();
    }

    public Game toDomain(
            io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game entity) {
        if (entity == null) {
            return null;
        }

        return Game.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .lichessGameId(entity.getLichessGameId())
                .whitePlayer(entity.getWhitePlayer())
                .blackPlayer(entity.getBlackPlayer())
                .result(entity.getResult())
                .pgn(entity.getPgn())
                .initialFen(entity.getInitialFen())
                .totalMoves(entity.getTotalMoves())
                .playedAt(entity.getPlayedAt())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    public List<Game> toDomainList(
            List<io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.Game> entities) {
        if (entities == null || entities.isEmpty()) {
            return List.of();
        }
        return entities.stream().map(this::toDomain).toList();
    }
}
