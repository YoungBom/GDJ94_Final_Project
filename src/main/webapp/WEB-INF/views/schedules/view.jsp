<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="../includes/admin_header.jsp" />

<!-- Main content for schedule view -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">월간 일정</h3>
            </div>
            <div class="card-body">
                <p>이곳에 전체 일정을 볼 수 있는 캘린더가 표시됩니다.</p>
                <!-- FullCalendar will be initialized here -->
                <button id="addEventBtn" class="btn btn-primary mb-3">일정 등록</button>
                <div id="calendar"></div>

                <!-- 일정 목록 표시 영역 -->
                <div id="event-list-container" class="mt-4">
                    <h4 id="event-list-title">오늘의 일정</h4>
                    <ul id="event-list" class="list-group">
                        <!-- JS will populate this -->
                    </ul>
                </div>

                <!-- 일정 등록/수정 Modal -->
                <div class="modal fade" id="eventModal" tabindex="-1" role="dialog" aria-labelledby="eventModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="eventModalLabel">일정 등록</h5>
                                <!-- X 버튼 제거 -->
                            </div>
                            <div class="modal-body">
                                <form id="eventForm">
                                    <input type="hidden" id="eventId">
                                    
                                    <div class="form-group">
                                        <label for="eventType">일정 유형</label>
                                        <select class="form-control" id="eventType">
                                            <option value="PERSONAL">개인</option>
                                            <option value="DEPARTMENT">부서</option>
                                            <option value="COMPANY">전사</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="eventTitle">일정 제목</label>
                                        <input type="text" class="form-control" id="eventTitle" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventStart">시작 일시</label>
                                        <input type="datetime-local" class="form-control" id="eventStart" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventEnd">종료 일시</label>
                                        <input type="datetime-local" class="form-control" id="eventEnd" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventLocation">장소</label>
                                        <input type="text" class="form-control" id="eventLocation">
                                    </div>
                                    <div class="form-group">
                                        <label for="attendeeSearch">참석자</label>
                                        <div id="selected-attendees" class="mb-2">
                                            <!-- Selected attendees will be shown here as pills -->
                                        </div>
                                        <input type="text" class="form-control" id="attendeeSearch" placeholder="이름으로 검색...">
                                        <div id="attendee-search-results" class="list-group" style="position: absolute; z-index: 1000; width: 95%;">
                                            <!-- Search results will be shown here -->
                                        </div>
                                    </div>
                                    <div class="form-group form-check">
                                        <input type="checkbox" class="form-check-input" id="eventRepeating">
                                        <label class="form-check-label" for="eventRepeating">반복 여부</label>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventAttachments">파일 첨부</label>
                                        <input type="file" class="form-control-file" id="eventAttachments" multiple>
                                        <small class="form-text text-muted">다중 파일 첨부 가능. 실제 업로드 로직은 추후 추가 예정입니다.</small>
                                    </div>
                                    <div class="form-group form-check">
                                        <input type="checkbox" class="form-check-input" id="eventNotification">
                                        <label class="form-check-label" for="eventNotification">알림 설정</label>
                                        <small class="form-text text-muted">알림 설정 기능은 추후 추가 예정입니다.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="eventDescription">내용</label>
                                        <textarea class="form-control" id="eventDescription" rows="3"></textarea>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                <button type="button" id="saveEventBtn" class="btn btn-primary">저장</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/admin_footer.jsp" />

<!-- Page specific script for FullCalendar -->
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js'></script>
<script src="<c:url value='/js/schedules.js'/>"></script>
