package com.health.app.schedules.search;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface AttendeeSearchMapper {
    /**
     * 이름으로 사용자를 검색하고, 부서명을 포함하여 반환합니다.
     * @param name 검색할 사용자 이름
     * @return AttendeeSearchDto 리스트
     */
    List<AttendeeSearchDto> findByName(@Param("name") String name);

    /**
     * 주어진 ID 목록에 해당하는 사용자들을 검색하고, 부서명을 포함하여 반환합니다.
     * @param userIds 검색할 사용자 ID 목록
     * @return AttendeeSearchDto 리스트
     */
    List<AttendeeSearchDto> findUsersByIds(@Param("userIds") List<Long> userIds);
}
