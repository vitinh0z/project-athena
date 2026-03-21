package io.github.vitinh0z.chessanalyzer.infrastructure.persistence.mapper;

import io.github.vitinh0z.chessanalyzer.domain.model.User;
import org.springframework.stereotype.Component;

@Component
public class UserEntityMapper {

    public io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User toEntity(
            User domain) {
        if (domain == null) {
            return null;
        }

        return io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User.builder()
                .id(domain.getId())
                .username(domain.getUsername())
                .email(domain.getEmail())
                .passwordHash(domain.getPasswordHash())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public User toDomain(
            io.github.vitinh0z.chessanalyzer.infrastructure.persistence.entity.User entity) {
        if (entity == null) {
            return null;
        }

        return User.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .email(entity.getEmail())
                .passwordHash(entity.getPasswordHash())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }
}



