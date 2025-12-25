package com.health.app.statistics;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/statistics")
public class StatisticsController {

	@GetMapping
	public String statisticsView(Model model) {
		model.addAttribute("pageTitle", "통계");
		return "statistics/view";
	}
}
