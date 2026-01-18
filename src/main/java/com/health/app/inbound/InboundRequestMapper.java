package com.health.app.inbound;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InboundRequestMapper {

    // 옵션
    List<InboundOptionDto> selectProductOptions();

    // 저장
    void insertInboundHeader(InboundRequestHeaderDto header);
    void insertInboundDetail(InboundRequestItemDto item);

    // 결재 링크
    void updateApprovalLink(@Param("inboundRequestId") Long inboundRequestId,
                            @Param("approvalDocId") Long approvalDocId,
                            @Param("approvalDocVerId") Long approvalDocVerId,
                            @Param("refType") String refType,
                            @Param("refId") Long refId,
                            @Param("userId") Long userId);

    // 조회
    List<InboundRequestListDto> selectInboundList(@Param("statusCode") String statusCode);

    InboundRequestDetailDto selectInboundHeader(@Param("inboundRequestId") Long inboundRequestId);

    List<InboundRequestItemDto> selectInboundItems(@Param("inboundRequestId") Long inboundRequestId);

    // 재고 반영
    void upsertInventoryIncrease(@Param("branchId") Long branchId,
                                 @Param("productId") Long productId,
                                 @Param("qty") Long qty,
                                 @Param("userId") Long userId);

    void insertInventoryHistoryIn(@Param("branchId") Long branchId,
                                  @Param("productId") Long productId,
                                  @Param("qty") Long qty,
                                  @Param("reason") String reason,
                                  @Param("userId") Long userId,
                                  @Param("refType") String refType,
                                  @Param("refId") Long refId);

    // 상태 변경
    void updateStatusApproved(@Param("inboundRequestId") Long inboundRequestId,
                              @Param("userId") Long userId);

    void updateStatusDone(@Param("inboundRequestId") Long inboundRequestId,
                          @Param("userId") Long userId);
}
