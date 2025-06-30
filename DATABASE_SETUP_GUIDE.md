# 数据库设置指南 - OpenGauss版本

## 问题诊断和解决方案

如果您遇到"未知错误"，很可能是数据库连接或表结构问题。请按以下步骤进行诊断和修复：

## 步骤1: 检查数据库连接

### 1.1 验证数据库配置
检查 `src/main/resources/database.properties` 文件：
```properties
db.url=jdbc:postgresql://127.0.0.1:5432/postgres
db.username=yillin
db.password=Admin@123
```

确保：
- OpenGauss服务正在运行
- 数据库连接信息正确
- 用户名和密码有效

### 1.2 测试数据库连接
访问：`http://localhost:8080/demo111/sql/execute?script=test_connection`

## 步骤2: 执行数据库初始化脚本

### 2.1 执行基础数据库脚本
在OpenGauss中执行：
```sql
-- 连接到您的数据库
\c postgres

-- 执行基础数据库脚本
\i init_database.sql
```

### 2.2 执行用户表初始化脚本
在OpenGauss中执行：
```sql
-- 执行用户表初始化脚本
\i user_init.sql
```

或者通过Web界面执行：
访问：`http://localhost:8080/demo111/sql/execute?script=user_init`

## 步骤3: 验证数据库结构

### 3.1 检查表是否存在
```sql
-- 检查基础表
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name LIKE 'huyl_%';

-- 检查用户表
SELECT * FROM huyl_user10 LIMIT 5;
```

### 3.2 检查用户数据
```sql
-- 查看用户数量
SELECT user_type, COUNT(*) FROM huyl_user10 GROUP BY user_type;

-- 查看管理员用户
SELECT * FROM huyl_user10 WHERE user_type = 'admin';
```

## 步骤4: 运行系统测试

访问：`http://localhost:8080/demo111/test/database`

这将显示：
- 数据库连接状态
- 用户表是否存在
- 用户数据是否正确
- 基础表数据状态
- 用户登录功能测试

## 常见问题解决

### 问题1: 数据库连接失败
**症状**: 出现数据库连接异常
**解决方案**:
1. 检查OpenGauss服务是否启动
2. 验证连接URL、用户名和密码
3. 确保数据库端口(5432)可访问

### 问题2: 用户表不存在
**症状**: 登录时出现SQL异常
**解决方案**:
1. 执行 `user_init.sql` 脚本
2. 检查脚本是否成功执行
3. 验证表结构是否正确

### 问题3: 用户数据为空
**症状**: 无法登录，提示用户名或密码错误
**解决方案**:
1. 检查用户数据是否正确插入
2. 验证默认密码设置
3. 重新执行用户初始化脚本

### 问题4: 权限问题
**症状**: 访问被拒绝或重定向
**解决方案**:
1. 检查用户类型设置
2. 验证权限配置
3. 清除浏览器缓存和会话

## 手动SQL执行

如果Web界面无法正常工作，可以手动在OpenGauss中执行：

### 创建用户表
```sql
CREATE TABLE IF NOT EXISTS huyl_user10
(
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('admin', 'student', 'teacher')),
    real_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT '正常' CHECK (status IN ('正常', '禁用', '在读', '在职', '休学', '退学', '离职', '退休')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
```

### 插入管理员用户
```sql
INSERT INTO huyl_user10 (user_id, username, password, user_type, real_name, email, phone, status) VALUES
(100001, '100001', '100001', 'admin', '系统管理员', 'admin@university.edu', '13800000001', '正常');
```

### 插入学生用户
```sql
INSERT INTO huyl_user10 (user_id, username, password, user_type, real_name, email, phone, status)
SELECT 
    hyl_sno10,
    CAST(hyl_sno10 AS VARCHAR),
    CAST(hyl_sno10 AS VARCHAR),
    'student',
    hyl_sname10,
    hyl_semail10,
    hyl_sphone10,
    hyl_sstatus10
FROM huyl_student10
WHERE NOT EXISTS (SELECT 1 FROM huyl_user10 WHERE user_id = hyl_sno10);
```

### 插入教师用户
```sql
INSERT INTO huyl_user10 (user_id, username, password, user_type, real_name, email, phone, status)
SELECT 
    hyl_tno10,
    CAST(hyl_tno10 AS VARCHAR),
    CAST(hyl_tno10 AS VARCHAR),
    'teacher',
    hyl_tname10,
    hyl_temail10,
    hyl_tphone10,
    hyl_tstatus10
FROM huyl_teacher10
WHERE NOT EXISTS (SELECT 1 FROM huyl_user10 WHERE user_id = hyl_tno10);
```

## 验证步骤

1. **数据库连接**: 访问测试页面确认连接正常
2. **表结构**: 确认所有表都已创建
3. **用户数据**: 确认用户数据已正确插入
4. **登录功能**: 使用测试账号登录验证功能

## 测试账号

执行完初始化脚本后，可以使用以下账号测试：

```
管理员: 100001 / 100001
学生: 600001 / 600001  
教师: 700001 / 700001
```

## 联系支持

如果问题仍然存在，请：
1. 检查系统日志
2. 查看数据库错误日志
3. 确认所有依赖项已正确安装
4. 验证Java和Tomcat版本兼容性

---

**注意**: 在生产环境中，请确保：
- 使用强密码
- 定期备份数据库
- 配置适当的数据库权限
- 启用SSL连接 