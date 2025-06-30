-- 用户表初始化脚本 - OpenGauss兼容版本
-- 请按顺序执行此脚本以确保用户表和数据都正确创建

-- 0. 删除已存在的用户表（如果存在）
DROP TABLE IF EXISTS huyl_user10 CASCADE;

-- 1. 创建用户表
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

-- 2. 创建索引
CREATE INDEX IF NOT EXISTS idx_users_username ON huyl_user10(username);
CREATE INDEX IF NOT EXISTS idx_users_type ON huyl_user10(user_type);
CREATE INDEX IF NOT EXISTS idx_users_status ON huyl_user10(status);

-- 3. 插入管理员用户（默认密码与用户号码相同）
INSERT INTO huyl_user10 (user_id, username, password, user_type, real_name, email, phone, status) VALUES
(100001, '100001', '100001', 'admin', '系统管理员', 'admin@university.edu', '13800000001', '正常'),
(100002, '100002', '100002', 'admin', '教务管理员', 'academic@university.edu', '13800000002', '正常'),
(100003, '100003', '100003', 'admin', '学生管理员', 'student_admin@university.edu', '13800000003', '正常');

-- 4. 插入学生用户（从现有学生数据创建）
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

-- 5. 插入教师用户（从现有教师数据创建）
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

-- 6. 验证数据插入
SELECT '用户总数:' as info, COUNT(*) as count FROM huyl_user10
UNION ALL
SELECT '管理员数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'admin'
UNION ALL
SELECT '学生用户数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'student'
UNION ALL
SELECT '教师用户数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'teacher';

-- 7. 显示用户登录信息
SELECT 
    user_type as "用户类型",
    username as "登录号码",
    password as "默认密码",
    real_name as "真实姓名",
    status as "状态"
FROM huyl_user10
ORDER BY user_type, user_id
LIMIT 20;

-- 用户初始化脚本
-- 创建默认用户账户，密码根据用户类型设置

-- 清空现有用户数据（可选）
-- DELETE FROM huyl_user10;

-- 插入管理员用户
INSERT INTO huyl_user10 (hyl_username10, hyl_password10, hyl_usertype10, hyl_email10, hyl_phone10, hyl_created_at10) VALUES
('100001', 'Admin@123', 'admin', 'admin@university.edu.cn', '13800000001', CURRENT_TIMESTAMP),
('100002', 'Admin@123', 'admin', 'admin2@university.edu.cn', '13800000002', CURRENT_TIMESTAMP),
('100003', 'Admin@123', 'admin', 'admin3@university.edu.cn', '13800000003', CURRENT_TIMESTAMP);

-- 插入学生用户
INSERT INTO huyl_user10 (hyl_username10, hyl_password10, hyl_usertype10, hyl_email10, hyl_phone10, hyl_created_at10) VALUES
('600001', 'Student@123', 'student', 'student600001@university.edu.cn', '13900000001', CURRENT_TIMESTAMP),
('600002', 'Student@123', 'student', 'student600002@university.edu.cn', '13900000002', CURRENT_TIMESTAMP),
('600003', 'Student@123', 'student', 'student600003@university.edu.cn', '13900000003', CURRENT_TIMESTAMP),
('600004', 'Student@123', 'student', 'student600004@university.edu.cn', '13900000004', CURRENT_TIMESTAMP),
('600005', 'Student@123', 'student', 'student600005@university.edu.cn', '13900000005', CURRENT_TIMESTAMP),
('600006', 'Student@123', 'student', 'student600006@university.edu.cn', '13900000006', CURRENT_TIMESTAMP),
('600007', 'Student@123', 'student', 'student600007@university.edu.cn', '13900000007', CURRENT_TIMESTAMP),
('600008', 'Student@123', 'student', 'student600008@university.edu.cn', '13900000008', CURRENT_TIMESTAMP),
('600009', 'Student@123', 'student', 'student600009@university.edu.cn', '13900000009', CURRENT_TIMESTAMP),
('600010', 'Student@123', 'student', 'student600010@university.edu.cn', '13900000010', CURRENT_TIMESTAMP);

-- 插入教师用户
INSERT INTO huyl_user10 (hyl_username10, hyl_password10, hyl_usertype10, hyl_email10, hyl_phone10, hyl_created_at10) VALUES
('700001', 'Teacher@123', 'teacher', 'teacher700001@university.edu.cn', '13700000001', CURRENT_TIMESTAMP),
('700002', 'Teacher@123', 'teacher', 'teacher700002@university.edu.cn', '13700000002', CURRENT_TIMESTAMP),
('700003', 'Teacher@123', 'teacher', 'teacher700003@university.edu.cn', '13700000003', CURRENT_TIMESTAMP),
('700004', 'Teacher@123', 'teacher', 'teacher700004@university.edu.cn', '13700000004', CURRENT_TIMESTAMP),
('700005', 'Teacher@123', 'teacher', 'teacher700005@university.edu.cn', '13700000005', CURRENT_TIMESTAMP),
('700006', 'Teacher@123', 'teacher', 'teacher700006@university.edu.cn', '13700000006', CURRENT_TIMESTAMP),
('700007', 'Teacher@123', 'teacher', 'teacher700007@university.edu.cn', '13700000007', CURRENT_TIMESTAMP),
('700008', 'Teacher@123', 'teacher', 'teacher700008@university.edu.cn', '13700000008', CURRENT_TIMESTAMP),
('700009', 'Teacher@123', 'teacher', 'teacher700009@university.edu.cn', '13700000009', CURRENT_TIMESTAMP),
('700010', 'Teacher@123', 'teacher', 'teacher700010@university.edu.cn', '13700000010', CURRENT_TIMESTAMP);

-- 验证插入结果
SELECT 'Admin users:' as user_type, COUNT(*) as count FROM huyl_user10 WHERE hyl_usertype10 = 'admin'
UNION ALL
SELECT 'Student users:' as user_type, COUNT(*) as count FROM huyl_user10 WHERE hyl_usertype10 = 'student'
UNION ALL
SELECT 'Teacher users:' as user_type, COUNT(*) as count FROM huyl_user10 WHERE hyl_usertype10 = 'teacher'; 