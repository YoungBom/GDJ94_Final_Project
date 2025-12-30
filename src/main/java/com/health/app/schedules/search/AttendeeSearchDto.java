package com.health.app.schedules.search;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AttendeeSearchDto {
    private Long userId;
    private String name;
    private String departmentName;
}
