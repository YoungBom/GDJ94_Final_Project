package com.health.app.schedules;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime; // LocalDateTime 임포트 추가
import com.health.app.schedules.ScheduleStatus; // ScheduleStatus 임포트 추가
import java.util.List;
import java.util.Map;

/**
 * 일정 관련 비즈니스 로직을 처리하는 서비스 클래스
 */
@Service
public class ScheduleService {

    private final CalendarEventMapper calendarEventMapper;
    private final ScheduleAttendeeMapper scheduleAttendeeMapper;

    @Autowired
    public ScheduleService(CalendarEventMapper calendarEventMapper, ScheduleAttendeeMapper scheduleAttendeeMapper) {
        this.calendarEventMapper = calendarEventMapper;
        this.scheduleAttendeeMapper = scheduleAttendeeMapper;
    }

    /**
     * 파라미터에 맞는 캘린더 이벤트 목록을 조회합니다.
     *
     * @param params 필터링을 위한 파라미터 맵
     * @return 캘린더 이벤트 DTO 목록
     */
    public List<CalendarEventDto> getCalendarEvents(Map<String, Object> params) {
        return calendarEventMapper.selectCalendarEvents(params);
    }
    
    /**
     * 새로운 캘린더 이벤트를 생성하고 저장합니다.
     *
     * @param calendarEvent 생성할 이벤트 데이터
     * @return 생성된 캘린더 이벤트 DTO (ID 포함)
     */
    public CalendarEventDto createCalendarEvent(CalendarEventDto calendarEvent) {
        // TODO: 로그인 기능 구현 후, 실제 로그인 사용자 ID로 변경
        if (calendarEvent.getCreateUser() == null) {
            calendarEvent.setCreateUser(1L); // 기본값 설정
        }
        calendarEvent.setCreateDate(LocalDateTime.now());
        calendarEvent.setUseYn(true); // 기본적으로 사용 활성화
        calendarEvent.setStatusCode(ScheduleStatus.SCHEDULED); // 기본 상태 설정

        // NOT NULL 필드에 대한 기본값 설정
        if (calendarEvent.getAllDay() == null) {
            calendarEvent.setAllDay(false);
        }
        if (calendarEvent.getRepeating() == null) {
            calendarEvent.setRepeating(false);
        }

        calendarEventMapper.insertCalendarEvent(calendarEvent);
        return calendarEvent; // MyBatis가 keyProperty를 통해 eventId를 주입하므로 반환 가능
    }
    
    // TODO: 일정 수정, 삭제, 참석자 관리 등 추가적인 비즈니스 로직 구현
}
