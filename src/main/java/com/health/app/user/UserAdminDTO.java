package com.health.app.user;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
public class UserAdminDTO {

    private Long userId;
    private String loginId;
    private String name;
    private String email;
    private String phone;

    private String roleCode;
    private String statusCode;

    private String branchName;
}
