package com.health.app.inventory.service;

import com.health.app.inventory.dto.InventoryViewDto;
import com.health.app.inventory.dto.OptionDto;
import com.health.app.inventory.mapper.InventoryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InventoryServiceImpl implements InventoryService {

    private final InventoryMapper inventoryMapper;

    @Override
    public List<InventoryViewDto> getInventoryList(Long branchId, String keyword, boolean onlyLowStock) {
        return inventoryMapper.selectInventoryList(branchId, keyword, onlyLowStock);
    }

    @Override
    public List<OptionDto> getBranchOptions() {
        return inventoryMapper.selectBranchOptions();
    }
}
