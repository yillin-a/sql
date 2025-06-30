# 数据库设置指南

## 问题诊断

如果你遇到"学生表好像未创建成功，查询不到学生信息"的问题，请按照以下步骤进行诊断和解决。

## 步骤1：检查数据库连接

1. 启动你的Web应用
2. 访问：`http://localhost:8080/demo111/test/database`
3. 查看数据库连接测试结果

## 步骤2：执行数据库初始化脚本

### 方法1：使用简化初始化脚本（推荐）

1. 打开PostgreSQL客户端（如pgAdmin、psql等）
2. 连接到你的数据库：`postgres`
3. 执行以下SQL脚本：

```sql
-- 复制并执行 src/main/resources/init_database.sql 的内容
```

### 方法2：使用原始完整脚本

1. 打开PostgreSQL客户端
2. 连接到你的数据库：`postgres`
3. 执行以下SQL脚本：

```sql
-- 复制并执行 code1.sql 的内容
```

## 步骤3：验证数据

执行以下SQL查询来验证数据是否正确插入：

```sql
-- 检查学生数据
SELECT COUNT(*) as student_count FROM huyl_student10;

-- 检查教师数据
SELECT COUNT(*) as teacher_count FROM huyl_teacher10;

-- 检查课程数据
SELECT COUNT(*) as course_count FROM huyl_course10;

-- 查看学生列表
SELECT hyl_sno10, hyl_sname10, hyl_ssex10, hyl_sage10, hyl_sstatus10 
FROM huyl_student10;
```

## 步骤4：常见问题解决

### 问题1：表不存在
**错误信息**：`relation "huyl_student10" does not exist`

**解决方案**：
1. 确保执行了完整的初始化脚本
2. 检查数据库用户权限
3. 确保在正确的数据库中执行脚本

### 问题2：数据为空
**错误信息**：表存在但没有数据

**解决方案**：
1. 重新执行数据插入部分
2. 检查外键约束是否阻止了数据插入
3. 按正确顺序执行：学院 → 专业 → 教师 → 行政班 → 学生 → 课程 → 教学班 → 选课

### 问题3：外键约束错误
**错误信息**：`insert or update on table "huyl_student10" violates foreign key constraint`

**解决方案**：
1. 确保先插入了学院数据
2. 确保先插入了专业数据
3. 确保先插入了行政班数据
4. 检查外键ID是否匹配

## 步骤5：手动插入测试数据

如果自动脚本失败，可以手动执行以下SQL：

```sql
-- 1. 插入学院
INSERT INTO huyl_faculty10 (hyl_fno10, hyl_fname10, hyl_fdesc10, hyl_festablished10) VALUES
(800001, '计算机学院', '培养计算机科学与技术专业人才', '2000-09-01');

-- 2. 插入专业
INSERT INTO huyl_major10 (hyl_mno10, hyl_mname10, hyl_mdegree10, hyl_myears10, hyl_fno10) VALUES
(200001, '计算机科学与技术', '本科', 4, 800001);

-- 3. 插入行政班
INSERT INTO huyl_aclass10 (hyl_acno10, hyl_acname10, hyl_acyear10, hyl_acmaxstu10, hyl_mno10) VALUES
(300001, '计算机科学与技术2024级1班', 2024, 30, 200001);

-- 4. 插入学生
INSERT INTO huyl_student10 (hyl_sno10, hyl_sage10, hyl_sname10, hyl_sbirth10, hyl_splace10, hyl_ssex10, hyl_screditsum10, hyl_semail10, hyl_sphone10, hyl_sstatus10, hyl_sgpa10, hyl_srank10, hyl_mno10, hyl_acno10) VALUES
(600001, 20, '张三', '2004-03-15', '北京市', '男', 0.0, 'zhangsan@student.edu', '13900139001', '在读', 0.000, 0, 200001, 300001);
```

## 步骤6：验证应用功能

1. 访问：`http://localhost:8080/demo111/`
2. 点击"学生列表"或"教师列表"
3. 确认能看到数据

## 数据库配置信息

- **数据库类型**：PostgreSQL
- **主机**：127.0.0.1
- **端口**：5432
- **数据库名**：postgres
- **用户名**：yillin
- **密码**：Admin@123

## 联系支持

如果按照以上步骤仍然无法解决问题，请：

1. 检查PostgreSQL服务是否正常运行
2. 确认数据库用户权限
3. 查看应用日志中的错误信息
4. 使用数据库连接测试页面诊断问题 