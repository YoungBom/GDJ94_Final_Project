package com.health.app.schedules;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/schedules")
public class ScheduleController {

	@GetMapping
	public String scheduleView(Model model) {
		model.addAttribute("pageTitle", "일정");
		return "schedules/view";
	}
}
