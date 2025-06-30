-- 快速修复脚本 - 解决登录系统数据库问题 (OpenGauss兼容版本)
-- 请在OpenGauss中执行此脚本

-- 1. 删除已存在的用户表（如果存在）
DROP TABLE IF EXISTS huyl_user10 CASCADE;

-- 2. 创建用户表
CREATE TABLE huyl_user10
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

-- 3. 创建索引
CREATE INDEX idx_users_username ON huyl_user10(username);
CREATE INDEX idx_users_type ON huyl_user10(user_type);
CREATE INDEX idx_users_status ON huyl_user10(status);

-- 4. 插入管理员用户
INSERT INTO huyl_user10 (user_id, username, password, user_type, real_name, email, phone, status) VALUES
(100001, '100001', '100001', 'admin', '系统管理员', 'admin@university.edu', '13800000001', '正常'),
(100002, '100002', '100002', 'admin', '教务管理员', 'academic@university.edu', '13800000002', '正常'),
(100003, '100003', '100003', 'admin', '学生管理员', 'student_admin@university.edu', '13800000003', '正常');

-- 5. 插入学生用户（从现有学生数据创建）
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

-- 6. 插入教师用户（从现有教师数据创建）
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

-- 7. 验证数据插入
SELECT '用户总数:' as info, COUNT(*) as count FROM huyl_user10
UNION ALL
SELECT '管理员数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'admin'
UNION ALL
SELECT '学生用户数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'student'
UNION ALL
SELECT '教师用户数量:', COUNT(*) FROM huyl_user10 WHERE user_type = 'teacher';

-- 8. 显示测试账号信息
SELECT 
    user_type as "用户类型",
    username as "登录号码",
    password as "默认密码",
    real_name as "真实姓名",
    status as "状态"
FROM huyl_user10
ORDER BY user_type, user_id
LIMIT 10;

-- 9. 检查基础表是否存在
SELECT '基础表检查:' as info, '开始检查' as status
UNION ALL
SELECT '学生表:', CASE WHEN EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'huyl_student10') THEN '存在' ELSE '不存在' END
UNION ALL
SELECT '教师表:', CASE WHEN EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'huyl_teacher10') THEN '存在' ELSE '不存在' END
UNION ALL
SELECT '课程表:', CASE WHEN EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'huyl_course10') THEN '存在' ELSE '不存在' END
UNION ALL
SELECT '选课表:', CASE WHEN EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'huyl_enroll10') THEN '存在' ELSE '不存在' END; 