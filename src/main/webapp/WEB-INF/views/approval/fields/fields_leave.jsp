<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row g-2">
  <div class="col-md-3">
    <label class="form-label">휴가 시작일</label>
    <input type="date" class="form-control" name="extDt1" required />
  </div>

  <div class="col-md-3">
    <label class="form-label">휴가 종료일</label>
    <input type="date" class="form-control" name="extDt2" required />
  </div>

  <div class="col-md-3">
    <label class="form-label">휴가 구분</label>
    <select class="form-select" name="extCode1" required>
      <option value="">선택</option>
      <option value="연차">연차</option>
      <option value="반차(오전)">반차(오전)</option>
      <option value="반차(오후)">반차(오후)</option>
      <option value="병가">병가</option>
      <option value="경조">경조</option>
      <option value="기타">기타</option>
    </select>
  </div>

  <div class="col-md-3">
    <label class="form-label">사용 일수(정수)</label>
    <input type="number" class="form-control" name="extNo1" min="0" step="1" placeholder="예: 1" />
    <div class="form-text">BIGINT라서 소수(0.5)는 별도 규칙 필요</div>
  </div>

  <div class="col-md-6">
    <label class="form-label mt-2">인수인계자(선택)</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="50" />
  </div>

  <div class="col-12">
    <label class="form-label mt-2">휴가 사유</label>
    <textarea class="form-control" name="extTxt2" rows="3" maxlength="500" required></textarea>
  </div>

  <div class="col-12">
    <label class="form-label mt-2">인수인계 내용(선택)</label>
    <textarea class="form-control" name="extTxt3" rows="3" maxlength="800"></textarea>
  </div>
</div>
