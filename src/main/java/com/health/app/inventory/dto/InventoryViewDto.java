package com.health.app.inventory.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class InventoryViewDto {
    private Long inventoryId;

    private Long branchId;
    private String branchName;

    private Long productId;
    private String productName;

    private Long quantity;

    private Long lowStockThreshold;
    private Long reorderPoint;

    // 기준수량 (지점 기준 우선, 없으면 상품 기준)
    private Long thresholdValue;

    // 부족 여부 (0/1)
    private Integer lowStock;
}
