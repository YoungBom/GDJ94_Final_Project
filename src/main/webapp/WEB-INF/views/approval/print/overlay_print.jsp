<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="t" value="${doc.typeCode}" />

<c:choose>
  <c:when test="${t eq 'AT001'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/expense.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_expense.jspf" />
  </c:when>
  <c:when test="${t eq 'AT002'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/settlement.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_settlement.jspf" />
  </c:when>
  <c:when test="${t eq 'AT003'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/sales.jpg" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_sales.jspf" />
  </c:when>
  <c:when test="${t eq 'AT004'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/settlement.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_inventory.jspf" />
  </c:when>
  <c:when test="${t eq 'AT005'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/purchase_request.jpg" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_purchase.jspf" />
  </c:when>
  <c:when test="${t eq 'AT006'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/purchase_order.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_order.jspf" />
  </c:when>
  <c:when test="${t eq 'AT009'}">
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/leave.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_vacation.jspf" />
  </c:when>
  <c:otherwise>
    <c:set var="bgImageUrl" value="${pageContext.request.contextPath}/approval/formPng/leave.png" />
    <c:set var="fieldsJspf" value="/WEB-INF/views/approval/print/_fields_common.jspf" />
  </c:otherwise>
</c:choose>

<style>
  .back-btn{display:inline-flex;align-items:center;gap:6px;padding:6px 12px;border:1.5px solid #cbd5e1;border-radius:999px;background:#fff;color:#334155;font-size:13px;font-weight:600;text-decoration:none;box-shadow:0 1px 2px rgba(0,0,0,.08);transition:all .15s ease;}
  .back-btn:hover{background:#f8fafc;border-color:#94a3b8;transform:translateY(-1px);} 
  .back-btn:active{transform:translateY(0);box-shadow:none;}
</style>

<c:if test="${param.preview ne '1'}">
  <div class="d-flex justify-content-end mb-2">
    <a class="back-btn" href="/approval/detail?docVerId=${docVerId}">← 돌아가기</a>
  </div>
</c:if>

<%@ include file="_print_base.jspf" %>
