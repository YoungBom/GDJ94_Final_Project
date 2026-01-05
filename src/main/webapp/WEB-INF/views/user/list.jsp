<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="../includes/admin_header.jsp" />

<section class="content">
  <div class="container-fluid">

    <div class="card">
      <div class="card-header d-flex justify-content-between align-items-center">
        <h3 class="card-title">사용자 목록</h3>
      </div>

      <div class="card-body">
        <table class="table table-bordered table-hover">
          <thead>
            <tr>
              <th style="width:60px">번호</th>
              <th>아이디</th>
              <th>이름</th>
              <th>지점</th>
              <th>권한</th>
              <th>상태</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="u" items="${userList}" varStatus="st">
              <tr>
                <td>${st.count}</td>
                <td>${u.loginId}</td>
                <td>
                  <a href="/user/detail?userId=${u.userId}">
                    ${u.name}
                  </a>
                </td>
                <td>${u.branchName}</td>
                <td>${u.roleCode}</td>
                <td>${u.statusCode}</td>
              </tr>
            </c:forEach>

            <c:if test="${empty userList}">
              <tr>
                <td colspan="6" class="text-center">
                  등록된 사용자가 없습니다.
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</section>

<jsp:include page="../includes/admin_footer.jsp" />
