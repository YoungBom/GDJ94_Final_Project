document.addEventListener('DOMContentLoaded', function() {
    let currentScope = 'all'; // 현재 필터 scope 저장 변수
    const eventList = document.getElementById('event-list');
    const eventListTitle = document.getElementById('event-list-title');

    // --- 참석자 검색 관련 로직 ---
    let selectedAttendees = []; // {userId, name, departmentName} 객체의 배열
    const attendeeSearchInput = document.getElementById('attendeeSearch');
    const searchResultsContainer = document.getElementById('attendee-search-results');
    const selectedAttendeesContainer = document.getElementById('selected-attendees');

    // 선택된 참석자 UI 렌더링
    const renderSelectedAttendees = () => {
        selectedAttendeesContainer.innerHTML = '';
        selectedAttendees.forEach(user => {
            const pill = document.createElement('span');
            pill.className = 'badge bg-primary me-1';
            pill.innerHTML = `${user.name} (${user.departmentName || '부서없음'}) <span class="badge bg-danger" data-remove-id="${user.userId}" style="cursor:pointer;">X</span>`;
            selectedAttendeesContainer.appendChild(pill);
        });
    };
    
    // 참석자 검색 및 결과 표시
    attendeeSearchInput.addEventListener('keyup', (e) => {
        const query = e.target.value.trim();
        searchResultsContainer.innerHTML = '';
        if (query.length < 1) return;

        fetch('/schedules/users/search?name=' + encodeURIComponent(query))
            .then(response => response.json())
            .then(users => {
                searchResultsContainer.innerHTML = '';
                const unselectedUsers = users.filter(user => !selectedAttendees.some(su => su.userId === user.userId));
                
                unselectedUsers.forEach(user => {
                    const item = document.createElement('a');
                    item.href = '#';
                    item.className = 'list-group-item list-group-item-action';
                    item.textContent = `${user.name} (${user.departmentName || '부서없음'})`; // 부서명 없을 경우 대비
                    item.addEventListener('click', (e) => {
                        e.preventDefault();
                        selectedAttendees.push(user);
                        renderSelectedAttendees();
                        attendeeSearchInput.value = '';
                        searchResultsContainer.innerHTML = '';
                    });
                    searchResultsContainer.appendChild(item);
                });
            })
            .catch(error => console.error('Error fetching users:', error));
    });

    // 선택된 참석자 제거
    selectedAttendeesContainer.addEventListener('click', (e) => {
        if (e.target.dataset.removeId) {
            const userIdToRemove = parseInt(e.target.dataset.removeId, 10);
            selectedAttendees = selectedAttendees.filter(user => user.userId !== userIdToRemove);
            renderSelectedAttendees();
        }
    });
    // --- 참석자 검색 로직 종료 ---


    // 날짜 포맷 함수
    const formatDate = (date) => {
        return new Date(date).toLocaleDateString('ko-KR', {
            year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
        });
    };

    // 이벤트 목록을 업데이트하는 함수
    const updateEventList = (date, allEvents) => {
        eventList.innerHTML = '';
        const targetDate = new Date(date);
        targetDate.setHours(0, 0, 0, 0);

        // BUG FIX: Check if targetDate is within the event's range
        const eventsForDate = allEvents.filter(event => {
            const eventStart = new Date(event.start);
            eventStart.setHours(0, 0, 0, 0);

            if (!event.end) {
                return eventStart.getTime() === targetDate.getTime();
            } else {
                const eventEnd = new Date(event.end);
                // The `end` property of all-day events is exclusive. 
                // An event from 1st to 3rd has an end of 4th 00:00.
                // We need to check if targetDate is >= start AND < end.
                return targetDate >= eventStart && targetDate < eventEnd;
            }
        });

        eventListTitle.textContent = `${formatDate(date)}의 일정`;

        if (eventsForDate.length === 0) {
            eventList.innerHTML = '<li class="list-group-item">일정이 없습니다.</li>';
            return;
        }

        eventsForDate.forEach(event => {
            const li = document.createElement('li');
            li.className = 'list-group-item';
            
            // NEW FEATURE: Display time or "All day"
            const start = new Date(event.start);
            const timeString = event.allDay ? '종일' : start.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit', hour12: false });

            li.innerHTML = `<strong>${timeString}</strong> - ${event.title}`;
            
            let eventBorderColor = event.borderColor;
            if (event.rendering === 'background') {
                eventBorderColor = '#6c757d'; 
            }
            li.style.borderLeft = '5px solid ' + eventBorderColor;
            eventList.appendChild(li);
        });
    };

    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        events: function(fetchInfo, successCallback, failureCallback) {
            let fetchUrl = '/schedules/events?start=' + fetchInfo.startStr + '&end=' + fetchInfo.endStr;
            if (currentScope !== 'all') { fetchUrl += '&scope=' + currentScope; }
            
            fetch(fetchUrl)
                .then(response => response.json())
                .then(data => {
                    const formattedEvents = data.map(event => ({
                        id: event.eventId,
                        title: event.title,
                        start: event.startAt,
                        end: event.endAt,
                        allDay: event.allDay,
                        color: event.scope === 'PERSONAL' ? '#007bff' : (event.scope === 'DEPARTMENT' ? '#28a745' : '#dc3545'),
                        borderColor: event.scope === 'PERSONAL' ? '#007bff' : (event.scope === 'DEPARTMENT' ? '#28a745' : '#dc3545')
                    }));
                    successCallback(formattedEvents);
                })
                .catch(error => failureCallback(error));
        },
        dateClick: function(info) {
            updateEventList(info.date, calendar.getEvents());
        },
        eventsSet: function(events) {
            updateEventList(new Date(), events);
        }
    });
    calendar.render();

    // "일정 등록" 버튼 (상단) 클릭 시 모달 표시
    document.getElementById('addEventBtn').addEventListener('click', function() {
        document.getElementById('eventForm').reset();
        selectedAttendees = []; // 선택된 참석자 초기화
        renderSelectedAttendees(); // UI 초기화
        document.getElementById('eventId').value = '';
        document.getElementById('eventModalLabel').textContent = '일정 등록';
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        document.getElementById('eventStart').value = now.toISOString().slice(0, 16);
        now.setHours(now.getHours() + 1);
        document.getElementById('eventEnd').value = now.toISOString().slice(0, 16);
        $('#eventModal').modal('show');
    });

    // "일정 등록" 메뉴 (사이드바) 클릭 시 모달 표시
    const sidebarAddBtn = document.getElementById('sidebar-add-event');
    if(sidebarAddBtn) {
        sidebarAddBtn.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('addEventBtn').click();
        });
    }

    // 사이드바 필터 링크 클릭 시 이벤트 처리
    document.querySelectorAll('.schedule-filter').forEach(filterLink => {
        filterLink.addEventListener('click', function(e) {
            e.preventDefault();
            currentScope = this.dataset.scope;
            document.querySelectorAll('.schedule-filter').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            calendar.refetchEvents();
        });
    });

    // 저장 버튼 클릭 시 이벤트 처리
    document.getElementById('saveEventBtn').addEventListener('click', function() {
        const attendeeIds = selectedAttendees.map(user => user.userId);
        const eventData = {
            eventId: document.getElementById('eventId').value || null,
            scope: document.getElementById('eventType').value,
            title: document.getElementById('eventTitle').value,
            startAt: document.getElementById('eventStart').value,
            endAt: document.getElementById('eventEnd').value,
            location: document.getElementById('eventLocation').value,
            description: document.getElementById('eventDescription').value,
            attendeeIds: attendeeIds, // 참석자 ID 목록 추가
            repeating: document.getElementById('eventRepeating').checked
        };

        const eventAttachmentsInput = document.getElementById('eventAttachments');
        const files = eventAttachmentsInput.files;

        const formData = new FormData();
        formData.append('event', JSON.stringify(eventData)); // 이벤트 데이터를 JSON 문자열로 추가

        // 파일이 있다면 FormData에 추가
        if (files.length > 0) {
            for (let i = 0; i < files.length; i++) {
                formData.append('files', files[i]);
            }
        }

        fetch('/schedules/events', {
            method: eventData.eventId ? 'PUT' : 'POST',
            body: formData, // FormData 객체 직접 전달
        })
        .then(response => {
            if (!response.ok) { return response.text().then(text => { throw new Error(text) }); }
            return response.json();
        })
        .then(data => {
            console.log('Success:', data);
            $('#eventModal').modal('hide');
            calendar.refetchEvents();
            alert('일정이 성공적으로 저장되었습니다!'); // 성공 알림
        })
        .catch((error) => {
            console.error('Error:', error);
            alert('일정 저장에 실패했습니다: ' + error.message);
        });
    });
});
