package com.health.app.purchase;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/purchase")
@RequiredArgsConstructor
public class PurchaseController {

    private final PurchaseService purchaseService;

    /**
     * 발주 요청(= PO 전자결재 폼으로 이동)
     * - 네 프로젝트에 이미 있는 전자결재 PO 폼 그대로 사용
     */
    @GetMapping("/new")
    @PreAuthorize("hasAnyRole('GRANDMASTER','MASTER','ADMIN','CAPTAIN','CREW')")
    public String newPurchaseForm() {
        return "redirect:/approval/form?entry=buy&typeCode=AT006";
    }

    /**
     * 구매요청서(PR) 작성도 같은 흐름(전자결재 폼)으로 보낸다.
     * - sidebar에서 PR작성 링크를 이쪽으로 붙이면 UX가 자연스럽게 통일됨
     */
    @GetMapping("/request/new")
    @PreAuthorize("hasAnyRole('GRANDMASTER','MASTER','ADMIN')")
    public String newPurchaseRequestForm() {
        return "redirect:/approval/form?entry=buy&typeCode=AT005";
    }

    /**
     * ✅ 구매/발주 통합 목록
     * - docType: ALL | PR | PO
     */
    @GetMapping("/orders")
    @PreAuthorize("hasAnyRole('GRANDMASTER','MASTER','ADMIN','CAPTAIN','CREW')")
    public String orders(@RequestParam(required = false) Long branchId,
                         @RequestParam(required = false) String statusCode,
                         @RequestParam(required = false) String keyword,
                         @RequestParam(required = false, defaultValue = "ALL") String docType,
                         Model model) {

        model.addAttribute("branches", purchaseService.getBranchOptions());
        model.addAttribute("list", purchaseService.getPurchaseList(branchId, statusCode, keyword, docType));

        // 화면 표기/검색 유지용
        model.addAttribute("branchId", branchId);
        model.addAttribute("statusCode", statusCode);
        model.addAttribute("keyword", keyword);
        model.addAttribute("docType", docType);

        // ✅ 이제 페이지 타이틀을 정확하게
        model.addAttribute("pageTitle", "구매/발주 목록");

        return "purchase/list";
    }

    /** /purchase 루트는 통합 목록으로 */
    @GetMapping
    @PreAuthorize("hasAnyRole('GRANDMASTER','MASTER','ADMIN','CAPTAIN','CREW')")
    public String root() {
        return "redirect:/purchase/orders";
    }
}
