package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import io.github.vitinh0z.chessanalyzer.domain.model.User;
import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper.UserEntityMapper;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class UserRepository implements io.github.vitinh0z.chessanalyzer.domain.repository.UserRepository {

    private final UserJpaRepository userJpaRepository;
    private final UserEntityMapper mapper;

    @Override
    public User save(User user) {
        var entityToSave = mapper.toEntity(user);
        var savedEntity = userJpaRepository.save(entityToSave);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<User> findById(UUID id) {
        return userJpaRepository.findById(id).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userJpaRepository.findByEmail(email).map(mapper::toDomain);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userJpaRepository.existsByEmail(email);
    }
}
