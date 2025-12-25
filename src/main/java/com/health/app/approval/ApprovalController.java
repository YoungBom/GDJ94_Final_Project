package com.health.app.approval;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

	@GetMapping
	public String approvalList(Model model) {
		model.addAttribute("pageTitle", "전자 결재");
		return "approval/list";
	}
}
