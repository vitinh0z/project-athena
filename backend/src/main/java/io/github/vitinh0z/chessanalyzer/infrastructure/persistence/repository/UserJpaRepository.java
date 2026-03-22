package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.repository;

import io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

interface UserJpaRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);
}

