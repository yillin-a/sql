-- 数据库初始化脚本
-- 请按顺序执行此脚本以确保所有表和数据都正确创建

-- 1. 删除已存在的序列和表(如果存在)
DROP SEQUENCE IF EXISTS user_seq CASCADE;
DROP SEQUENCE IF EXISTS major_seq CASCADE;
DROP SEQUENCE IF EXISTS administrative_class_seq CASCADE;
DROP SEQUENCE IF EXISTS course_seq CASCADE;
DROP SEQUENCE IF EXISTS teaching_class_seq CASCADE;
DROP SEQUENCE IF EXISTS student_seq CASCADE;
DROP SEQUENCE IF EXISTS teacher_seq CASCADE;
DROP SEQUENCE IF EXISTS faculty_seq CASCADE;
DROP SEQUENCE IF EXISTS cultivate_seq CASCADE;

-- 1.1 删除已存在的表(如果存在) - 按依赖关系顺序删除
DROP TABLE IF EXISTS huyl_cultivate10 CASCADE;
DROP TABLE IF EXISTS huyl_enroll10 CASCADE;
DROP TABLE IF EXISTS huyl_venue10 CASCADE;
DROP TABLE IF EXISTS huyl_tclass10 CASCADE;
DROP TABLE IF EXISTS huyl_student10 CASCADE;
DROP TABLE IF EXISTS huyl_aclass10 CASCADE;
DROP TABLE IF EXISTS huyl_course10 CASCADE;
DROP TABLE IF EXISTS huyl_teacher10 CASCADE;
DROP TABLE IF EXISTS huyl_major10 CASCADE;
DROP TABLE IF EXISTS huyl_faculty10 CASCADE;

-- 2. 创建序列
CREATE SEQUENCE user_seq START WITH 100001 INCREMENT BY 1;
CREATE SEQUENCE major_seq START WITH 200001 INCREMENT BY 1;
CREATE SEQUENCE administrative_class_seq START WITH 300001 INCREMENT BY 1;
CREATE SEQUENCE course_seq START WITH 400001 INCREMENT BY 1;
CREATE SEQUENCE teaching_class_seq START WITH 500001 INCREMENT BY 1;
CREATE SEQUENCE student_seq START WITH 600001 INCREMENT BY 1;
CREATE SEQUENCE teacher_seq START WITH 700001 INCREMENT BY 1;
CREATE SEQUENCE faculty_seq START WITH 800001 INCREMENT BY 1;
CREATE SEQUENCE cultivate_seq START WITH 900001 INCREMENT BY 1;

-- 3. 创建学院表
CREATE TABLE huyl_faculty10
(
    hyl_fno10 INT DEFAULT nextval('faculty_seq') PRIMARY KEY,
    hyl_fname10 VARCHAR(50) NOT NULL UNIQUE,
    hyl_fdesc10 TEXT,
    hyl_festablished10 DATE
);

-- 4. 创建专业表
CREATE TABLE huyl_major10
(
    hyl_mno10 INT DEFAULT nextval('major_seq') PRIMARY KEY,
    hyl_mname10 VARCHAR(50) NOT NULL,
    hyl_mdegree10 VARCHAR(20) CHECK (hyl_mdegree10 IN ('本科','硕士','博士')),
    hyl_myears10 INT DEFAULT 4 CHECK (hyl_myears10 > 0),
    hyl_fno10 INT NOT NULL,
    CONSTRAINT FK_major10_fno10 FOREIGN KEY (hyl_fno10) REFERENCES huyl_faculty10(hyl_fno10) ON DELETE CASCADE,
    UNIQUE(hyl_mname10, hyl_fno10)
);

