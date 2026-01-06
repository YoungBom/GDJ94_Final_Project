<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!-- 조정내역 JSON: extTxt6 -->
<input type="hidden" name="extTxt6" id="invItemsJson" />

<div class="row g-2">
  <div class="col-md-8">
    <label class="form-label">지점</label>
    <select class="form-select" name="extNo1" id="branchId" required>
      <option value="">지점 선택</option>
      <c:forEach var="b" items="${branches}">
        <option value="${b.branchId}"><c:out value="${b.branchName}"/></option>
      </c:forEach>
    </select>
    <div class="form-text">extNo1 = branchId</div>
  </div>

  <div class="col-md-4">
    <label class="form-label">작성일</label>
    <input type="date" class="form-control" name="extDt1" required />
    <div class="form-text">extDt1 = 작성일</div>
  </div>

  <div class="col-md-8">
    <label class="form-label mt-2">상품</label>
    <select class="form-select" name="extNo2" id="productId" required>
      <option value="">상품 선택</option>
      <c:forEach var="p" items="${products}">
        <option value="${p.productId}" data-baseqty="${p.stockQty}">
          <c:out value="${p.productName}"/>
        </option>
      </c:forEach>
    </select>
    <div class="form-text">extNo2 = productId</div>
  </div>

  <div class="col-md-4">
    <label class="form-label mt-2">조정 유형</label>
    <div class="d-flex gap-3 align-items-center" style="height: 38px;">
      <label class="form-check mb-0">
        <input class="form-check-input" type="radio" name="extCode1" value="INCREASE" checked>
        <span class="form-check-label">증가</span>
      </label>
      <label class="form-check mb-0">
        <input class="form-check-input" type="radio" name="extCode1" value="DECREASE">
        <span class="form-check-label">감소</span>
      </label>
    </div>
    <div class="form-text">extCode1 = 조정유형</div>
  </div>

  <div class="col-md-4">
    <label class="form-label mt-2">조정 수량(절대값)</label>
    <input type="number" class="form-control" name="extNo3" id="adjustQty" min="0" step="1" required />
    <div class="form-text">extNo3 = 조정수량</div>
  </div>

  <div class="col-md-4">
    <label class="form-label mt-2">기준 수량</label>
    <input type="number" class="form-control" name="extNo4" id="baseQty" readonly />
    <div class="form-text">extNo4 = 기준수량</div>
  </div>

  <div class="col-md-4">
    <label class="form-label mt-2">조정 후 수량</label>
    <input type="number" class="form-control" name="extNo5" id="afterQty" readonly />
    <div class="form-text">extNo5 = 조정후수량</div>
  </div>

  <div class="col-12 mt-2">
    <label class="form-label">조정 사유</label>
    <div class="d-flex flex-wrap gap-3">
      <label class="form-check mb-0"><input class="form-check-input" type="radio" name="extCode2" value="DAMAGED" checked> <span class="form-check-label">파손</span></label>
      <label class="form-check mb-0"><input class="form-check-input" type="radio" name="extCode2" value="LOST"> <span class="form-check-label">분실</span></label>
      <label class="form-check mb-0"><input class="form-check-input" type="radio" name="extCode2" value="MISINPUT"> <span class="form-check-label">오입력</span></label>
      <label class="form-check mb-0"><input class="form-check-input" type="radio" name="extCode2" value="ETC"> <span class="form-check-label">기타</span></label>
    </div>
    <div class="form-text">extCode2 = 조정사유</div>
  </div>

  <div class="col-12 mt-2">
    <label class="form-label">조정 내역</label>

    <!-- ✅ 추가/삭제 버튼 -->
    <div class="d-flex gap-2 mb-2">
      <button type="button" class="btn btn-sm btn-outline-primary" id="btnInvAdd">추가하기</button>
      <button type="button" class="btn btn-sm btn-outline-danger" id="btnInvDelete">선택삭제</button>
    </div>

    <div class="table-responsive">
      <table class="table table-sm table-bordered align-middle" id="invTable">
        <thead class="table-light">
          <tr>
            <th style="width:40px;" class="text-center">
              <input type="checkbox" id="invCheckAll" />
            </th>
            <th>조정 물품</th>
            <th style="width:120px;" class="text-end">조정 전</th>
            <th style="width:120px;" class="text-end">조정 후</th>
            <th style="width:180px;">조정 직원</th>
            <th>비고</th>
          </tr>
        </thead>

        <!-- ✅ 입력행(기존 1행 유지) -->
        <tbody id="invInputTbody">
          <tr id="invInputRow">
            <td class="text-center">-</td>
            <td><input type="text" class="form-control form-control-sm inv-item" /></td>
            <td><input type="number" class="form-control form-control-sm inv-before text-end" readonly /></td>
            <td><input type="number" class="form-control form-control-sm inv-after text-end" readonly /></td>
            <td><input type="text" class="form-control form-control-sm inv-operator" maxlength="50" /></td>
            <td><input type="text" class="form-control form-control-sm inv-remark" maxlength="100" /></td>
          </tr>
        </tbody>

        <!-- ✅ 누적행 -->
        <tbody id="invListTbody">
          <!-- JS로 누적 추가 -->
        </tbody>
      </table>
    </div>
  </div>
