package com.health.app.approval;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ApprovalLineDTO {

    private Long lineId;
    private Long docVerId;

    // ===== 결재선 정보 =====
    private Integer seq;          
    private String lineRoleCode;    
    private Long approverId;        
    private String lineStatusCode;  
    private String approverName;

    // ===== 처리 정보 =====
    private LocalDateTime actedAt;
    private String comment;
    private Long signatureFileId;

    // ===== 공통 =====
    private Long createUser;
    private LocalDateTime createDate;
    private Long updateUser;
    private LocalDateTime updateDate;
    private Boolean useYn;
}
