package com.health.app.approval;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.health.app.expenses.ExpenseDto;
import com.health.app.expenses.ExpenseMapper;
import com.health.app.inventory.InventoryDetailDto;
import com.health.app.inventory.InventoryMapper;
import com.health.app.purchase.PurchaseRequestDto;
import com.health.app.purchase.PurchaseMapper;
import com.health.app.sales.SaleDto;
import com.health.app.sales.SaleMapper;
import com.health.app.sales.SaleStatus;
import com.health.app.settlements.SettlementDto;
import com.health.app.settlements.SettlementMapper;
import com.health.app.settlements.SettlementStatus;
import com.health.app.inbound.InboundRequestHeaderDto;
import com.health.app.inbound.InboundRequestItemDto;
import com.health.app.inbound.InboundRequestMapper;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class ApprovalApplyService {

    private final ApprovalMapper approvalMapper;

    private final ExpenseMapper expenseMapper;
    private final SettlementMapper settlementMapper;
    private final SaleMapper saleMapper;
    private final InventoryMapper inventoryMapper;

    private final PurchaseMapper purchaseMapper;
    private final InboundRequestMapper inboundRequestMapper;

    private final ObjectMapper objectMapper;

    /* =========================================================
     * entry
     * ========================================================= */
    public void applyApprovedDoc(Long docVerId, Long actorUserId) {

        ApprovalDraftDTO draft = approvalMapper.selectDraftByDocVerId(docVerId);
        if (draft == null) {
            throw new IllegalStateException("draft not found: " + docVerId);
        }

        switch (draft.getTypeCode()) {
            case "AT001" -> applyExpense(draft, actorUserId);
            case "AT002" -> applySettlement(draft, actorUserId);
            case "AT003" -> applySales(draft, actorUserId);
            case "AT004" -> applyInventoryAdjust(draft, actorUserId);
            case "AT005" -> applyPurchaseRequest(draft, actorUserId);
            case "AT006" -> applyInboundRequest(draft, actorUserId);
            default -> throw new UnsupportedOperationException(
                    "Unsupported typeCode: " + draft.getTypeCode());
        }
    }

    /* =========================================================
     * AT001 지출
     * ========================================================= */
    private void applyExpense(ApprovalDraftDTO draft, Long actorUserId) {

        Long branchId = draft.getExtNo1();
        if (branchId == null || branchId <= 0) {
            throw new IllegalArgumentException("AT001: branchId 없음");
        }

        List<ExpenseLine> lines =
                readJsonList(draft.getExtTxt6(), new TypeReference<>() {});

        if (lines == null || lines.isEmpty()) {
            throw new IllegalArgumentException("AT001: 지출 라인 없음");
        }

        BigDecimal amount = toBigDecimalOrNull(draft.getExtNo2());
        if (amount == null) {
            amount = sumExpenseAmount(lines);
        }

        ExpenseDto dto = ExpenseDto.builder()
                .branchId(branchId)
                .expenseAt(LocalDateTime.now())
                .categoryCode("ETC")
                .amount(amount)
                .description(draft.getExtTxt3())
                .memo(draft.getBody())
                .settlementFlag(true)
                .createUser(actorUserId)
                .useYn(true)
                .build();

        expenseMapper.insertExpense(dto);
    }

    private BigDecimal sumExpenseAmount(List<ExpenseLine> lines) {
        BigDecimal sum = BigDecimal.ZERO;
        for (ExpenseLine l : lines) {
            if (l != null && l.getAmount() != null) {
                sum = sum.add(l.getAmount());
            }
        }
        return sum;
    }

    /* =========================================================
     * AT002 정산
     * ========================================================= */
    private void applySettlement(ApprovalDraftDTO draft, Long actorUserId) {

        LocalDate from = draft.getExtDt1();
        LocalDate to = draft.getExtDt2();
        if (from == null || to == null) {
            throw new IllegalArgumentException("AT002: 기간 없음");
        }

        SettlementDto dto = SettlementDto.builder()
                .settlementNo(generateSettlementNo())
                .branchId(draft.getBranchId())
                .fromDate(from)
                .toDate(to)
                .salesAmount(toBigDecimalOrZero(draft.getExtNo1()))
                .expenseAmount(toBigDecimalOrZero(draft.getExtNo2()))
                .profitAmount(toBigDecimalOrZero(draft.getExtNo3()))
                .statusCode(SettlementStatus.PENDING.name())
                .createUser(actorUserId)
                .useYn(true)
                .build();

        settlementMapper.insertSettlement(dto);
    }

    /* =========================================================
     * AT003 매출
     * ========================================================= */
    private void applySales(ApprovalDraftDTO draft, Long actorUserId) {

        Long branchId = draft.getExtNo1();
        if (branchId == null) {
            throw new IllegalArgumentException("AT003: branchId 없음");
        }

        List<SalesLine> lines =
                readJsonList(draft.getExtTxt6(), new TypeReference<>() {});

        for (SalesLine l : lines) {
            SaleDto dto = SaleDto.builder()
                    .saleNo(generateSaleNo())
                    .branchId(branchId)
                    .soldAt(LocalDateTime.now())
                    .statusCode(SaleStatus.COMPLETED.name())
                    .categoryCode(l.getType())
                    .totalAmount(l.getAmount())
                    .memo(l.getMemo())
                    .createUser(actorUserId)
                    .useYn(true)
                    .build();

            saleMapper.insertSale(dto);
        }
    }

    /* =========================================================
     * AT004 재고
     * ========================================================= */
    private void applyInventoryAdjust(ApprovalDraftDTO draft, Long actorUserId) {

        Long branchId = draft.getExtNo1();
        List<InventoryAdjustLine> lines =
                readJsonList(draft.getExtTxt6(), new TypeReference<>() {});

        for (InventoryAdjustLine l : lines) {
            InventoryDetailDto cur =
                    inventoryMapper.selectInventoryDetail(branchId, l.getProductId());

            long after = cur.getQuantity() + l.getSignedQty();
            inventoryMapper.updateInventoryQuantity(
                    branchId, l.getProductId(), after, null, actorUserId);

            inventoryMapper.insertInventoryHistory(
                    branchId,
                    l.getProductId(),
                    l.getSignedQty() > 0 ? "IN" : "OUT",
                    Math.abs(l.getSignedQty()),
                    "APPROVAL",
                    "INVENTORY_ADJUST",
                    null,
                    actorUserId
            );
        }
    }

    /* =========================================================
     * AT005 구매요청 (상신 시 즉시 저장)
     * PurchaseMapper 기준 정답 구현
     * ========================================================= */
    private void applyPurchaseRequest(ApprovalDraftDTO draft, Long actorUserId) {

        Long branchId = draft.getBranchId();
        if (branchId == null || branchId <= 0) {
            throw new IllegalArgumentException("AT005: branchId 없음");
        }

        // 1. Header
        PurchaseRequestDto header = new PurchaseRequestDto();
        header.setBranchId(branchId);
        header.setStatusCode("REQUESTED");
        header.setRequestedBy(actorUserId);
        header.setMemo(draft.getExtTxt2());

        purchaseMapper.insertPurchaseHeader(header);

        Long purchaseId = header.getPurchaseId();
        if (purchaseId == null) {
            throw new IllegalStateException("AT005: purchaseId 생성 실패");
        }

        // 2. Lines
        List<PrPoLine> lines =
                readJsonList(draft.getExtTxt6(), new TypeReference<List<PrPoLine>>() {});
        if (lines == null || lines.isEmpty()) {
            throw new IllegalArgumentException("AT005: 품목 없음");
        }

        for (PrPoLine l : lines) {
            if (l == null) continue;
            if (l.getProductId() == null || l.getQty() == null || l.getQty() <= 0) continue;

            PurchaseRequestDto.PurchaseItemDto item =
                    new PurchaseRequestDto.PurchaseItemDto();
            item.setProductId(l.getProductId());
            item.setQuantity(l.getQty());
            item.setUnitPrice(l.getUnit() == null ? 0L : l.getUnit());

            purchaseMapper.insertPurchaseDetail(purchaseId, item, actorUserId);
        }
    }


    /* =========================================================
     * AT006 입고요청
     * ========================================================= */
    private void applyInboundRequest(ApprovalDraftDTO draft, Long actorUserId) {

        if (draft.getExtTxt1() == null || draft.getExtTxt1().isBlank()) {
            throw new IllegalArgumentException("AT006: 거래처명 없음");
        }
        if (draft.getExtDt1() == null) {
            throw new IllegalArgumentException("AT006: 납기일 없음");
        }

        List<PrPoLine> lines =
                readJsonList(draft.getExtTxt6(), new TypeReference<List<PrPoLine>>() {});
        if (lines == null || lines.isEmpty()) {
            throw new IllegalArgumentException("AT006: 품목 없음");
        }

        // 1. Header
        InboundRequestHeaderDto header = new InboundRequestHeaderDto();
        header.setVendorName(draft.getExtTxt1());
        header.setStatusCode("IR_REQ");
        header.setRequestedBy(actorUserId);
        header.setTitle(draft.getTitle());
        header.setMemo(draft.getExtTxt4());
        header.setCreateUser(actorUserId);
        header.setUpdateUser(actorUserId);
        header.setUseYn(1);

        inboundRequestMapper.insertInboundHeader(header);

        Long inboundRequestId = header.getInboundRequestId();
        if (inboundRequestId == null) {
            throw new IllegalStateException("AT006: header 저장 실패");
        }

        // 2. Detail
        for (PrPoLine l : lines) {
            if (l == null) continue;
            if (l.getProductId() == null || l.getQty() == null || l.getQty() <= 0) continue;

            InboundRequestItemDto item = new InboundRequestItemDto();
            item.setInboundRequestId(inboundRequestId);
            item.setProductId(l.getProductId());
            item.setQuantity(l.getQty());
            item.setUnitPrice(l.getUnit() == null ? 0L : l.getUnit());
            item.setCreateUser(actorUserId);
            item.setUpdateUser(actorUserId);
            item.setUseYn(1);

            inboundRequestMapper.insertInboundDetail(item);
        }

        // 3. 결재 링크
        inboundRequestMapper.updateApprovalLink(
                inboundRequestId,
                draft.getDocId(),
                draft.getDocVerId(),
                "INBOUND_REQUEST",
                inboundRequestId,
                actorUserId
        );
    }

    /* =========================================================
     * helpers
     * ========================================================= */
    private <T> List<T> readJsonList(String json, TypeReference<List<T>> ref) {
        try {
            return objectMapper.readValue(json, ref);
        } catch (Exception e) {
            throw new IllegalStateException("JSON 파싱 실패", e);
        }
    }

    private BigDecimal toBigDecimalOrZero(Long n) {
        return n == null ? BigDecimal.ZERO : BigDecimal.valueOf(n);
    }

    private BigDecimal toBigDecimalOrNull(Long n) {
        return n == null ? null : BigDecimal.valueOf(n);
    }

    private String generateSettlementNo() {
        return "STL-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String generateSaleNo() {
        return "SALE-" + System.currentTimeMillis();
    }

    /* =========================================================
     * JSON line DTOs
     * ========================================================= */
    @Data
    public static class ExpenseLine {
        private BigDecimal amount;
    }

    @Data
    public static class SalesLine {
        private String type;
        private BigDecimal amount;
        private String memo;
    }

    @Data
    public static class InventoryAdjustLine {
        private Long productId;
        private Long signedQty;
    }

    @Data
    public static class PrPoLine {
        private Long productId;
        private Long qty;
        private Long unit;
    }
}
