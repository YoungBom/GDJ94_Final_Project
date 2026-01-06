<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row g-3">

  <!-- 지점명 -->
  <div class="col-md-6">
    <label class="form-label">지점명</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="200" required />
  </div>

  <!-- 매출 항목 -->
  <div class="col-md-6">
    <label class="form-label">매출 항목</label>
    <select class="form-select" name="extCode1" required>
      <option value="">선택</option>
      <option value="MEMBERSHIP">회원권</option>
      <option value="PT">PT</option>
      <option value="PRODUCT">상품</option>
      <option value="ETC">기타</option>
    </select>
  </div>

  <!-- 매출 금액 -->
  <div class="col-md-6">
    <label class="form-label">매출 금액</label>
    <input type="number" class="form-control" name="extNo1" min="0" step="1" required />
  </div>

  <!-- 판매일자 -->
  <div class="col-md-6">
    <label class="form-label">판매일자</label>
    <input type="date" class="form-control" name="extDt1" required />
  </div>

  <!-- 비고 -->
  <div class="col-12">
    <label class="form-label">비고</label>
    <input type="text" class="form-control" name="extTxt2" maxlength="500" />
  </div>

</div>