-- 5. 创建教师表
CREATE TABLE huyl_teacher10
(
    hyl_tno10 INT DEFAULT nextval('teacher_seq') PRIMARY KEY,
    hyl_tage10 INT NOT NULL CHECK (hyl_tage10 >= 22 AND hyl_tage10 <= 70),
    hyl_tname10 VARCHAR(20) NOT NULL,
    hyl_tbirth10 DATE NOT NULL,
    hyl_ttitle10 VARCHAR(20) NOT NULL CHECK(hyl_ttitle10 IN ('教授', '副教授', '讲师', '助教', '无')),
    hyl_tsex10 VARCHAR(10) NOT NULL CHECK(hyl_tsex10 IN('男','女')),
    hyl_temail10 VARCHAR(100) UNIQUE,
    hyl_toffice10 VARCHAR(50),
    hyl_tphone10 VARCHAR(20) UNIQUE,
    hyl_tjoindate10 DATE DEFAULT CURRENT_DATE,
    hyl_tstatus10 VARCHAR(20) DEFAULT '在职' CHECK(hyl_tstatus10 IN ('在职','离职','退休')),
    hyl_fno10 INT,
    CONSTRAINT FK_teacher10_fno10 FOREIGN KEY (hyl_fno10) REFERENCES huyl_faculty10(hyl_fno10) ON DELETE SET NULL
);

-- 6. 创建课程表
CREATE TABLE huyl_course10
(
    hyl_cno10 INT DEFAULT nextval('course_seq') PRIMARY KEY,
    hyl_cname10 VARCHAR(50) NOT NULL,
    hyl_ccredit10 DECIMAL(3,1) NOT NULL CHECK (hyl_ccredit10 > 0),
    hyl_chour10 INT NOT NULL CHECK (hyl_chour10 > 0),
    hyl_ctest10 VARCHAR(20) NOT NULL CHECK (hyl_ctest10 IN('考试','考查')),
    hyl_ctype10 VARCHAR(20) NOT NULL CHECK (hyl_ctype10 IN('通识课','必修课','限选课','体育课','实践课')),
    hyl_cprereq10 TEXT,
    hyl_cdesc10 TEXT,
    hyl_cavgscore10 DECIMAL,
    UNIQUE(hyl_cname10, hyl_ctype10)
);

-- 7. 创建行政班表
CREATE TABLE huyl_aclass10
(
    hyl_acno10 INT DEFAULT nextval('administrative_class_seq') PRIMARY KEY,
    hyl_acname10 VARCHAR(50) NOT NULL,
    hyl_acyear10 INT NOT NULL CHECK (hyl_acyear10 >= 2020),
    hyl_acmaxstu10 INT DEFAULT 30 CHECK (hyl_acmaxstu10 > 0),
    hyl_mno10 INT NOT NULL,
    CONSTRAINT FK_aclass10_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,
    UNIQUE(hyl_acname10, hyl_mno10)
);

-- 8. 创建学生表
CREATE TABLE huyl_student10
(
    hyl_sno10 INT DEFAULT nextval('student_seq') PRIMARY KEY,
    hyl_sage10 INT NOT NULL CHECK (hyl_sage10 >= 16 AND hyl_sage10 <= 35),
    hyl_sname10 VARCHAR(20) NOT NULL,
    hyl_sbirth10 DATE NOT NULL,
    hyl_splace10 VARCHAR(50) NOT NULL,
    hyl_ssex10 VARCHAR(10) NOT NULL CHECK(hyl_ssex10 IN('男','女')),
    hyl_screditsum10 DECIMAL(5,1) NOT NULL DEFAULT 0 CHECK (hyl_screditsum10 >= 0),
    hyl_semail10 VARCHAR(100) UNIQUE,
    hyl_sphone10 VARCHAR(20) UNIQUE,
    hyl_senrolldate10 DATE DEFAULT CURRENT_DATE,
    hyl_sstatus10 VARCHAR(20) DEFAULT '在读' CHECK(hyl_sstatus10 IN ('在读','休学','退学','毕业')),
    hyl_sgpa10 DECIMAL(4,3) NOT NULL DEFAULT 0 CHECK (hyl_sgpa10 >= 0 AND hyl_sgpa10 <= 5),
    hyl_srank10 INT NOT NULL DEFAULT 0,
    hyl_mno10 INT NOT NULL,
    CONSTRAINT FK_student10_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,
    hyl_acno10 INT NOT NULL,
    CONSTRAINT FK_student10_acno10 FOREIGN KEY (hyl_acno10) REFERENCES huyl_aclass10(hyl_acno10) ON DELETE CASCADE
);

