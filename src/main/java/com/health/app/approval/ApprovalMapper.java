package com.health.app.approval;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ApprovalMapper {

    int insertDocument(ApprovalDraftDTO dto);
    int insertDocumentVersion(ApprovalDraftDTO dto);
    int insertDocumentExt(ApprovalDraftDTO dto);
    int updateCurrentVersion(ApprovalDraftDTO dto);
    Long selectBranchIdByUserId(@Param("userId") Long userId);
    int deleteLinesByDocVerId(@Param("docVerId") Long docVerId);
    int insertLine(ApprovalLineDTO line);
    List<ApprovalLineDTO> selectLinesByDocVerId(@Param("docVerId") Long docVerId);

    List<Map<String, Object>> selectHeadOfficeApprovers();
    List<Map<String, Object>> selectBranchApprovers();
    List<Map<String, Object>> selectBranches();
    
    Long selectDrafterIdByDocVerId(@Param("docVerId") Long docVerId);
    int countLinesByDocVerId(@Param("docVerId") Long docVerId);
    String selectDocStatusByDocVerId(@Param("docVerId") Long docVerId);
    int updateDocumentStatusByDocVerId(@Param("docVerId") Long docVerId,
                                       @Param("statusCode") String statusCode,
                                       @Param("updateUser") Long updateUser);
    int updateVersionStatusByDocVerId(@Param("docVerId") Long docVerId,
                                      @Param("verStatusCode") String verStatusCode,
                                      @Param("updateUser") Long updateUser);
    int updateAllLinesStatusByDocVerId(@Param("docVerId") Long docVerId,
                                       @Param("lineStatusCode") String lineStatusCode,
                                       @Param("updateUser") Long updateUser);
    int updateFirstLineToPending(@Param("docVerId") Long docVerId,
                                 @Param("lineStatusCode") String lineStatusCode,
                                 @Param("updateUser") Long updateUser);
    List<ApprovalInboxRowDTO> selectMyInbox(@Param("approverId") Long approverId);
}
