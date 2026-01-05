package com.health.app.user;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserAdminController {

    private final UserAdminService userService;

    @GetMapping("/list")
    public String userList(Model model) {
        List<UserAdminDTO> userList = userService.getUserList();
        model.addAttribute("userList", userList);
        return "user/list";
    }
}
