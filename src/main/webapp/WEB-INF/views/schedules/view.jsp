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

                <!-- 일정 등록/수정 Modal -->
                <div class="modal fade" id="eventModal" tabindex="-1" role="dialog" aria-labelledby="eventModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="eventModalLabel">일정 등록</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
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
                                        <label for="eventAttendees">참석자 (쉼표로 구분)</label>
                                        <input type="text" class="form-control" id="eventAttendees" placeholder="사용자 ID를 쉼표로 구분하여 입력">
                                        <small class="form-text text-muted">참석자 선택 기능은 추후 추가 예정입니다.</small>
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
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
<script>
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko', // Korean
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        events: function(fetchInfo, successCallback, failureCallback) {
            fetch('/schedules/events?start=' + fetchInfo.startStr + '&end=' + fetchInfo.endStr)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    const formattedEvents = data.map(event => ({
                        id: event.eventId,
                        title: event.title,
                        start: event.startAt,
                        end: event.endAt,
                        allDay: event.allDay,
                    }));
                    successCallback(formattedEvents);
                })
                .catch(error => {
                    console.error('Error fetching events:', error);
                    failureCallback(error);
                });
        }
    });
    calendar.render();

    // "일정 등록" 버튼 클릭 시 모달 표시
    document.getElementById('addEventBtn').addEventListener('click', function() {
        // 폼 초기화
        document.getElementById('eventForm').reset();
        document.getElementById('eventId').value = '';
        document.getElementById('eventModalLabel').textContent = '일정 등록';
        // 기본값 설정 (예: 시작일시를 현재 시간으로)
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset()); // Adjust for timezone
        document.getElementById('eventStart').value = now.toISOString().slice(0, 16);
        now.setHours(now.getHours() + 1); // Default end 1 hour later
        document.getElementById('eventEnd').value = now.toISOString().slice(0, 16);

        $('#eventModal').modal('show');
    });

    // 저장 버튼 클릭 시 이벤트 처리
    document.getElementById('saveEventBtn').addEventListener('click', function() {
        const eventData = {
            eventId: document.getElementById('eventId').value || null, // 수정 시 사용될 eventId
            scope: document.getElementById('eventType').value,
            title: document.getElementById('eventTitle').value,
            startAt: document.getElementById('eventStart').value,
            endAt: document.getElementById('eventEnd').value,
            location: document.getElementById('eventLocation').value,
            // attendees: document.getElementById('eventAttendees').value.split(',').map(s => s.trim()).filter(s => s.length > 0), // 배열 처리
            // repeating: document.getElementById('eventRepeating').checked,
            // attachments: document.getElementById('eventAttachments').files, // FileList 객체
            // notification: document.getElementById('eventNotification').checked,
            description: document.getElementById('eventDescription').value,
        };

        fetch('/schedules/events', { // POST 또는 PUT (eventId 유무에 따라)
            method: eventData.eventId ? 'PUT' : 'POST', // 현재는 POST만 구현되어 있으므로 추후 PUT 구현 필요
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(eventData),
        })
        .then(response => {
            if (!response.ok) {
                // 응답이 성공적이지 않으면 에러 처리
                return response.text().then(text => { throw new Error(text) });
            }
            return response.json();
        })
        .then(data => {
            console.log('Success:', data);
            $('#eventModal').modal('hide');
            calendar.refetchEvents(); // 캘린더 새로고침
        })
        .catch((error) => {
            console.error('Error:', error);
            alert('일정 저장에 실패했습니다: ' + error.message);
        });
    });
});
</script>
