package com.athena.chessanalyzer.domain.model;

import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Opening {

    private UUID id;

    private String ecoCode;
    private String name;
    private String variation;
    private String fen;
}
