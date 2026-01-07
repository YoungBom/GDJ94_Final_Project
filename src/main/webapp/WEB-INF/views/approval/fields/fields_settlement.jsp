<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row g-3">

  <!-- 정산 기간 -->
  <div class="col-md-6">
    <label class="form-label">정산 시작일</label>
    <input type="date" class="form-control" name="extDt1" required />
  </div>
  <div class="col-md-6">
    <label class="form-label">정산 종료일</label>
    <input type="date" class="form-control" name="extDt2" required />
  </div>

  <!-- 지점명 -->
  <div class="col-md-6">
    <label class="form-label">지점명</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="200" required />
  </div>

  <!-- 총 매출액 -->
  <div class="col-md-6">
    <label class="form-label">총 매출액</label>
    <input type="number" class="form-control" name="extNo1" min="0" step="1" required />
  </div>

  <!-- 총 지출액 -->
  <div class="col-md-6">
    <label class="form-label">총 지출액</label>
    <input type="number" class="form-control" name="extNo2" min="0" step="1" required />
  </div>

  <!-- 손익 금액 -->
  <div class="col-md-6">
    <label class="form-label">손익 금액</label>
    <input type="number" class="form-control" name="extNo3" step="1" required />
    <div class="form-text">손익은 음수일 수 있습니다.</div>
  </div>

  <!-- 확정 사유 -->
  <div class="col-12">
    <label class="form-label">확정 사유</label>
    <textarea class="form-control" name="extTxt2" rows="3" required></textarea>
  </div>

</div>
