(function () {
  const typeSelect = document.getElementById('approvalTypeCode');
  const extras = document.querySelectorAll('.doc-extra');
  const formCodeInput = document.getElementById('formCode');

  if (!typeSelect) return; // ✅ 방어

  // AT -> DF 매핑 (정책: AT012도 DF012로 임시 확정)
  const typeToForm = {
    "AT001": "DF001",
    "AT002": "DF002",
    "AT003": "DF003",
    "AT004": "DF004",
    "AT005": "DF005",
    "AT006": "DF006",
    "AT007": "DF007",
    "AT008": "DF008",
    "AT009": "DF009",
    "AT010": "DF010",
    "AT011": "DF011",
    "AT012": "DF012" // ✅ 임시 정책 확정(나중에 바꾸면 됨)
  };

  function syncFormCode(typeCode) {
    if (!formCodeInput) return;
    formCodeInput.value = typeToForm[typeCode] || "";
  }

  function setEnabled(container, enabled) {
    const fields = container.querySelectorAll('input, select, textarea, button');
    fields.forEach(f => { f.disabled = !enabled; });
  }

  function hideAll() {
    extras.forEach(el => {
      el.style.display = 'none';
      setEnabled(el, false);
    });
  }

  function showDefaultOnly() {
    hideAll();
    extras.forEach(el => {
      if (el.getAttribute('data-type') === '__DEFAULT__') {
        el.style.display = '';
        setEnabled(el, true);
      }
    });
  }

  function showExtras(typeCode) {
    hideAll();

    let matched = false;
    extras.forEach(el => {
      const t = el.getAttribute('data-type');
      const on = (t === typeCode);

      if (on) {
        el.style.display = '';
        setEnabled(el, true);
        matched = true;
      }
    });

    if (!matched) {
      showDefaultOnly();
    }
  }

  function apply() {
    const typeCode = typeSelect.value;
    syncFormCode(typeCode);
    showExtras(typeCode);
  }

  typeSelect.addEventListener('change', apply);

  // 초기 1회
  apply();
})();
