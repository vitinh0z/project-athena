package io.github.vitinh0z.chessanalyzer.shared.util;

import com.github.f4b6a3.uuid.UuidCreator;
import java.util.UUID;

public final class UuidV7Generator {

    private UuidV7Generator() {
    }

    public static UUID next() {
        return UuidCreator.getTimeOrderedEpoch();
    }
}

