package com.health.app.approval;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.health.app.signature.SignatureDTO;
import com.health.app.signature.SignatureMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ApprovalService {

    private final ApprovalMapper approvalMapper;
    private final ApprovalProductMapper approvalProductMapper;
    private final SignatureMapper signatureMapper; // ✅ 추가 (대표 서명 조회용)

    /* ==================================================
     * 받은 결재함
     * ================================================== */
    @Transactional(readOnly = true)
    public List<ApprovalInboxRowDTO> getMyInbox(Long approverId) {
        return approvalMapper.selectMyInbox(approverId);
    }

    /* ==================================================
     * 임시저장
     * ================================================== */
    @Transactional
    public ApprovalDraftDTO saveDraft(Long loginUserId, ApprovalDraftDTO dto) {

        dto.setDrafterId(loginUserId);
        dto.setCreateUser(loginUserId);
        dto.setUpdateUser(loginUserId);

        // 지점 자동 세팅
        if (dto.getBranchId() == null) {
            Long branchId = approvalMapper.selectBranchIdByUserId(loginUserId);
            if (branchId == null) {
                throw new IllegalStateException("branchId 조회 실패. userId=" + loginUserId);
            }
            dto.setBranchId(branchId);
        }

        // 문서 번호
        if (dto.getDocNo() == null || dto.getDocNo().isBlank()) {
            dto.setDocNo("TMP-" + System.currentTimeMillis());
        }

        // 상태 기본값
        if (dto.getStatusCode() == null || dto.getStatusCode().isBlank()) {
            dto.setStatusCode("AS001"); // 임시저장
        }
        if (dto.getVerStatusCode() == null || dto.getVerStatusCode().isBlank()) {
            dto.setVerStatusCode("AVS001");
        }
        if (dto.getVersionNo() == null) {
            dto.setVersionNo(1L);
        }

        if (dto.getTitle() == null) dto.setTitle("");
        if (dto.getBody() == null) dto.setBody("");

        approvalMapper.insertDocument(dto);
        approvalMapper.insertDocumentVersion(dto);
        approvalMapper.insertDocumentExt(dto);
        approvalMapper.updateCurrentVersion(dto);

        return dto;
    }

    /* ==================================================
     * 결재선 저장
     * ================================================== */
    @Transactional
    public void saveLines(Long loginUserId, Long docVerId, List<ApprovalLineDTO> lines) {

        if (docVerId == null) {
            throw new IllegalArgumentException("docVerId is required");
        }

        approvalMapper.deleteLinesByDocVerId(docVerId);

        int seqAuto = 1;
        for (ApprovalLineDTO line : lines) {

            line.setDocVerId(docVerId);

            if (line.getSeq() == null) {
                line.setSeq(seqAuto++);
            } else {
                seqAuto = Math.max(seqAuto, line.getSeq() + 1);
            }

            if (line.getLineStatusCode() == null || line.getLineStatusCode().isBlank()) {
                line.setLineStatusCode("ALS001");
            }

            line.setCreateUser(loginUserId);
            line.setUpdateUser(loginUserId);

            approvalMapper.insertLine(line);
        }
    }

    /* ==================================================
     * 결재선 조회
     * ================================================== */
    @Transactional(readOnly = true)
    public List<ApprovalLineDTO> getLines(Long docVerId) {
        if (docVerId == null) {
            throw new IllegalArgumentException("docVerId is required");
        }
        return approvalMapper.selectLinesByDocVerId(docVerId);
    }

    /* ==================================================
     * 결재자 트리
     * ================================================== */
    @Transactional(readOnly = true)
    public Map<String, Object> getApproverTree() {

        List<Map<String, Object>> hqUsers = approvalMapper.selectHeadOfficeApprovers();
        List<Map<String, Object>> brUsers = approvalMapper.selectBranchApprovers();
        List<Map<String, Object>> brList  = approvalMapper.selectBranches();

        // 본사 → 부서
        Map<String, List<Map<String, Object>>> headOfficeByDept = new LinkedHashMap<>();
        for (Map<String, Object> u : hqUsers) {
            String deptCode = String.valueOf(u.get("deptCode"));
            headOfficeByDept.computeIfAbsent(deptCode, k -> new ArrayList<>()).add(u);
        }

        // 지점명 맵
        Map<Long, String> branchNameMap = new HashMap<>();
        for (Map<String, Object> b : brList) {
            Long branchId = ((Number) b.get("branchId")).longValue();
            branchNameMap.put(branchId, String.valueOf(b.get("branchName")));
        }

        // 지점 → 사용자
        Map<String, Object> branches = new LinkedHashMap<>();
        for (Map<String, Object> u : brUsers) {

            Long branchId = ((Number) u.get("branchId")).longValue();
            String key = String.valueOf(branchId);

            @SuppressWarnings("unchecked")
            Map<String, Object> node = (Map<String, Object>) branches.get(key);
            if (node == null) {
                node = new LinkedHashMap<>();
                node.put("branchName", branchNameMap.getOrDefault(branchId, "지점 " + branchId));
                node.put("users", new ArrayList<Map<String, Object>>());
                branches.put(key, node);
            }

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> users = (List<Map<String, Object>>) node.get("users");
            users.add(u);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("headOfficeByDept", headOfficeByDept);
        result.put("branches", branches);
        return result;
    }

    /* ==================================================
     * 결재 요청
     * ================================================== */
    @Transactional
    public void submit(Long loginUserId, Long docVerId) {

        if (docVerId == null) {
            throw new IllegalArgumentException("docVerId is required");
        }

        Long drafterId = approvalMapper.selectDrafterIdByDocVerId(docVerId);
        if (drafterId == null) {
            throw new IllegalStateException("문서를 찾을 수 없습니다. docVerId=" + docVerId);
        }
        if (!drafterId.equals(loginUserId)) {
            throw new IllegalStateException("기안자만 결재 요청할 수 있습니다.");
        }

        int lineCount = approvalMapper.countLinesByDocVerId(docVerId);
        if (lineCount <= 0) {
            throw new IllegalStateException("결재선이 없습니다. 결재선을 먼저 설정하세요.");
        }

        String docStatus = approvalMapper.selectDocStatusByDocVerId(docVerId);
        if (!"AS001".equals(docStatus)) {
            throw new IllegalStateException("임시저장 문서만 결재 요청할 수 있습니다.");
        }

        approvalMapper.updateDocumentStatusByDocVerId(docVerId, "AS002", loginUserId);
        approvalMapper.updateVersionStatusByDocVerId(docVerId, "AVS002", loginUserId);
        approvalMapper.updateAllLinesStatusByDocVerId(docVerId, "ALS001", loginUserId);
        approvalMapper.updateFirstLineToPending(docVerId, "ALS002", loginUserId);
    }

    /* ==================================================
     * approval 전용 상품 조회
     * ================================================== */
    @Transactional(readOnly = true)
    public List<ApprovalProductDTO> getProductsByBranch(Long branchId) {
        return approvalProductMapper.selectProductsByBranch(branchId);
    }

    /* ==================================================
     * 지점 목록
     * ================================================== */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getBranches() {
        return approvalMapper.selectBranches();
    }

    /* ==================================================
     * 출력 데이터
     * ================================================== */
    @Transactional(readOnly = true)
    public ApprovalPrintDTO getPrintData(Long docVerId) {

        if (docVerId == null) {
            throw new IllegalArgumentException("docVerId is required");
        }

        VacationPrintDTO doc = approvalMapper.selectVacationPrint(docVerId);
        if (doc == null) {
            throw new IllegalStateException("문서를 찾을 수 없습니다. docVerId=" + docVerId);
        }

        doc.setLines(approvalMapper.selectPrintLines(docVerId));

        return doc;
    }

    /* ==================================================
     * 결재 처리 (승인/반려)  ✅ 서명 저장 포함
     * ================================================== */
    @Transactional
    public void processDecision(Long loginUserId, Long docVerId, String action, String comment) {

        if (loginUserId == null) throw new IllegalArgumentException("loginUserId is required");
        if (docVerId == null) throw new IllegalArgumentException("docVerId is required");
        if (action == null || action.isBlank()) throw new IllegalArgumentException("action is required");

        Long lineId = approvalMapper.selectCurrentPendingLineId(docVerId);
        if (lineId == null) {
            throw new IllegalStateException("처리할 결재 라인이 없습니다. docVerId=" + docVerId);
        }

        // ✅ 현재 결재자 대표서명(file_id) 조회 → approval_lines.signature_file_id로 저장
        Long signatureFileId = null;
        SignatureDTO sign = signatureMapper.selectPrimaryByUserId(loginUserId);
        if (sign != null) signatureFileId = sign.getFileId();

        if ("APPROVE".equalsIgnoreCase(action)) {

            approvalMapper.updateLineStatusByLineId(
                lineId,
                "ALS003",
                comment,
                signatureFileId,
                loginUserId
            );

            int moved = approvalMapper.updateNextLineToPending(docVerId, "ALS002", loginUserId);

            if (moved == 0) {
                approvalMapper.updateDocumentStatusByDocVerId(docVerId, "AS003", loginUserId);
                approvalMapper.updateVersionStatusByDocVerId(docVerId, "AVS003", loginUserId);
            }

        } else if ("REJECT".equalsIgnoreCase(action)) {

            approvalMapper.updateLineStatusByLineId(
                lineId,
                "ALS004",
                comment,
                signatureFileId,
                loginUserId
            );

            approvalMapper.updateDocumentStatusByDocVerId(docVerId, "AS004", loginUserId);
            approvalMapper.updateVersionStatusByDocVerId(docVerId, "AVS004", loginUserId);

        } else {
            throw new IllegalArgumentException("invalid action: " + action);
        }
    }
}
