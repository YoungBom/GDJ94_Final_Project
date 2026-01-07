package com.health.app.approval;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ApprovalDocHeaderDTO {
    private Long docId;
    private Long docVerId;
    private String docNo;
    private String typeCode;
    private String formCode;
    private String docStatusCode;     
    private String verStatusCode;
    private Long drafterUserId;
    private Long drafterBranchId;
    private LocalDateTime createDate; 
}
