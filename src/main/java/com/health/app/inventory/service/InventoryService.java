package com.health.app.inventory.service;

import com.health.app.inventory.dto.InventoryViewDto;
import com.health.app.inventory.dto.OptionDto;

import java.util.List;

public interface InventoryService {
    List<InventoryViewDto> getInventoryList(Long branchId, String keyword, boolean onlyLowStock);
    List<OptionDto> getBranchOptions();
}
