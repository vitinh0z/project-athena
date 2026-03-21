package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import io.github.vitinh0z.chessanalyzer.domain.model.User;
import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper.UserEntityMapper;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class UserRepositoryTest {

    @Mock
    private UserJpaRepository userJpaRepository;

    @Mock
    private UserEntityMapper mapper;

    @InjectMocks
    private UserRepository repository;

    @Test
    void shouldSaveUsingMapperAndJpaRepository() {
        var domain = sampleDomain("john@example.com");
        var entity = sampleEntity("john@example.com");
        var savedEntity = sampleEntity("john@example.com");

        when(mapper.toEntity(domain)).thenReturn(entity);
        when(userJpaRepository.save(entity)).thenReturn(savedEntity);
        when(mapper.toDomain(savedEntity)).thenReturn(domain);

        var result = repository.save(domain);

        assertEquals(domain, result);
        verify(mapper).toEntity(domain);
        verify(userJpaRepository).save(entity);
        verify(mapper).toDomain(savedEntity);
    }

    @Test
    void shouldFindByEmailAndCheckExists() {
        var email = "john@example.com";
        var entity = sampleEntity(email);
        var domain = sampleDomain(email);

        when(userJpaRepository.findByEmail(email)).thenReturn(Optional.of(entity));
        when(mapper.toDomain(entity)).thenReturn(domain);
        when(userJpaRepository.existsByEmail(email)).thenReturn(true);

        var found = repository.findByEmail(email);
        var exists = repository.existsByEmail(email);

        assertTrue(found.isPresent());
        assertEquals(email, found.get().getEmail());
        assertTrue(exists);
    }

    private static User sampleDomain(String email) {
        return User.builder()
                .id(UUID.randomUUID())
                .username("john")
                .email(email)
                .passwordHash("hash")
                .createdAt(LocalDateTime.now().minusDays(1))
                .updatedAt(LocalDateTime.now())
                .build();
    }

    private static io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User sampleEntity(String email) {
        return io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User.builder()
                .id(UUID.randomUUID())
                .username("john")
                .email(email)
                .passwordHash("hash")
                .createdAt(LocalDateTime.now().minusDays(1))
                .updatedAt(LocalDateTime.now())
                .build();
    }
}

