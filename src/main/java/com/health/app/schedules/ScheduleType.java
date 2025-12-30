package com.health.app.schedules;

/**
 * 일정 종류 (개인, 부서, 전사)
 * calendar_events 테이블의 scope 컬럼에 매핑
 */
public enum ScheduleType {
    PERSONAL,
    DEPARTMENT,
    COMPANY
}
