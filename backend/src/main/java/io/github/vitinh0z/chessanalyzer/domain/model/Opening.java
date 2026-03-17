package io.github.vitinh0z.chessanalyzer.domain.model;

import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Opening {

    private final UUID id;

    private final String ecoCode;
    private final String name;
    private final String variation;
    private final String fen;
}