-- 9. 创建教学班表
CREATE TABLE huyl_tclass10
(
    hyl_tcno10 INT DEFAULT nextval('teaching_class_seq') PRIMARY KEY,
    hyl_tcname10 VARCHAR(50) NOT NULL,
    hyl_tcyear10 INT NOT NULL CHECK (hyl_tcyear10 >= 2020),
    hyl_tcterm10 INT NOT NULL CHECK (hyl_tcterm10 IN (1,2,3)),
    hyl_tcrepeat10 VARCHAR(20) NOT NULL CHECK(hyl_tcrepeat10 IN ('重修班','非重修班')),
    hyl_tcbatch10 VARCHAR(10) NOT NULL DEFAULT '01',
    hyl_tcmaxstu10 INT DEFAULT 50 CHECK (hyl_tcmaxstu10 > 0),
    hyl_tccurstu10 INT DEFAULT 0 CHECK (hyl_tccurstu10 >= 0),
    hyl_cno10 INT NOT NULL,
    CONSTRAINT FK_tclass10_cno10 FOREIGN KEY (hyl_cno10) REFERENCES huyl_course10(hyl_cno10) ON DELETE CASCADE,
    hyl_tno10 INT NOT NULL,
    CONSTRAINT FK_tclass10_tno10 FOREIGN KEY (hyl_tno10) REFERENCES huyl_teacher10(hyl_tno10) ON DELETE CASCADE,
    UNIQUE(hyl_cno10, hyl_tcyear10, hyl_tcterm10, hyl_tcbatch10)
);

-- 10. 创建上课时间地点表
CREATE TABLE huyl_venue10
(
    hyl_vid10 SERIAL PRIMARY KEY,
    hyl_tplace10 VARCHAR(50) NOT NULL,
    hyl_tstime10 TIME NOT NULL,
    hyl_tetime10 TIME NOT NULL,
    hyl_tweekday10 INT NOT NULL CHECK (hyl_tweekday10 BETWEEN 1 AND 7),
    hyl_tweeks10 VARCHAR(100),
    hyl_tcno10 INT NOT NULL,
    CONSTRAINT FK_venue10_tcno10 FOREIGN KEY (hyl_tcno10) REFERENCES huyl_tclass10(hyl_tcno10) ON DELETE CASCADE,
    UNIQUE(hyl_tplace10, hyl_tstime10, hyl_tetime10, hyl_tweekday10)
);

-- 11. 创建选课表
CREATE TABLE huyl_enroll10
(
    hyl_escore10 INT CHECK (hyl_escore10 >= 0 AND hyl_escore10 <= 100),
    hyl_egpa10 DECIMAL(2,1) CHECK (hyl_egpa10 >= 0 AND hyl_egpa10 <= 5.0),
    hyl_open10 BOOLEAN NOT NULL DEFAULT true,
    hyl_enrolldate10 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hyl_status10 VARCHAR(20) DEFAULT '正常' CHECK(hyl_status10 IN ('正常','退课','重修')),
    hyl_tcno10 INT NOT NULL,
    CONSTRAINT FK_enroll10_tcno10 FOREIGN KEY (hyl_tcno10) REFERENCES huyl_tclass10(hyl_tcno10) ON DELETE CASCADE,
    hyl_sno10 INT NOT NULL,
    CONSTRAINT FK_enroll10_sno10 FOREIGN KEY (hyl_sno10) REFERENCES huyl_student10(hyl_sno10) ON DELETE CASCADE,
    PRIMARY KEY (hyl_sno10, hyl_tcno10)
);

-- 12. 创建培养方案表
CREATE TABLE huyl_cultivate10
(
    hyl_cid10 INT DEFAULT nextval('cultivate_seq') PRIMARY KEY,
    hyl_mno10 INT NOT NULL,
    hyl_cno10 INT NOT NULL,
    hyl_cterm10 INT CHECK (hyl_cterm10 BETWEEN 1 AND 8),
    hyl_cmandatory10 BOOLEAN DEFAULT true,
    CONSTRAINT FK_cultivate_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,
    CONSTRAINT FK_cultivate_cno10 FOREIGN KEY (hyl_cno10) REFERENCES huyl_course10(hyl_cno10) ON DELETE CASCADE,
    UNIQUE(hyl_mno10, hyl_cno10)
);

-- 13. 插入测试数据

