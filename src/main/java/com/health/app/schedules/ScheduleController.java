package com.health.app.schedules;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus; // HttpStatus 임포트 추가
import org.springframework.http.ResponseEntity; // ResponseEntity 임포트 추가
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // PostMapping 임포트 추가
import org.springframework.web.bind.annotation.RequestBody; // RequestBody 임포트 추가
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/schedules")
public class ScheduleController {

    private final ScheduleService scheduleService;

    @Autowired
    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @GetMapping
    public String scheduleView(Model model) {
        model.addAttribute("pageTitle", "일정");
        return "schedules/view";
    }

    /**
     * FullCalendar에 표시할 일정 데이터를 JSON으로 반환하는 API 엔드포인트
     * @param start 조회 시작 날짜 (FullCalendar가 자동으로 전달)
     * @param end 조회 종료 날짜 (FullCalendar가 자동으로 전달)
     * @return 캘린더 이벤트 DTO 목록
     */
    @GetMapping("/events")
    @ResponseBody
    public List<CalendarEventDto> getEvents(
            @RequestParam String start,
            @RequestParam String end) {
        
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("end", end);
        
        // TODO: 로그인 기능 구현 후, 사용자 ID, 지점 ID, 부서 코드 등을 파라미터에 추가해야 함
        // params.put("ownerUserId", loggedInUserId);
        // params.put("branchId", loggedInUserBranchId);

        return scheduleService.getCalendarEvents(params);
    }

    /**
     * 새로운 일정 생성을 처리하는 API 엔드포인트
     * @param calendarEvent 생성할 일정 데이터
     * @return 생성된 일정 정보와 HTTP 상태 코드
     */
    @PostMapping("/events")
    public ResponseEntity<CalendarEventDto> createEvent(@RequestBody CalendarEventDto calendarEvent) {
        CalendarEventDto createdEvent = scheduleService.createCalendarEvent(calendarEvent);
        return new ResponseEntity<>(createdEvent, HttpStatus.CREATED);
    }
}
