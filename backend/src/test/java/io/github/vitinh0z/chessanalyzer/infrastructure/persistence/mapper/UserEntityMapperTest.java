package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import io.github.vitinh0z.chessanalyzer.domain.model.User;
import java.time.LocalDateTime;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class UserEntityMapperTest {

    private final UserEntityMapper mapper = new UserEntityMapper();

    @Test
    void shouldMapDomainToEntityAndBack() {
        var id = UUID.randomUUID();
        var createdAt = LocalDateTime.now().minusDays(2);
        var updatedAt = LocalDateTime.now();

        var domain = User.builder()
                .id(id)
                .username("john")
                .email("john@example.com")
                .passwordHash("hash")
                .createdAt(createdAt)
                .updatedAt(updatedAt)
                .build();

        var entity = mapper.toEntity(domain);
        assertNotNull(entity);
        assertEquals(id, entity.getId());
        assertEquals("john@example.com", entity.getEmail());

        var mappedBack = mapper.toDomain(entity);
        assertNotNull(mappedBack);
        assertEquals(domain.getUsername(), mappedBack.getUsername());
        assertEquals(domain.getPasswordHash(), mappedBack.getPasswordHash());
        assertEquals(domain.getUpdatedAt(), mappedBack.getUpdatedAt());
    }
}

