package com.health.app.schedules;

/**
 * 일정 종류 (개인, 부서, 전사)
 * calendar_events 테이블의 scope 컬럼에 매핑
 */
public enum ScheduleType {
    PERSONAL("개인"),
    DEPARTMENT("부서"),
    COMPANY("전사");

    private final String displayName;

    ScheduleType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
