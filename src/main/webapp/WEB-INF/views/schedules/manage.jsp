<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="../includes/admin_header.jsp" />

<!-- Main content -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">내가 생성한 일정 목록</h3>
            </div>
            <!-- /.card-header -->
            <div class="card-body">
                <table id="eventManageTable" class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>제목</th>
                            <th>유형</th>
                            <th>시작 일시</th>
                            <th>종료 일시</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty eventList}">
                                <c:forEach var="event" items="${eventList}">
                                    <tr>
                                        <td><c:out value="${event.title}" /></td>
                                        <td><c:out value="${event.scope.displayName}" /></td>
                                        <td><c:set var="startAtStr" value="${event.startAt.toString()}" /><c:out value="${fn:replace(startAtStr, 'T', ' ')}" /></td>
                                        <td><c:set var="endAtStr" value="${event.endAt.toString()}" /><c:out value="${fn:replace(endAtStr, 'T', ' ')}" /></td>
                                        <td><c:out value="${event.statusCode.displayName}" /></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary btn-edit-event" data-event-id="${event.eventId}">수정</button>
                                            <button class="btn btn-sm btn-danger btn-delete-event" data-event-id="${event.eventId}">삭제</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center">표시할 일정이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <!-- /.card-body -->
        </div>
        <!-- /.card -->
    </div>
</div>

<jsp:include page="../includes/admin_footer.jsp" />

<script>
document.addEventListener('DOMContentLoaded', function() {
    const tableBody = document.querySelector('#eventManageTable tbody');

    tableBody.addEventListener('click', function(e) {
        // '삭제' 버튼 클릭 이벤트 위임
        if (e.target && e.target.classList.contains('btn-delete-event')) {
            const button = e.target;
            const eventId = button.dataset.eventId;

            if (confirm('정말 이 일정을 삭제하시겠습니까? 관련된 모든 정보가 삭제됩니다.')) {
                fetch(`/schedules/events/${eventId}/delete`, {
                    method: 'POST',
                    headers: {
                        // Spring Security CSRF 토큰이 필요할 경우 헤더에 추가
                    }
                })
                .then(response => {
                    if (response.ok) {
                        // UI에서 해당 행 제거
                        button.closest('tr').remove();
                        alert('일정이 삭제되었습니다.');
                    } else {
                        response.text().then(text => {
                            alert('삭제에 실패했습니다: ' + text);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
            }
        }
        
        // TODO: '수정' 버튼 클릭 이벤트 처리
        if (e.target && e.target.classList.contains('btn-edit-event')) {
            const eventId = e.target.dataset.eventId;
            alert('수정 기능은 아직 구현되지 않았습니다. Event ID: ' + eventId);
            // 1. /schedules/events/{eventId} 로 단일 이벤트 정보 조회 API 호출
            // 2. 응답 받은 데이터로 메인 페이지의 #eventModal 폼 채우기
            // 3. 모달 띄우기
        }
    });
});
</script>
