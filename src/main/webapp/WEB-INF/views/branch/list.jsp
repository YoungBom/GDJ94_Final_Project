<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../includes/admin_header.jsp" />

<!-- Main content for branch list -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">지점 목록</h3>
            </div>
            <div class="card-body">
                <p>이곳에 지점 목록 테이블이 표시됩니다.</p>
                <!-- Example Table -->
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th style="width: 10px">#</th>
                            <th>지점명</th>
                            <th>주소</th>
                            <th style="width: 40px">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1.</td>
                            <td>강남점</td>
                            <td>서울시 강남구</td>
                            <td><span class="badge bg-success">운영중</span></td>
                        </tr>
                        <tr>
                            <td>2.</td>
                            <td>홍대점</td>
                            <td>서울시 마포구</td>
                            <td><span class="badge bg-success">운영중</span></td>
                        </tr>
                        <tr>
                            <td>3.</td>
                            <td>부산점</td>
                            <td>부산시 해운대구</td>
                            <td><span class="badge bg-danger">폐점</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/admin_footer.jsp" />
