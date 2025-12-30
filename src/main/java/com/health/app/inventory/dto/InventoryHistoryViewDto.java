package com.health.app.inventory.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class InventoryHistoryViewDto {
    private Long inventoryHistoryId;

    private Long branchId;
    private String branchName;

    private Long productId;
    private String productName;

    private String moveType;     // IN / OUT
    private Long quantity;

    private String reason;

    private Long createUser;
    private LocalDateTime createDate;

    private String refType;      // PURCHASE / ORDER / MANUAL ...
    private Long refId;
}
