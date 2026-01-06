package com.health.app.approval;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ApprovalProductMapper {

    // 지점 선택 후 상품 목록
    List<ApprovalProductDTO> selectProductsByBranch(
            @Param("branchId") Long branchId
    );
}
