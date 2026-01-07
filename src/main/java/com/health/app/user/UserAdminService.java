package com.health.app.user;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final UserAdminMapper userAdminMapper;
    private final PasswordEncoder passwordEncoder;

    public List<UserAdminDTO> getUserAdminList() {
        return userAdminMapper.selectUserAdminList();
    }
    
    public UserAdminDTO getUserAdminDetail(Long userId) {
        return userAdminMapper.selectUserAdminDetail(userId);
    }

    public void addUser(UserAdminDTO dto) {

        // 초기 상태
        dto.setUserStatusCode("US001");
        dto.setFailCount(0);

        // 🔥 초기 비밀번호 생성 (로그인 id에 !123을 더한게 패스워드)
        String rawPassword = dto.getLoginId() + "!123";

        // 🔥 반드시 암호화
        String encodedPassword = passwordEncoder.encode(rawPassword);
        dto.setPassword(encodedPassword);

        userAdminMapper.insertUser(dto);
    }
    
    public void updateUser(UserAdminDTO dto) {

        userAdminMapper.updateUser(dto);
    }

    
}
