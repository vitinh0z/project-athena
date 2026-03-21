package io.github.vitinh0z.chessanalyzer.application.mapper;

import io.github.vitinh0z.chessanalyzer.api.dto.UserDTO;
import io.github.vitinh0z.chessanalyzer.domain.model.User;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserDTO toDto(User domain) {
        if (domain == null) {
            return null;
        }

        return new UserDTO(
                domain.getId(),
                domain.getUsername(),
                domain.getEmail(),
                domain.getCreatedAt(),
                domain.getUpdatedAt());
    }

    public List<UserDTO> toDtoList(List<User> domains) {
        if (domains == null || domains.isEmpty()) {
            return List.of();
        }
        return domains.stream().map(this::toDto).toList();
    }
}

