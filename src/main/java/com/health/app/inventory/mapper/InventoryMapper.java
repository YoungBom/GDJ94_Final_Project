package com.health.app.inventory.mapper;

import com.health.app.inventory.dto.InventoryViewDto;
import com.health.app.inventory.dto.OptionDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InventoryMapper {

    List<InventoryViewDto> selectInventoryList(
            @Param("branchId") Long branchId,
            @Param("keyword") String keyword,
            @Param("onlyLowStock") boolean onlyLowStock
    );

    List<OptionDto> selectBranchOptions();
}
