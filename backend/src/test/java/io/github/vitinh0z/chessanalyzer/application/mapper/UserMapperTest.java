package io.github.vitinh0z.chessanalyzer.application.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import io.github.vitinh0z.chessanalyzer.domain.model.User;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class UserMapperTest {

    private final UserMapper mapper = new UserMapper();

    @Test
    void shouldMapToDtoWithoutPasswordHash() {
        var domain = User.builder()
                .id(UUID.randomUUID())
                .username("john")
                .email("john@example.com")
                .passwordHash("sensitive-hash")
                .createdAt(LocalDateTime.now().minusDays(1))
                .updatedAt(LocalDateTime.now())
                .build();

        var dto = mapper.toDto(domain);

        assertNotNull(dto);
        assertEquals(domain.getEmail(), dto.email());
        assertEquals(domain.getUsername(), dto.username());
    }

    @Test
    void shouldMapListToDtoList() {
        var domain = User.builder()
                .id(UUID.randomUUID())
                .username("ana")
                .email("ana@example.com")
                .passwordHash("hash")
                .createdAt(LocalDateTime.now().minusDays(1))
                .updatedAt(LocalDateTime.now())
                .build();

        var result = mapper.toDtoList(List.of(domain));

        assertEquals(1, result.size());
        assertEquals("ana@example.com", result.getFirst().email());
    }
}

