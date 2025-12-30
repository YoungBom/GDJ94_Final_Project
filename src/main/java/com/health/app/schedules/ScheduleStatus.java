package com.health.app.schedules;

// 일정 상태 (예정, 완료, 취소)
// calendar_events 테이블의 status_code 컬럼에
 
public enum ScheduleStatus {
    SCHEDULED, // 예정됨
    COMPLETED, // 완료됨
    CANCELLED  // 취소됨
}
