<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

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
        <option value="${p.productId}"
                data-price="${p.price}"
                data-stock="${p.stockQty}">
          <c:out value="${p.productName}"/>
          <c:if test="${not empty p.productDesc}">
            - <c:out value="${p.productDesc}"/>
          </c:if>
          <c:if test="${p.stockQty ne null}">
            (재고: <c:out value="${p.stockQty}"/>)
          </c:if>
        </option>
      </c:forEach>
    </select>
    <div class="form-text">extNo2 = productId</div>
    <div class="form-text" id="stockInfo">현재 재고: -</div>
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
    <input type="number" class="form-control" name="extNo3" id="adjustQty" min="1" step="1" required />
    <div class="form-text">extNo3 = 조정수량</div>
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

    <div class="d-flex gap-2 mb-2">
      <button type="button" class="btn btn-sm btn-outline-primary" id="btnInvAdd">추가하기</button>
      <button type="button" class="btn btn-sm btn-outline-danger" id="btnInvDelete">선택삭제</button>
    </div>

    <div class="table-responsive">
      <table class="table table-sm table-bordered align-middle" id="invTable">
        <thead class="table-light">
          <tr>
            <th style="width:40px;" class="text-center"><input type="checkbox" id="invCheckAll" /></th>
            <th>조정 물품</th>
            <th style="width:120px;" class="text-center">유형</th>
            <th style="width:120px;" class="text-end">현재 수량</th>
            <th style="width:120px;" class="text-end">조정 수량</th>
            <th style="width:180px;">조정 직원</th>
            <th>비고</th>
          </tr>
        </thead>

        <tbody id="invInputTbody">
          <tr id="invInputRow">
            <td class="text-center">-</td>
            <td><input type="text" class="form-control form-control-sm inv-item" /></td>
            <td class="text-center"><input type="text" class="form-control form-control-sm inv-type text-center" readonly /></td>
            <td><input type="number" class="form-control form-control-sm inv-stock text-end" readonly /></td>
            <td><input type="number" class="form-control form-control-sm inv-adj text-end" readonly /></td>
            <td><input type="text" class="form-control form-control-sm inv-operator" maxlength="50" /></td>
            <td><input type="text" class="form-control form-control-sm inv-remark" maxlength="100" /></td>
          </tr>
        </tbody>

        <tbody id="invListTbody"></tbody>
      </table>
    </div>
  </div>
