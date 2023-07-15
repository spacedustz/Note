## **💡 Spring EL 접근 제어 표현식**

| **hasRole(String role)**                                     |
| ------------------------------------------------------------ |
| 보안의 주체(principal)가 지정된 역할을 가지고 있다면 true 리턴 파라미터의 값은 ROLE_로 시작해야하지만 DefaultWebSecurityExpressionHandler의 defaultRolePrefix를 수정하여 Customize 할 수 있다 |
| **hasAnyRole(String... roles)**                              |
| principal이 지정한 역할이 1개 이상이면 true 리턴, 문자열의 리스트를 ','로 구분하여 전달한다 |
| **hasAuthority(String authority)**                           |
| principal이 지정한 권한을 가지고 있으면 true 리턴, ex) hasAuthority('write') |
| **hasAnyAuthority(String... authorities)**                   |
| principal이 지정한 권한 중 1개라도 있으면 true리턴           |
| **principal**                                                |
| 현재 사용자를 나타내는 principal 객체에 직접 접근 가능       |
| **authentication**                                           |
| SecurityContext가 조회할 수 있는 Authentication 객체에 직접 접근 가능 |
| **permitAll**                                                |
| true로 처리한다                                              |
| **denyAll**                                                  |
| false로 처리한다                                             |
| **isAnonymous()**                                            |
| if (principal == Anonymous) return true                      |
| **isRememberMe()**                                           |
| if (principal == remember-me User인 경우) return true        |
| **isAuthenticated()**                                        |
| if (User=!익명) return true                                  |
| **isFullyAuthenticated()**                                   |
| if (User != remember-me \|\| User != Anonymous) return true  |
| **hasPermission(Object target, Object permission)**          |
| if (User.hasPermission(target)) return true, ex) hasPermission(APKObject, 'write') |
| **hasPermission(Object targetId, String targetType, Object permission)** |
| if (User.hasPermission(target)) return true, ex) hasPermission(5, 'com.test.request', 'write') |