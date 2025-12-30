package com.health.app.schedules;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;


// schedule_attendees 테이블에 매핑되는 DTO 클래스
 
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScheduleAttendeeDto {
    private Long attendeeId;
    private Long eventId;
    private Long userId;
    private AttendanceStatus acceptanceStatus;

    private Long createUser;
    private LocalDateTime createDate;
    private Long updateUser;
    private LocalDateTime updateDate;
    private Boolean useYn;
}
