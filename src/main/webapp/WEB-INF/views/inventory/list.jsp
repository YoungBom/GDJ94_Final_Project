<form method="get" action="<c:url value='/inventory'/>" class="row g-2 mb-3">
    <!-- 검색 시 항상 1페이지부터 -->
    <input type="hidden" name="page" value="1"/>
    <input type="hidden" name="size" value="${size}"/>

    <div class="col-md-3">
        <label class="form-label">지점</label>
        <select name="branchId" class="form-select" <c:if test="${branchLocked}">disabled</c:if>>
            <c:if test="${not branchLocked}">
                <option value="">전체</option>
            </c:if>

            <c:forEach var="branch" items="${branches}">
                <option value="${branch.id}"
                        <c:if test="${not empty branchId and branchId == branch.id}">selected</c:if>>
                        ${branch.name}
                </option>
            </c:forEach>
        </select>
    </div>
    ...
</form>

<c:if test="${branchLocked}">
    <div class="alert alert-info py-2">
        현재 계정은 <strong>지점 단위(READONLY)</strong>로 동작합니다. (본인 지점 재고만 조회 가능)
    </div>
</c:if>

<!-- 테이블 아래 -->
<c:if test="${totalPages > 1}">
    <nav aria-label="재고 페이지네이션" class="mt-3">
        <ul class="pagination justify-content-center mb-0">
            ...
        </ul>
    </nav>
</c:if>
