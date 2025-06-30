# 密码修改功能实现指南

## 功能概述

为教务管理系统的三种用户类型（管理员、学生、教师）添加了密码修改功能，用户可以在登录后修改自己的登录密码。

## 功能特性

### 1. 安全性验证
- 需要验证当前密码
- 新密码格式验证（至少6位，包含字母和数字）
- 密码确认匹配验证
- 修改成功后自动登出，要求重新登录

### 2. 用户体验
- 实时密码强度检测
- 密码显示/隐藏切换
- 友好的错误提示
- 响应式设计，支持移动端

### 3. 密码要求
- 至少6位字符
- 必须包含字母和数字
- 建议使用大小写字母、数字和特殊字符的组合

## 技术实现

### 1. 后端实现

#### UserService 新增方法
```java
// 验证当前密码
public boolean verifyCurrentPassword(int userId, String currentPassword)

// 修改用户密码
public boolean changePassword(int userId, String currentPassword, String newPassword)

// 验证密码格式
public boolean isValidPassword(String password)

// 获取密码强度提示
public String getPasswordStrengthHint()
```

#### PasswordController
- 处理密码修改请求
- 验证用户登录状态
- 根据用户类型跳转到对应页面
- 处理密码修改逻辑

### 2. 前端实现

#### 页面文件
- `admin/change-password.jsp` - 管理员密码修改页面
- `student/change-password.jsp` - 学生密码修改页面  
- `teacher/change-password.jsp` - 教师密码修改页面

#### 功能特性
- 密码强度实时检测
- 密码匹配验证
- 表单验证
- 响应式设计

### 3. 导航集成

#### 管理员界面
- 在用户管理侧边栏添加"修改密码"链接

#### 学生界面
- 在导航菜单添加"修改密码"链接

#### 教师界面
- 在快速操作区域添加"修改密码"按钮

## 使用流程

### 1. 访问密码修改页面
用户登录后，通过以下方式访问密码修改页面：
- 管理员：用户管理 → 修改密码
- 学生：导航菜单 → 修改密码
- 教师：快速操作 → 修改密码

### 2. 修改密码步骤
1. 输入当前密码
2. 输入新密码（系统会实时显示密码强度）
3. 确认新密码（系统会验证密码匹配）
4. 点击"修改密码"按钮
5. 系统验证并处理修改请求

### 3. 修改结果
- 成功：显示成功消息，自动跳转到登录页面
- 失败：显示错误信息，停留在当前页面

## 安全考虑

### 1. 密码验证
- 验证当前密码正确性
- 新密码不能与当前密码相同
- 密码格式符合安全要求

### 2. 会话管理
- 修改成功后自动清除会话
- 要求用户重新登录
- 防止会话劫持

### 3. 输入验证
- 前端和后端双重验证
- 防止XSS攻击
- 防止SQL注入

## 文件修改清单

### 新增文件
1. `src/main/java/org/example/demo111/controller/PasswordController.java`
2. `src/main/webapp/WEB-INF/views/admin/change-password.jsp`
3. `src/main/webapp/WEB-INF/views/student/change-password.jsp`
4. `src/main/webapp/WEB-INF/views/teacher/change-password.jsp`
5. `PASSWORD_CHANGE_GUIDE.md`

### 修改文件
1. `src/main/java/org/example/demo111/service/UserService.java` - 添加密码修改相关方法
2. `src/main/webapp/WEB-INF/views/admin/user-management.jsp` - 添加修改密码链接
3. `src/main/webapp/WEB-INF/views/student/dashboard.jsp` - 添加修改密码链接
4. `src/main/webapp/WEB-INF/views/teacher/dashboard.jsp` - 添加修改密码链接
5. `src/main/webapp/WEB-INF/views/login.jsp` - 添加密码修改成功提示

## 测试建议

### 1. 功能测试
- 验证当前密码错误时的处理
- 验证新密码格式不符合要求时的处理
- 验证密码确认不匹配时的处理
- 验证修改成功后的跳转

### 2. 安全测试
- 测试未登录用户访问密码修改页面
- 测试跨用户修改密码
- 测试SQL注入防护
- 测试XSS防护

### 3. 用户体验测试
- 测试密码强度检测功能
- 测试密码显示/隐藏功能
- 测试响应式设计
- 测试错误提示信息

## 部署说明

1. 确保所有文件已正确部署到服务器
2. 重启应用服务器
3. 测试各用户类型的密码修改功能
4. 验证导航链接正常工作

## 注意事项

1. 密码修改功能需要用户已登录
2. 修改成功后会自动登出，需要重新登录
3. 密码格式要求严格，需要告知用户
4. 建议定期提醒用户修改默认密码 