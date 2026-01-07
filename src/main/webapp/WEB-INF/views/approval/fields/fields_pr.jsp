<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<input type="hidden" name="extTxt6" id="prItemsJson" />

<div class="row g-2">
  <div class="col-md-4">
    <label class="form-label">희망 납기일(선택)</label>
    <input type="date" class="form-control" name="extDt1" />
  </div>

  <div class="col-md-4">
    <label class="form-label">거래처(선택)</label>
    <input type="text" class="form-control" name="extTxt1" maxlength="100" />
  </div>

  <div class="col-md-4">
    <label class="form-label">예상 합계(자동)</label>
    <input type="number" class="form-control" name="extNo1" id="prTotal" readonly />
  </div>

  <div class="col-12">
    <label class="form-label mt-2">요청 사유</label>
    <textarea class="form-control" name="extTxt2" rows="3" maxlength="600" required></textarea>
  </div>

  <div class="col-12 mt-2">
    <div class="d-flex justify-content-between align-items-center">
      <label class="form-label mb-0">구매 품목</label>
      <button type="button" class="btn btn-outline-secondary btn-sm" id="btnAddPrRow">+ 행 추가</button>
    </div>

    <div class="table-responsive mt-2">
      <table class="table table-sm table-bordered align-middle" id="prTable">
        <thead class="table-light">
          <tr>
            <th>품목명</th>
            <th style="width: 110px;" class="text-end">수량</th>
            <th style="width: 140px;" class="text-end">예상단가</th>
            <th style="width: 140px;" class="text-end">금액(자동)</th>
            <th style="width: 80px;"></th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><input type="text" class="form-control form-control-sm pr-name" maxlength="120" /></td>
            <td><input type="number" class="form-control form-control-sm pr-qty text-end" min="1" step="1" value="1" /></td>
            <td><input type="number" class="form-control form-control-sm pr-unit text-end" min="0" step="1" /></td>
            <td><input type="number" class="form-control form-control-sm pr-amt text-end" readonly /></td>
            <td class="text-center"><button type="button" class="btn btn-outline-danger btn-sm btnDelRow">삭제</button></td>
          </tr>
        </tbody>
      </table>
      <div class="form-text">저장 시 품목은 extTxt6(JSON)로 저장됩니다.</div>
    </div>
  </div>

  <div class="col-12">
    <label class="form-label mt-2">비고(선택)</label>
    <input type="text" class="form-control" name="extTxt3" maxlength="200" />
  </div>
</div>

<script>
(function() {
  const tbody = document.querySelector("#prTable tbody");
  const btnAdd = document.getElementById("btnAddPrRow");
  const totalEl = document.getElementById("prTotal");
  const jsonEl = document.getElementById("prItemsJson");

  function recalc() {
    const rows = [...tbody.querySelectorAll("tr")];
    let total = 0;
    const items = rows.map(r => {
      const name = r.querySelector(".pr-name").value || "";
      const qty = Number(r.querySelector(".pr-qty").value || 0);
      const unit = Number(r.querySelector(".pr-unit").value || 0);
      const amt = qty * unit;
      r.querySelector(".pr-amt").value = amt;
      total += amt;
      return { name, qty, unit, amt };
    });
    totalEl.value = total;
    jsonEl.value = JSON.stringify(items);
  }

  btnAdd.addEventListener("click", () => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td><input type="text" class="form-control form-control-sm pr-name" maxlength="120" /></td>
      <td><input type="number" class="form-control form-control-sm pr-qty text-end" min="1" step="1" value="1" /></td>
      <td><input type="number" class="form-control form-control-sm pr-unit text-end" min="0" step="1" /></td>
      <td><input type="number" class="form-control form-control-sm pr-amt text-end" readonly /></td>
      <td class="text-center"><button type="button" class="btn btn-outline-danger btn-sm btnDelRow">삭제</button></td>
    `;
    tbody.appendChild(tr);
    recalc();
  });

  tbody.addEventListener("input", recalc);
  tbody.addEventListener("click", (e) => {
    if (e.target.classList.contains("btnDelRow")) {
      e.target.closest("tr").remove();
      recalc();
    }
  });

  recalc();
})();
</script>
