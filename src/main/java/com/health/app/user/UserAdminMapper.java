package com.health.app.user;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserAdminMapper {

    List<UserAdminDTO> selectUserList();
}
