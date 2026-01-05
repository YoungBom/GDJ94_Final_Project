package com.health.app.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final UserAdminMapper userMapper;

    public List<UserAdminDTO> getUserList() {
        return userMapper.selectUserList();
    }
}
