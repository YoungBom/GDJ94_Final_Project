package com.health.app.notices;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/notices")
public class NoticeController {

	@GetMapping
	public String noticeList(Model model) {
		model.addAttribute("pageTitle", "공지사항");
		return "notices/list";
	}
}
