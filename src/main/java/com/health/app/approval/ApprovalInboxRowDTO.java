package com.health.app.approval;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ApprovalInboxRowDTO {
    private Long docId;
    private Long docVerId;

    private String docNo;
    private String typeCode;
    private String formCode;

    private String docStatusCode;
    private String verStatusCode;

    private Long drafterId;
    private Long branchId;

    private Long mySeq;           
    private String myLineStatusCode;

    private LocalDateTime submittedAt;
    private LocalDateTime updateDate;
}
