package com.health.app.inventory;

import com.health.app.inventory.dto.InventoryViewDto;
import com.health.app.inventory.dto.OptionDto;
import com.health.app.inventory.service.InventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventoryService;

    @GetMapping
    public String inventoryList(
            @RequestParam(required = false) Long branchId,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "false") boolean onlyLowStock,
            Model model
    ) {
        model.addAttribute("pageTitle", "재고 관리");

        List<OptionDto> branchOptions = inventoryService.getBranchOptions();
        List<InventoryViewDto> inventoryList =
                inventoryService.getInventoryList(branchId, keyword, onlyLowStock);

        model.addAttribute("branchOptions", branchOptions);
        model.addAttribute("inventoryList", inventoryList);

        // 검색값 유지
        model.addAttribute("branchId", branchId);
        model.addAttribute("keyword", keyword);
        model.addAttribute("onlyLowStock", onlyLowStock);

        return "inventory/list";
    }
}
