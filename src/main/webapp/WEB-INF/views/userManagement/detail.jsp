<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/admin_header.jsp" />

<div class="content-wrapper">
    <section class="content">
        <div class="container-fluid">

            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title">사용자 상세</h3>
                </div>

                <div class="card-body">
                    <table class="table table-bordered">
                        <tr>
                            <th style="width: 200px;">사용자 ID</th>
                            <td>${user.userId}</td>
                        </tr>
                        <tr>
                            <th>아이디</th>
                            <td>${user.loginId}</td>
                        </tr>
                        <tr>
                            <th>이름</th>
                            <td>${user.name}</td>
                        </tr>
                        <tr>
                            <th>지점</th>
                            <td>${user.branchName}</td>
                        </tr>
                        <tr>
                            <th>부서</th>
                            <td>${user.departmentName}</td>
                        </tr>
                        <tr>
                            <th>권한</th>
                            <td>
                                <span class="badge bg-info text-dark">
                                    ${user.roleName}
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>상태</th>
                            <td>
                                <span class="badge bg-success text-dark">
                                    ${user.userStatusName}
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>로그인 실패 횟수</th>
                            <td>${user.failCount}</td>
                        </tr>
                        <tr>
                            <th>등록일</th>
                            <td>${user.createDate}</td>
                        </tr>
                    </table>
                </div>

                <div class="card-footer text-right">
                    <a href="/userManagement/list" class="btn btn-secondary">
                        목록
                    </a>
                    <a href="/userManagement/edit?userId=${user.userId}"
                       class="btn btn-primary">
                        수정
                    </a>
                </div>
            </div>

        </div>
    </section>
</div>

<jsp:include page="../includes/admin_footer.jsp" />
