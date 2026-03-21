package io.github.vitinh0z.chessanalyzer.application.mapper;

import io.github.vitinh0z.chessanalyzer.api.dto.GameDTO;
import io.github.vitinh0z.chessanalyzer.domain.model.Game;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class GameMapper {

    public GameDTO toDto(Game domain) {
        if (domain == null) {
            return null;
        }

        return new GameDTO(
                domain.getId(),
                domain.getUserId(),
                domain.getLichessGameId(),
                domain.getWhitePlayer(),
                domain.getBlackPlayer(),
                domain.getResult(),
                domain.getPgn(),
                domain.getInitialFen(),
                domain.getTotalMoves(),
                domain.getPlayedAt(),
                domain.getCreatedAt());
    }

    public List<GameDTO> toDtoList(List<Game> domains) {
        if (domains == null || domains.isEmpty()) {
            return List.of();
        }
        return domains.stream().map(this::toDto).toList();
    }
}
