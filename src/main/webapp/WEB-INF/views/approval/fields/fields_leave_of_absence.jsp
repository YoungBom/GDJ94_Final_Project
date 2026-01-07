<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row g-3">

  <!-- 휴직 기간 -->
  <div class="col-md-6">
    <label class="form-label">휴직 시작일</label>
    <input type="date" class="form-control" name="extDt1" required />
  </div>
  <div class="col-md-6">
    <label class="form-label">휴직 종료일</label>
    <input type="date" class="form-control" name="extDt2" required />
  </div>

  <!-- 휴직 구분 -->
  <div class="col-md-6">
    <label class="form-label">휴직 구분</label>
    <select class="form-select" name="extCode1" required>
      <option value="">선택</option>
      <option value="MEDICAL">질병</option>
      <option value="PERSONAL">개인사유</option>
      <option value="MILITARY">군복무</option>
      <option value="STUDY">학업</option>
      <option value="ETC">기타</option>
    </select>
  </div>

  <!-- 인수인계 -->
  <div class="col-md-6">
    <label class="form-label">업무 인수인계</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="200" required />
  </div>

  <!-- 휴직 사유 -->
  <div class="col-12">
    <label class="form-label">휴직 사유</label>
    <textarea class="form-control" name="extTxt2" rows="3" required></textarea>
  </div>

</div>
