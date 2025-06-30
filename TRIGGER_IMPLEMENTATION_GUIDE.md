# 触发器功能实现指南

## 概述

本系统实现了自动用户创建功能，通过数据库触发器在添加新学生或教师时自动创建对应的登录账户。

## 功能特性

### 1. 自动用户创建
- **学生触发器**：添加学生时自动创建用户账户（用户名=学号，密码=Student@123）
- **教师触发器**：添加教师时自动创建用户账户（用户名=工号，密码=Teacher@123）

### 2. 用户管理功能
- 用户列表查看和筛选
- 密码重置功能
- 用户统计信息
- 触发器状态检查

## 数据库触发器

### 学生触发器
```sql
-- 删除已存在的触发器和函数
DROP TRIGGER IF EXISTS tr_Student_Insert ON huyl_student10;
DROP FUNCTION IF EXISTS trig_CreateStudentUser();

-- 创建学生触发器函数
CREATE OR REPLACE FUNCTION trig_CreateStudentUser()
    RETURNS TRIGGER AS $$
BEGIN
    -- 在 huyl_user10 表中为学生创建新账户
    INSERT INTO huyl_user10 (hyl_uname10, hyl_utype10, hyl_upassword10, hyl_ucreated10)
    VALUES (CAST(NEW.hyl_sno10 AS VARCHAR), 'student', 'Student@123', CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建学生触发器
CREATE TRIGGER tr_Student_Insert
    AFTER INSERT ON huyl_student10
    FOR EACH ROW
EXECUTE PROCEDURE trig_CreateStudentUser();
```

### 教师触发器
```sql
-- 删除已存在的触发器和函数
DROP TRIGGER IF EXISTS tr_Teacher_Insert ON huyl_teacher10;
DROP FUNCTION IF EXISTS trig_CreateTeacherUser();

-- 创建教师触发器函数
CREATE OR REPLACE FUNCTION trig_CreateTeacherUser()
    RETURNS TRIGGER AS $$
BEGIN
    -- 在huyl_user10表中创建新教师账户
    INSERT INTO huyl_user10 (hyl_uname10, hyl_utype10, hyl_upassword10, hyl_ucreated10)
    VALUES (CAST(NEW.hyl_tno10 AS VARCHAR), 'teacher', 'Teacher@123', CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建教师触发器
CREATE TRIGGER tr_Teacher_Insert
    AFTER INSERT ON huyl_teacher10
    FOR EACH ROW
EXECUTE PROCEDURE trig_CreateTeacherUser();
```

## Java代码修改

### 1. UserDAO.java
- 修改了所有SQL查询以使用新的字段名（hyl_前缀）
- 添加了新的方法：`getUserByUsername()`, `getAllUsers()`
- 更新了用户创建逻辑

### 2. UserService.java
- 添加了触发器状态检查方法
- 添加了用户统计功能
- 添加了密码重置功能

### 3. UserManagementController.java
- 新增用户管理控制器
- 提供用户列表、统计、触发器状态检查等功能
- 支持密码重置操作

### 4. StudentController.java & TeacherController.java
- 修改了添加学生/教师的逻辑
- 添加了成功提示信息，包含触发器创建的账户信息

## 前端页面

### 1. 用户管理页面 (`/admin/users`)
- 显示所有用户列表
- 支持按用户类型筛选
- 提供密码重置功能
- 显示触发器功能说明

### 2. 触发器状态页面 (`/admin/users/trigger-status`)
- 显示触发器运行状态
- 提供详细的功能说明
- 包含使用指南

### 3. 用户统计页面 (`/admin/users/stats`)
- 显示用户分布统计
- 实时更新统计数据
- 提供统计说明

### 4. 学生/教师列表页面
- 添加了触发器功能提示
- 显示添加成功的新用户信息
- 包含默认密码提醒

## 使用流程

### 添加学生流程
1. 管理员在"学生管理"页面添加新学生
2. 系统自动触发学生触发器
3. 自动创建用户账户（用户名=学号）
4. 默认密码设置为 Student@123
5. 显示成功提示信息
6. 学生可使用学号和默认密码登录

### 添加教师流程
1. 管理员在"教师管理"页面添加新教师
2. 系统自动触发教师触发器
3. 自动创建用户账户（用户名=工号）
4. 默认密码设置为 Teacher@123
5. 显示成功提示信息
6. 教师可使用工号和默认密码登录

## 安全注意事项

1. **默认密码**：所有新用户都使用默认密码，需要及时修改
2. **密码重置**：管理员可以在用户管理页面重置用户密码
3. **权限控制**：只有管理员可以访问用户管理功能
4. **触发器监控**：定期检查触发器状态确保功能正常

## 故障排除

### 触发器不工作
1. 检查数据库连接
2. 验证触发器是否正确创建
3. 查看数据库日志
4. 使用触发器状态检查功能

### 用户创建失败
1. 检查用户表结构
2. 验证字段名是否正确
3. 确认权限设置
4. 查看错误日志

## 扩展功能

### 可能的改进
1. 添加用户删除触发器
2. 实现密码加密存储
3. 添加用户状态管理
4. 实现批量用户导入
5. 添加用户登录日志

### 配置选项
- 可配置默认密码
- 可配置用户名生成规则
- 可配置触发器启用/禁用
- 可配置密码复杂度要求

## 测试建议

1. **功能测试**：添加学生/教师，验证用户账户创建
2. **权限测试**：验证不同角色的访问权限
3. **异常测试**：测试各种异常情况
4. **性能测试**：测试大量用户创建的性能
5. **安全测试**：验证密码重置功能的安全性

## 部署说明

1. 执行触发器SQL脚本
2. 部署更新后的Java代码
3. 更新前端页面
4. 测试功能是否正常
5. 配置管理员账户
6. 通知用户新功能

## 维护建议

1. 定期备份用户数据
2. 监控触发器性能
3. 定期检查用户账户状态
4. 更新默认密码策略
5. 记录功能使用情况 