</div>
<script>
(function () {
  "use strict";

  // ctx 안전 주입 (ctx와 pageContext 혼용하지 말고 하나로 통일)
  var ctx = "<c:out value='${pageContext.request.contextPath}'/>";

  // id 중복/동적교체 대비: "보이는" select를 우선 선택
  function pickVisibleSelect(selector) {
    var els = Array.from(document.querySelectorAll(selector));
    if (els.length === 0) return null;
    // 화면에 실제로 렌더되는 요소 우선
    var visible = els.find(function (el) { return el && el.offsetParent !== null; });
    return visible || els[0];
  }

  function el(id) { return document.getElementById(id); }

  // DOM ready 유사 처리 (JSP는 보통 하단에 스크립트가 와서 즉시 실행돼도 됨)
  function init() {

    // 여기서부터는 id 중복을 고려해서 querySelector 기반으로 잡는다
    var branchSel  = pickVisibleSelect('select[name="extNo1"]'); // 지점은 name으로 고정
    var productSel = el("productId");
    var qtyEl      = el("adjustQty");
    var jsonEl     = el("invItemsJson");
    var stockInfo  = el("stockInfo");

   

    var inputRow    = el("invInputRow");
    var invItem     = inputRow ? inputRow.querySelector(".inv-item") : null;
    var invType     = inputRow ? inputRow.querySelector(".inv-type") : null;
    var invStock    = inputRow ? inputRow.querySelector(".inv-stock") : null;
    var invAdj      = inputRow ? inputRow.querySelector(".inv-adj") : null;
    var invOperator = inputRow ? inputRow.querySelector(".inv-operator") : null;
    var invRemark   = inputRow ? inputRow.querySelector(".inv-remark") : null;

    var listTbody  = el("invListTbody");
    var btnAdd     = el("btnInvAdd");
    var btnDel     = el("btnInvDelete");
    var chkAll     = el("invCheckAll");

    function getAdjustType() {
      var r = document.querySelector("input[name='extCode1']:checked");
      return r ? r.value : "INCREASE";
    }
    function setAdjustType(value) {
      var r = document.querySelector("input[name='extCode1'][value='" + value + "']");
      if (r) r.checked = true;
    }
    function toInt(v) {
      var n = Number(v);
      if (!Number.isFinite(n)) return 0;
      return Math.max(0, Math.trunc(n));
    }

    function selectedOpt() {
      return productSel.options[productSel.selectedIndex] || null;
    }
    function selectedProductText() {
      var opt = selectedOpt();
      return (opt && opt.text ? opt.text : "").trim();
    }
    function selectedPrice() {
      var opt = selectedOpt();
      var p = Number(opt && opt.dataset ? opt.dataset.price : NaN);
      return Number.isFinite(p) ? p : null;
    }
    function selectedStock() {
      var opt = selectedOpt();
      var s = Number(opt && opt.dataset ? opt.dataset.stock : NaN);
      return Number.isFinite(s) ? s : null;
    }

    function resetInputOnly() {
      productSel.value = "";
      qtyEl.value = "";
      setAdjustType("INCREASE");

      if (invItem) invItem.value = "";
      if (invType) invType.value = "";
      if (invStock) invStock.value = "";
      if (invAdj) invAdj.value = "";
      if (invOperator) invOperator.value = "";
      if (invRemark) invRemark.value = "";

      if (stockInfo) stockInfo.textContent = "현재 재고: -";
      if (chkAll) chkAll.checked = false;
    }

    function resetAllRowsAndJson() {
      if (listTbody) listTbody.innerHTML = "";
      jsonEl.value = "";
      resetInputOnly();
    }

    function rebuildProductOptions(products) {
      productSel.innerHTML = '<option value="">상품 선택</option>';
      var frag = document.createDocumentFragment();

      (products || []).forEach(function (p) {
        var opt = document.createElement("option");
        opt.value = p.productId;

        if (p.price != null) opt.dataset.price = p.price;
        if (p.stockQty != null) opt.dataset.stock = p.stockQty;

        var label =
          (p.productName || "") +
          (p.productDesc ? (" - " + p.productDesc) : "") +
          (p.stockQty != null ? (" (재고: " + p.stockQty + ")") : "");

        opt.textContent = label;
        frag.appendChild(opt);
      });

      productSel.appendChild(frag);
    }

    async function loadProductsByBranch(branchId) {
      rebuildProductOptions([]);
      resetAllRowsAndJson();
      if (!branchId) return;

      var url = ctx + "/approval/products?branchId=" + encodeURIComponent(branchId);

      try {
        var res = await fetch(url, { headers: { "Accept": "application/json" } });
        if (!res.ok) throw new Error("HTTP " + res.status);

        var products = await res.json();
        rebuildProductOptions(products);
      } catch (e) {
        alert("상품 목록을 불러오지 못했습니다.");
        rebuildProductOptions([]);
      }
    }

    function recalcPreview() {
      var type = getAdjustType();
      var adj  = toInt(qtyEl.value);

      if (invType) invType.value = (type === "DECREASE") ? "감소" : "증가";
      if (invAdj) invAdj.value  = adj ? String(adj) : "";

      var stock = selectedStock();
      if (invStock) invStock.value = (stock == null) ? "" : String(stock);
      if (stockInfo) stockInfo.textContent = "현재 재고: " + (stock == null ? "-" : stock);

      if (productSel.value && invItem && !invItem.value.trim()) {
        invItem.value = selectedProductText();
      }
    }

    function textOf(tr, sel) {
      if (!tr) return "";
      var x = tr.querySelector(sel);
      return x ? (x.textContent || "").trim() : "";
    }

    function rebuildJson() {
      if (!listTbody) return;
      var rows = Array.from(listTbody.querySelectorAll("tr.inv-row"));
      var items = rows.map(function (tr) {
        return {
          branchId: toInt(branchSel.value),
          productId: Number(tr.dataset.productId),
          productName: textOf(tr, ".col-name"),
          adjustType: tr.dataset.adjustType || "INCREASE",
          adjustQty: Number(tr.dataset.adjustQty),
          signedQty: Number(tr.dataset.signedQty),
          stockQty: tr.dataset.stockQty ? Number(tr.dataset.stockQty) : null,
          operator: textOf(tr, ".col-operator"),
          remark: textOf(tr, ".col-remark"),
          price: tr.dataset.price ? Number(tr.dataset.price) : null
        };
      }).filter(function (x) { return x.productId; });

      jsonEl.value = items.length ? JSON.stringify(items) : "";
    }

    function addItem() {
      var branchId = toInt(branchSel.value);
      if (!branchId) return alert("지점을 선택하세요.");

      var productId = toInt(productSel.value);
      if (!productId) return alert("상품을 선택하세요.");

      var adj = toInt(qtyEl.value);
      if (adj <= 0) return alert("조정 수량을 입력하세요.");

      var type = getAdjustType();
      var signedQty = (type === "DECREASE") ? -adj : adj;

      var stock = selectedStock();
      if (type === "DECREASE" && stock != null && adj > stock) {
        return alert("재고(" + stock + ")보다 큰 수량은 감소 처리할 수 없습니다.");
      }

      var name = (invItem && invItem.value ? invItem.value : "").trim() || selectedProductText();
      var operator = (invOperator && invOperator.value ? invOperator.value : "").trim();
      var remark   = (invRemark && invRemark.value ? invRemark.value : "").trim();
      var price    = selectedPrice();

      var tr = document.createElement("tr");
      tr.className = "inv-row";
      tr.dataset.productId = String(productId);
      tr.dataset.adjustType = type;
      tr.dataset.adjustQty  = String(adj);
      tr.dataset.signedQty  = String(signedQty);
      if (price != null) tr.dataset.price = String(price);
      if (stock != null) tr.dataset.stockQty = String(stock);

      tr.innerHTML =
        '<td class="text-center"><input type="checkbox" class="inv-chk" /></td>' +
        '<td class="col-name"></td>' +
        '<td class="text-center">' + (type === "DECREASE" ? "감소" : "증가") + '</td>' +
        '<td class="text-end">' + (stock == null ? "-" : stock) + '</td>' +
        '<td class="text-end">' + signedQty + '</td>' +
        '<td class="col-operator"></td>' +
        '<td class="col-remark"></td>';

      tr.querySelector(".col-name").textContent = name;
      tr.querySelector(".col-operator").textContent = operator;
      tr.querySelector(".col-remark").textContent = remark;

      listTbody.appendChild(tr);
      rebuildJson();

      resetInputOnly();
      productSel.focus();
    }

    function deleteChecked() {
      if (!listTbody) return;
      var checked = Array.from(listTbody.querySelectorAll(".inv-chk:checked"));
      checked.forEach(function (chk) {
        var tr = chk.closest("tr");
        if (tr) tr.remove();
      });
      if (chkAll) chkAll.checked = false;
      rebuildJson();
    }

    if (btnAdd) btnAdd.addEventListener("click", addItem);
    if (btnDel) btnDel.addEventListener("click", deleteChecked);

    if (chkAll) {
      chkAll.addEventListener("change", function () {
        var on = chkAll.checked;
        if (!listTbody) return;
        listTbody.querySelectorAll(".inv-chk").forEach(function (c) { c.checked = on; });
      });
    }

    // 지점 변경: "위임"으로 한번 더 안전장치 (id 중복/DOM교체 방어)
    document.addEventListener("change", function (e) {
      if (e.target && e.target.matches('select[name="extNo1"]')) {
        // branchSel이 교체되었을 수 있으니 갱신
        branchSel = pickVisibleSelect('select[name="extNo1"]') || e.target;
        loadProductsByBranch(branchSel.value);
      }
    });

    productSel.addEventListener("change", function () {
      if (!productSel.value) {
        if (invItem) invItem.value = "";
        recalcPreview();
        return;
      }
      if (invItem) invItem.value = selectedProductText();
      recalcPreview();
    });

    document.querySelectorAll("input[name='extCode1']").forEach(function (r) {
      r.addEventListener("change", recalcPreview);
    });

    qtyEl.addEventListener("input", recalcPreview);
    [invItem, invOperator, invRemark].filter(Boolean).forEach(function (x) {
      x.addEventListener("input", recalcPreview);
    });

    // 초기 상태
    if (branchSel.value) {
      loadProductsByBranch(branchSel.value);
    } else {
      rebuildProductOptions([]);
      resetAllRowsAndJson();
    }
  }

  // DOMContentLoaded가 이미 지난 경우 대비
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
</script>
