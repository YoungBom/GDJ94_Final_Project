<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../includes/admin_header.jsp" />

<!-- Main content for user list -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">사용자 목록</h3>
            </div>
            <div class="card-body">
                <p>이곳에 사용자 목록 테이블이 표시됩니다.</p>
                <!-- Example Table -->
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th style="width: 10px">#</th>
                            <th>사용자명</th>
                            <th>이메일</th>
                            <th>역할</th>
                            <th style="width: 40px">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1.</td>
                            <td>김관리자</td>
                            <td>admin@example.com</td>
                            <td>관리자</td>
                            <td><span class="badge bg-success">활성</span></td>
                        </tr>
                        <tr>
                            <td>2.</td>
                            <td>이사용자</td>
                            <td>user@example.com</td>
                            <td>사용자</td>
                            <td><span class="badge bg-success">활성</span></td>
                        </tr>
                        <tr>
                            <td>3.</td>
                            <td>박비활성</td>
                            <td>inactive@example.com</td>
                            <td>사용자</td>
                            <td><span class="badge bg-danger">비활성</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/admin_footer.jsp" />