-- 插入学院数据
INSERT INTO huyl_faculty10 (hyl_fno10, hyl_fname10, hyl_fdesc10, hyl_festablished10) VALUES
(800001, '计算机学院', '培养计算机科学与技术专业人才', '2000-09-01'),
(800002, '数学学院', '培养数学与应用数学专业人才', '1995-09-01'),
(800003, '物理学院', '培养物理学专业人才', '1998-09-01'),
(800004, '化学学院', '培养化学专业人才', '1996-09-01'),
(800005, '文学院', '培养汉语言文学专业人才', '1990-09-01');

-- 插入专业数据
INSERT INTO huyl_major10 (hyl_mno10, hyl_mname10, hyl_mdegree10, hyl_myears10, hyl_fno10) VALUES
(200001, '计算机科学与技术', '本科', 4, 800001),
(200002, '软件工程', '本科', 4, 800001),
(200003, '数学与应用数学', '本科', 4, 800002),
(200004, '物理学', '本科', 4, 800003),
(200005, '化学', '本科', 4, 800004),
(200006, '汉语言文学', '本科', 4, 800005);

-- 插入教师数据
INSERT INTO huyl_teacher10 (hyl_tno10, hyl_tage10, hyl_tname10, hyl_tbirth10, hyl_ttitle10, hyl_tsex10, hyl_temail10, hyl_toffice10, hyl_tphone10, hyl_fno10) VALUES
(700001, 45, '张教授', '1978-05-15', '教授', '男', 'zhang@university.edu', 'A楼301室', '13800138001', 800001),
(700002, 38, '李副教授', '1985-03-20', '副教授', '女', 'li@university.edu', 'A楼302室', '13800138002', 800001),
(700003, 32, '王讲师', '1991-08-10', '讲师', '男', 'wang@university.edu', 'A楼303室', '13800138003', 800002),
(700004, 28, '陈助教', '1995-12-25', '助教', '女', 'chen@university.edu', 'A楼304室', '13800138004', 800002);

-- 插入行政班数据
INSERT INTO huyl_aclass10 (hyl_acno10, hyl_acname10, hyl_acyear10, hyl_acmaxstu10, hyl_mno10) VALUES
(300001, '计算机科学与技术2024级1班', 2024, 30, 200001),
(300002, '计算机科学与技术2024级2班', 2024, 30, 200001),
(300003, '软件工程2024级1班', 2024, 30, 200002),
(300004, '数学与应用数学2024级1班', 2024, 30, 200003),
(300005, '物理学2024级1班', 2024, 30, 200004),
(300006, '化学2024级1班', 2024, 30, 200005),
(300007, '汉语言文学2024级1班', 2024, 30, 200006);

-- 插入学生数据
INSERT INTO huyl_student10 (hyl_sno10, hyl_sage10, hyl_sname10, hyl_sbirth10, hyl_splace10, hyl_ssex10, hyl_screditsum10, hyl_semail10, hyl_sphone10, hyl_sstatus10, hyl_sgpa10, hyl_srank10, hyl_mno10, hyl_acno10) VALUES
(600001, 20, '张三', '2004-03-15', '北京市', '男', 0.0, 'zhangsan@student.edu', '13900139001', '在读', 0.000, 0, 200001, 300001),
(600002, 19, '李四', '2005-07-22', '上海市', '女', 0.0, 'lisi@student.edu', '13900139002', '在读', 0.000, 0, 200001, 300001),
(600003, 20, '王五', '2004-11-08', '广州市', '男', 0.0, 'wangwu@student.edu', '13900139003', '在读', 0.000, 0, 200002, 300003),
(600004, 19, '赵六', '2005-01-30', '深圳市', '女', 0.0, 'zhaoliu@student.edu', '13900139004', '在读', 0.000, 0, 200003, 300004),
(600005, 20, '孙七', '2004-09-12', '杭州市', '男', 0.0, 'sunqi@student.edu', '13900139005', '在读', 0.000, 0, 200004, 300005);

