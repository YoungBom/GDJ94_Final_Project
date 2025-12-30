package com.health.app.schedules;

/**
 * 일정 참석자의 상태 (대기, 수락, 거절)
 * schedule_attendees 테이블의 acceptance_status 컬럼에 매핑됩니다.
 */
public enum AttendanceStatus {
    PENDING,  // 대기
    ACCEPTED, // 수락
    DECLINED  // 거절
}
