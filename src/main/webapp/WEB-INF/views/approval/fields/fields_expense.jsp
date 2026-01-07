<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row g-3">

  <!-- 지점명 -->
  <div class="col-md-6">
    <label class="form-label">지점명</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="200" required />
  </div>

  <!-- 지출 항목 -->
  <div class="col-md-6">
    <label class="form-label">지출 항목</label>
    <input type="text" class="form-control" name="extTxt2" maxlength="200" required />
  </div>

  <!-- 지출금액 -->
  <div class="col-md-6">
    <label class="form-label">지출금액</label>
    <input type="number" class="form-control" name="extNo1" min="0" step="1" required />
  </div>

  <!-- 지출 일자 -->
  <div class="col-md-6">
    <label class="form-label">지출 일자</label>
    <input type="date" class="form-control" name="extDt1" required />
  </div>

  <!-- 지출 사유 -->
  <div class="col-12">
    <label class="form-label">지출 사유</label>
    <textarea class="form-control" name="extTxt3" rows="3" required></textarea>
  </div>

</div>