-- 插入课程数据
INSERT INTO huyl_course10 (hyl_cno10, hyl_cname10, hyl_ccredit10, hyl_chour10, hyl_ctest10, hyl_ctype10, hyl_cprereq10, hyl_cdesc10) VALUES
(400001, '高等数学', 4.0, 64, '考试', '必修课', NULL, '大学数学基础课程'),
(400002, '线性代数', 3.0, 48, '考试', '必修课', NULL, '线性代数基础课程'),
(400003, '程序设计基础', 4.0, 64, '考试', '必修课', NULL, '计算机编程入门课程'),
(400004, '数据结构', 4.0, 64, '考试', '必修课', '程序设计基础', '数据结构与算法课程'),
(400005, '数据库原理', 3.0, 48, '考试', '必修课', '程序设计基础', '数据库系统原理课程'),
(400006, '计算机网络', 3.0, 48, '考试', '必修课', '程序设计基础', '计算机网络基础课程'),
(400007, '大学英语', 4.0, 64, '考试', '通识课', NULL, '大学英语基础课程'),
(400008, '马克思主义基本原理', 3.0, 48, '考查', '通识课', NULL, '思想政治理论课程');

-- 插入教学班数据
INSERT INTO huyl_tclass10 (hyl_tcno10, hyl_tcname10, hyl_tcyear10, hyl_tcterm10, hyl_tcrepeat10, hyl_tcbatch10, hyl_tcmaxstu10, hyl_tccurstu10, hyl_cno10, hyl_tno10) VALUES
(500001, '高等数学A班', 2024, 1, '非重修班', '01', 50, 0, 400001, 700003),
(500002, '线性代数A班', 2024, 1, '非重修班', '01', 50, 0, 400002, 700004),
(500003, '程序设计基础A班', 2024, 1, '非重修班', '01', 50, 0, 400003, 700001),
(500004, '数据结构A班', 2024, 2, '非重修班', '01', 50, 0, 400004, 700002),
(500005, '数据库原理A班', 2024, 2, '非重修班', '01', 50, 0, 400005, 700001),
(500006, '计算机网络A班', 2024, 2, '非重修班', '01', 50, 0, 400006, 700002),
(500007, '大学英语A班', 2024, 1, '非重修班', '01', 50, 0, 400007, 700003),
(500008, '马克思主义基本原理A班', 2024, 1, '非重修班', '01', 50, 0, 400008, 700004);

-- 插入选课数据
INSERT INTO huyl_enroll10 (hyl_escore10, hyl_egpa10, hyl_open10, hyl_status10, hyl_tcno10, hyl_sno10) VALUES
(85, 4.0, true, '正常', 500001, 600001),
(92, 4.5, true, '正常', 500002, 600001),
(78, 3.5, true, '正常', 500003, 600001),
(88, 4.2, true, '正常', 500001, 600002),
(95, 4.8, true, '正常', 500002, 600002),
(82, 3.8, true, '正常', 500003, 600002),
(90, 4.3, true, '正常', 500001, 600003),
(87, 4.1, true, '正常', 500002, 600003),
(76, 3.4, true, '正常', 500003, 600003),
(93, 4.6, true, '正常', 500001, 600004),
(89, 4.2, true, '正常', 500002, 600004),
(84, 3.9, true, '正常', 500003, 600004),
(91, 4.4, true, '正常', 500001, 600005),
(86, 4.0, true, '正常', 500002, 600005),
(79, 3.6, true, '正常', 500003, 600005);

-- 14. 创建索引
CREATE INDEX idx_student_aclass ON huyl_student10(hyl_acno10);
CREATE INDEX idx_student_major ON huyl_student10(hyl_mno10);
CREATE INDEX idx_student_status ON huyl_student10(hyl_sstatus10);
CREATE INDEX idx_tclass_course ON huyl_tclass10(hyl_cno10);
CREATE INDEX idx_tclass_teacher ON huyl_tclass10(hyl_tno10);
CREATE INDEX idx_enroll_student ON huyl_enroll10(hyl_sno10);
CREATE INDEX idx_enroll_tclass ON huyl_enroll10(hyl_tcno10);

-- 15. 验证数据插入
SELECT '学院数量:' as info, COUNT(*) as count FROM huyl_faculty10
UNION ALL
SELECT '专业数量:', COUNT(*) FROM huyl_major10
UNION ALL
SELECT '教师数量:', COUNT(*) FROM huyl_teacher10
UNION ALL
SELECT '学生数量:', COUNT(*) FROM huyl_student10
UNION ALL
SELECT '课程数量:', COUNT(*) FROM huyl_course10
UNION ALL
SELECT '教学班数量:', COUNT(*) FROM huyl_tclass10
UNION ALL
SELECT '选课记录数量:', COUNT(*) FROM huyl_enroll10; 