</div>
<script>
(function() {
  const branchSel  = document.getElementById("branchId");
  const productSel = document.getElementById("productId");
  const baseQtyEl  = document.getElementById("baseQty");
  const afterQtyEl = document.getElementById("afterQty");
  const qtyEl      = document.getElementById("adjustQty");
  const jsonEl     = document.getElementById("invItemsJson");

  const inputRow   = document.getElementById("invInputRow");
  const invItem    = inputRow.querySelector(".inv-item");
  const invBefore  = inputRow.querySelector(".inv-before");
  const invAfter   = inputRow.querySelector(".inv-after");
  const invOperator= inputRow.querySelector(".inv-operator");
  const invRemark  = inputRow.querySelector(".inv-remark");

  const listTbody  = document.getElementById("invListTbody");

  const btnAdd     = document.getElementById("btnInvAdd");
  const btnDel     = document.getElementById("btnInvDelete");
  const chkAll     = document.getElementById("invCheckAll");

  function getAdjustType() {
    return document.querySelector("input[name='extCode1']:checked")?.value || "INCREASE";
  }
  function setAdjustType(value) {
    const r = document.querySelector(`input[name='extCode1'][value='${value}']`);
    if (r) r.checked = true;
  }
  function toInt(v) {
    const n = Number(v);
    if (!Number.isFinite(n)) return 0;
    return Math.max(0, Math.trunc(n));
  }

  function selectedBaseQty() {
    const opt = productSel.options[productSel.selectedIndex];
    return toInt(opt?.dataset?.baseqty);
  }
  function selectedProductName() {
    const opt = productSel.options[productSel.selectedIndex];
    return (opt?.text || "").trim();
  }

  // ✅ 상단 입력만 초기화(지점/작성일/사유/상세사유는 유지)
  function resetInputOnly() {
    productSel.value = "";
    baseQtyEl.value = "";
    qtyEl.value = "";
    afterQtyEl.value = "";
    setAdjustType("INCREASE");

    invItem.value = "";
    invBefore.value = "";
    invAfter.value = "";
    invOperator.value = "";
    invRemark.value = "";

    if (chkAll) chkAll.checked = false;
  }

  // ✅ 누적 목록까지 초기화 (지점 변경 시 사용하는 정책)
  function resetAllRowsAndJson() {
    listTbody.innerHTML = "";
    jsonEl.value = "";
    resetInputOnly();
  }

  // ✅ product select 옵션 재구성
  function rebuildProductOptions(products) {
    productSel.innerHTML = `<option value="">상품 선택</option>`;
    const frag = document.createDocumentFragment();

    (products || []).forEach(p => {
      const opt = document.createElement("option");
      opt.value = p.productId;
      opt.dataset.baseqty = p.stockQty; // ✅ 기준수량
      opt.textContent = p.productName;
      frag.appendChild(opt);
    });

    productSel.appendChild(frag);
  }

  // ✅ 지점 선택 시 해당 지점 상품 목록 로드
  async function loadProductsByBranch(branchId) {
    rebuildProductOptions([]);   // 일단 비움
    resetAllRowsAndJson();       // ✅ 지점 바뀌면 기존 내역은 무조건 리셋(안전)

    if (!branchId) return;

    try {
      const res = await fetch(`/approval/api/branches/${branchId}/products`, {
        headers: { "Accept": "application/json" }
      });

      if (!res.ok) {
        alert("지점 상품 목록을 불러오지 못했습니다.");
        return;
      }

      const list = await res.json(); // [{productId, productName, stockQty}, ...]
      rebuildProductOptions(list);

    } catch (e) {
      console.error(e);
      alert("상품 목록 조회 중 오류가 발생했습니다.");
    }
  }

  // 상단 입력값을 기준으로 미리보기(조정 전/후 + inputRow 반영)
  function recalc() {
    const base = toInt(baseQtyEl.value);
    const adj  = toInt(qtyEl.value);
    const type = getAdjustType();

    let after = (type === "DECREASE") ? (base - adj) : (base + adj);
    if (after < 0) after = 0;

    afterQtyEl.value = after;

    invBefore.value = base;
    invAfter.value  = after;

    if (productSel.value && !invItem.value.trim()) {
      invItem.value = selectedProductName();
    }
  }

  // 누적행 -> JSON 재생성(extTxt6)
  function rebuildJson() {
    const rows = Array.from(listTbody.querySelectorAll("tr.inv-row"));
    const items = rows.map(tr => ({
      // ✅ 서버 검증 편하게 branchId도 함께 저장(선택)
      branchId: toInt(branchSel.value),
      productId: toInt(tr.dataset.productId),
      productName: (tr.querySelector(".col-name")?.textContent || "").trim(),
      beforeQty: toInt(tr.dataset.beforeQty),
      afterQty: toInt(tr.dataset.afterQty),
      operator: (tr.querySelector(".col-operator")?.textContent || "").trim(),
      remark: (tr.querySelector(".col-remark")?.textContent || "").trim()
    })).filter(x => x.productId);

    jsonEl.value = items.length ? JSON.stringify(items) : "";
  }

  function addItem() {
    const branchId = toInt(branchSel.value);
    if (!branchId) {
      alert("지점을 선택하세요.");
      return;
    }

    const productId = toInt(productSel.value);
    if (!productId) {
      alert("상품을 선택하세요.");
      return;
    }

    const base = toInt(baseQtyEl.value);
    const adj  = toInt(qtyEl.value);
    if (adj <= 0) {
      alert("조정 수량을 입력하세요.");
      return;
    }

    const type = getAdjustType();
    if (type === "DECREASE" && adj > base) {
      alert("감소 수량이 기준 수량을 초과합니다.");
      return;
    }

    const after = (type === "DECREASE") ? (base - adj) : (base + adj);

    const name = (invItem.value || "").trim() || selectedProductName();
    const operator = (invOperator.value || "").trim();
    const remark   = (invRemark.value || "").trim();

    // ✅ 누적행 추가
    const tr = document.createElement("tr");
    tr.className = "inv-row";
    tr.dataset.productId = String(productId);
    tr.dataset.beforeQty = String(base);
    tr.dataset.afterQty  = String(after);

    tr.innerHTML = `
      <td class="text-center"><input type="checkbox" class="inv-chk" /></td>
      <td class="col-name"></td>
      <td class="text-end">${base}</td>
      <td class="text-end">${after}</td>
      <td class="col-operator"></td>
      <td class="col-remark"></td>
    `;

    tr.querySelector(".col-name").textContent = name;
    tr.querySelector(".col-operator").textContent = operator;
    tr.querySelector(".col-remark").textContent = remark;

    listTbody.appendChild(tr);
    rebuildJson();

    // ✅ 입력값 초기화(지점/작성일/조정사유/상세사유는 그대로)
    resetInputOnly();
    productSel.focus();
  }

  function deleteChecked() {
    const checked = Array.from(listTbody.querySelectorAll(".inv-chk:checked"));
    checked.forEach(chk => chk.closest("tr")?.remove());
    if (chkAll) chkAll.checked = false;
    rebuildJson();
  }

  // 이벤트
  btnAdd.addEventListener("click", addItem);
  btnDel.addEventListener("click", deleteChecked);

  chkAll.addEventListener("change", () => {
    const on = chkAll.checked;
    listTbody.querySelectorAll(".inv-chk").forEach(c => c.checked = on);
  });

  // ✅ 지점 변경: 상품 재로딩
  branchSel.addEventListener("change", () => {
    loadProductsByBranch(branchSel.value);
  });

  // 상품 변경 시 기준수량/물품명 세팅
  productSel.addEventListener("change", () => {
    if (!productSel.value) {
      baseQtyEl.value = "";
      afterQtyEl.value = "";
      invItem.value = "";
      recalc();
      return;
    }
    baseQtyEl.value = selectedBaseQty();
    invItem.value = selectedProductName();
    recalc();
  });

  document.querySelectorAll("input[name='extCode1']").forEach(r => r.addEventListener("change", recalc));
  qtyEl.addEventListener("input", recalc);
  [invItem, invOperator, invRemark].forEach(el => el.addEventListener("input", recalc));

  // 초기
  // ✅ 수정 화면에서 branch가 이미 선택되어 있으면 상품을 branch 기준으로 재로딩
  if (branchSel.value) {
    loadProductsByBranch(branchSel.value);
  } else {
    rebuildProductOptions([]); // 상품 목록 비움
    resetAllRowsAndJson();
  }
})();
</script>
