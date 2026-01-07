package com.health.app.user;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.health.app.security.model.LoginUser;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/userManagement")
@RequiredArgsConstructor
public class UserAdminController {

    private final UserAdminService userAdminService;

    // 사용자 관리 목록
    @GetMapping("/list")
    public String userList(Model model) {

        List<UserAdminDTO> users = userAdminService.getUserAdminList();
        model.addAttribute("users", users);
        model.addAttribute("pageTitle", "사용자 관리");
        
        return "userManagement/list";
    }
    
    // 사용자 상세화면
    @GetMapping("/detail")
    public String userDetail(Long userId, Model model) {

        UserAdminDTO user = userAdminService.getUserAdminDetail(userId);
        model.addAttribute("user", user);

        return "userManagement/detail";
    }

    // 사용자 등록
    @GetMapping("/add")
    public String addForm(HttpSession session, Model model) {
        return "userManagement/add";
    }
    
    @PostMapping("/add")
    public String addUser(UserAdminDTO dto) {

        Authentication auth =
            SecurityContextHolder.getContext().getAuthentication();

        LoginUser loginUser =
            (LoginUser) auth.getPrincipal(); // ⭐ 여기

        dto.setCreateUser(loginUser.getUserId()); // ⭐ 여기

        userAdminService.addUser(dto);
        return "redirect:/userManagement/list";
    }
}
