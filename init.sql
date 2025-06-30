-- ================== 1. 删除所有对象（按依赖顺序） ==================
-- 1.1 删除视图
DROP VIEW IF EXISTS v_teacher_student_scores CASCADE;
DROP VIEW IF EXISTS v_student_scores CASCADE;
DROP VIEW IF EXISTS v_student_yearly_scores CASCADE;
DROP VIEW IF EXISTS v_course_avg_scores CASCADE;
DROP VIEW IF EXISTS v_student_courses CASCADE;
DROP VIEW IF EXISTS v_teacher_courses CASCADE;
DROP VIEW IF EXISTS v_class_courses CASCADE;
DROP VIEW IF EXISTS v_student_name_search CASCADE;
DROP VIEW IF EXISTS v_course_name_search CASCADE;
DROP VIEW IF EXISTS v_teacher_name_search CASCADE;
DROP VIEW IF EXISTS v_student_score_search CASCADE;
DROP VIEW IF EXISTS v_course_dropdown CASCADE;
DROP VIEW IF EXISTS v_student_dropdown CASCADE;
DROP VIEW IF EXISTS v_teacher_dropdown CASCADE;
DROP VIEW IF EXISTS v_class_dropdown CASCADE;
DROP VIEW IF EXISTS v_major_dropdown CASCADE;
DROP VIEW IF EXISTS v_student_search_with_weight CASCADE;
DROP VIEW IF EXISTS v_course_auto_complete CASCADE;
DROP VIEW IF EXISTS v_student_auto_complete CASCADE;
DROP VIEW IF EXISTS v_student_region_scores CASCADE;

-- 1.2 删除触发器和函数
DROP TRIGGER IF EXISTS tr_update_student_credits ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_update_tclass_count ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_update_student_graduation_status ON huyl_enroll10;
DROP TRIGGER IF EXISTS trg_check_course_conflict ON huyl_enroll10;
DROP TRIGGER IF EXISTS trg_check_course_conflict_update ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_delete_teacher_classes ON huyl_teacher10;
DROP TRIGGER IF EXISTS tr_update_course_avg_score ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_update_course_enrollment_count ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_update_student_gpa ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_update_student_major_rank ON huyl_student10;
DROP TRIGGER IF EXISTS tr_generate_student_password ON huyl_user10;
DROP TRIGGER IF EXISTS tr_cascade_delete_student ON huyl_student10;
DROP TRIGGER IF EXISTS tr_update_course_rank ON huyl_enroll10;
DROP TRIGGER IF EXISTS tr_calculate_total_credits_for_term ON huyl_enroll10;

--DROP FUNCTION IF EXISTS check_student_major_consistency() CASCADE;
-- DROP FUNCTION IF EXISTS update_student_credits CASCADE;
-- DROP FUNCTION IF EXISTS update_tclass_student_count CASCADE;
-- DROP FUNCTION IF EXISTS update_student_status_on_graduation CASCADE;
-- DROP FUNCTION IF EXISTS check_course_schedule_conflict CASCADE;
-- DROP FUNCTION IF EXISTS delete_teacher_related_classes CASCADE;
-- DROP FUNCTION IF EXISTS update_course_avg_score CASCADE;
-- DROP FUNCTION IF EXISTS update_course_enrollment_count CASCADE;
-- DROP FUNCTION IF EXISTS update_student_gpa CASCADE;
-- DROP FUNCTION IF EXISTS update_single_student_major_rank CASCADE;
-- DROP FUNCTION IF EXISTS update_major_all_students_rank CASCADE;
-- DROP FUNCTION IF EXISTS recalculate_all_major_ranks CASCADE;
-- DROP FUNCTION IF EXISTS update_course_rank CASCADE;
-- DROP FUNCTION IF EXISTS calculate_total_credits_for_term CASCADE;
-- DROP FUNCTION IF EXISTS generate_student_password CASCADE;
-- DROP FUNCTION IF EXISTS cascade_delete_student CASCADE;

-- 1.3 删除表
DROP TABLE IF EXISTS huyl_enroll10 CASCADE;
DROP TABLE IF EXISTS huyl_student10 CASCADE;
DROP TABLE IF EXISTS huyl_teacher10 CASCADE;
DROP TABLE IF EXISTS huyl_tclass10 CASCADE;
DROP TABLE IF EXISTS huyl_course10 CASCADE;
DROP TABLE IF EXISTS huyl_aclass10 CASCADE;
DROP TABLE IF EXISTS huyl_major10 CASCADE;
DROP TABLE IF EXISTS huyl_faculty10 CASCADE;
DROP TABLE IF EXISTS huyl_user10 CASCADE;
DROP TABLE IF EXISTS huyl_venue10 CASCADE;
DROP TABLE IF EXISTS huyl_cultivate10 CASCADE;

-- 1.4 删除序列
DROP SEQUENCE IF EXISTS user_seq CASCADE;
DROP SEQUENCE IF EXISTS major_seq CASCADE;
DROP SEQUENCE IF EXISTS administrative_class_seq CASCADE;
DROP SEQUENCE IF EXISTS course_seq CASCADE;
DROP SEQUENCE IF EXISTS teaching_class_seq CASCADE;
DROP SEQUENCE IF EXISTS student_seq CASCADE;
DROP SEQUENCE IF EXISTS teacher_seq CASCADE;
DROP SEQUENCE IF EXISTS faculty_seq CASCADE;
DROP SEQUENCE IF EXISTS cultivate_seq CASCADE;

-- ================== 2. 创建序列、表、索引、视图、函数、触发器 ==================
--用户
CREATE SEQUENCE user_seq START WITH 100001 INCREMENT BY 1;
--专业
CREATE SEQUENCE major_seq START WITH 200001 INCREMENT BY 1;
--行政班ac
CREATE SEQUENCE administrative_class_seq START WITH 300001 INCREMENT BY 1;
--课程
CREATE SEQUENCE course_seq START WITH 400001 INCREMENT BY 1;
--教学班tc
CREATE SEQUENCE teaching_class_seq START WITH 500001 INCREMENT BY 1;
--学生
CREATE SEQUENCE student_seq START WITH 600001 INCREMENT BY 1;
--老师
CREATE SEQUENCE teacher_seq START WITH 700001 INCREMENT BY 1;
--学院
CREATE SEQUENCE faculty_seq START WITH 800001 INCREMENT BY 1;
--培养方案
CREATE SEQUENCE cultivate_seq START WITH 900001 INCREMENT BY 1;

-- 用户表
CREATE TABLE huyl_user10
(
    hyl_uno10 INT PRIMARY KEY, -- 直接用学号/工号
    hyl_uname10 VARCHAR(20) NOT NULL UNIQUE,
    hyl_utype10 VARCHAR(20) NOT NULL CHECK (hyl_utype10 IN ('student','teacher','admin')),
    hyl_upassword10 VARCHAR(128) NOT NULL,
    hyl_ucreated10 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hyl_ulast_login10 TIMESTAMP
);

-- 学院表
CREATE TABLE huyl_faculty10
(
    hyl_fno10 INT DEFAULT nextval('faculty_seq') PRIMARY KEY,
    hyl_fname10 VARCHAR(50) NOT NULL UNIQUE,
    hyl_fdesc10 TEXT, -- 学院描述
    hyl_festablished10 DATE -- 建院时间
);

-- 专业表
CREATE TABLE huyl_major10
(
    hyl_mno10 INT DEFAULT nextval('major_seq') PRIMARY KEY,
    hyl_mname10 VARCHAR(50) NOT NULL,
    hyl_mdegree10 VARCHAR(20) CHECK (hyl_mdegree10 IN ('本科','硕士','博士')),
    hyl_myears10 INT DEFAULT 4 CHECK (hyl_myears10 > 0), -- 学制年限

    hyl_fno10 INT NOT NULL,
    CONSTRAINT FK_major10_fno10 FOREIGN KEY (hyl_fno10) REFERENCES huyl_faculty10(hyl_fno10) ON DELETE CASCADE,
    UNIQUE(hyl_mname10, hyl_fno10) -- 同一学院内专业名称唯一
);

-- 教师表
CREATE TABLE huyl_teacher10
(
    hyl_tno10 INT DEFAULT nextval('teacher_seq') PRIMARY KEY,
    hyl_tage10 INT NOT NULL CHECK (hyl_tage10 >= 22 AND hyl_tage10 <= 70),
    hyl_tname10 VARCHAR(20) NOT NULL,
    hyl_tbirth10 DATE NOT NULL,
    hyl_ttitle10 VARCHAR(20) NOT NULL CHECK(hyl_ttitle10 IN ('教授', '副教授', '讲师', '助教', '无')),
    hyl_tsex10 VARCHAR(10) NOT NULL CHECK(hyl_tsex10 IN('男','女')),
    hyl_temail10 VARCHAR(100) UNIQUE, -- 邮箱唯一
    hyl_toffice10 VARCHAR(50),
    hyl_tphone10 VARCHAR(20) UNIQUE,
    hyl_tjoindate10 DATE DEFAULT CURRENT_DATE, -- 入职时间
    hyl_tstatus10 VARCHAR(20) DEFAULT '在职' CHECK(hyl_tstatus10 IN ('在职','离职','退休')),

    -- 所属学院
    hyl_fno10 INT,
    CONSTRAINT FK_teacher10_fno10 FOREIGN KEY (hyl_fno10) REFERENCES huyl_faculty10(hyl_fno10) ON DELETE SET NULL
);

-- 课程表
CREATE TABLE huyl_course10
(
    hyl_cno10 INT DEFAULT nextval('course_seq') PRIMARY KEY,
    hyl_cname10 VARCHAR(50) NOT NULL,
    hyl_ccredit10 DECIMAL(3,1) NOT NULL CHECK (hyl_ccredit10 > 0), -- 学分支持小数
    hyl_chour10 INT NOT NULL CHECK (hyl_chour10 > 0),
    hyl_ctest10 VARCHAR(20) NOT NULL CHECK (hyl_ctest10 IN('考试','考查')),
    hyl_ctype10 VARCHAR(20) NOT NULL CHECK (hyl_ctype10 IN('通识课','必修课','限选课','体育课','实践课')),
    hyl_cprereq10 TEXT, -- 先修课程要求
    hyl_cdesc10 TEXT, -- 课程描述
    hyl_cavgscore10 DECIMAL,
    UNIQUE(hyl_cname10, hyl_ctype10) -- 课程名称和类型组合唯一
);

-- 教学班表
CREATE TABLE huyl_tclass10
(
    hyl_tcno10 INT DEFAULT nextval('teaching_class_seq') PRIMARY KEY,
    hyl_tcname10 VARCHAR(50) NOT NULL,
    hyl_tcyear10 INT NOT NULL CHECK (hyl_tcyear10 >= 2020),
    hyl_tcterm10 INT NOT NULL CHECK (hyl_tcterm10 IN (1,2,3)),
    hyl_tcrepeat10 VARCHAR(20) NOT NULL CHECK(hyl_tcrepeat10 IN ('重修班','非重修班')),
    hyl_tcbatch10 VARCHAR(10) NOT NULL DEFAULT '01', -- 班次编号：01、02、03等
    hyl_tcmaxstu10 INT DEFAULT 50 CHECK (hyl_tcmaxstu10 > 0), -- 最大学生数
    hyl_tccurstu10 INT DEFAULT 0 CHECK (hyl_tccurstu10 >= 0), -- 当前学生数

    hyl_cno10 INT NOT NULL,
    CONSTRAINT FK_tclass10_cno10 FOREIGN KEY (hyl_cno10) REFERENCES huyl_course10(hyl_cno10) ON DELETE CASCADE,
    hyl_tno10 INT NOT NULL,
    CONSTRAINT FK_tclass10_tno10 FOREIGN KEY (hyl_tno10) REFERENCES huyl_teacher10(hyl_tno10) ON DELETE CASCADE,

    -- 同一课程、同一学期、同一班次不能重复
    UNIQUE(hyl_cno10, hyl_tcyear10, hyl_tcterm10, hyl_tcbatch10)
);

-- 上课时间地点表
CREATE TABLE huyl_venue10
(
    hyl_vid10 SERIAL PRIMARY KEY, -- 添加主键
    hyl_tplace10 VARCHAR(50) NOT NULL,
    hyl_tstime10 TIME NOT NULL,--起始时间
    hyl_tetime10 TIME NOT NULL,--结束时间
    hyl_tweekday10 INT NOT NULL CHECK (hyl_tweekday10 BETWEEN 1 AND 7), -- 星期几
    hyl_tweeks10 VARCHAR(100), -- 上课周次，如"1-16周"

    hyl_tcno10 INT NOT NULL,
    CONSTRAINT FK_venue10_tcno10 FOREIGN KEY (hyl_tcno10) REFERENCES huyl_tclass10(hyl_tcno10) ON DELETE CASCADE,

    UNIQUE(hyl_tplace10, hyl_tstime10, hyl_tetime10, hyl_tweekday10) -- 防止时间地点冲突
);

-- 行政班表
CREATE TABLE huyl_aclass10
(
    hyl_acno10 INT DEFAULT nextval('administrative_class_seq') PRIMARY KEY,
    hyl_acname10 VARCHAR(50) NOT NULL,
    hyl_acyear10 INT NOT NULL CHECK (hyl_acyear10 >= 2020), -- 入学年份
    hyl_acmaxstu10 INT DEFAULT 30 CHECK (hyl_acmaxstu10 > 0), -- 班级人数上限

    hyl_mno10 INT NOT NULL,
    CONSTRAINT FK_aclass10_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,

    UNIQUE(hyl_acname10, hyl_mno10) -- 同一专业内班级名称唯一
);

-- 学生表
CREATE TABLE huyl_student10
(
    hyl_sno10 INT DEFAULT nextval('student_seq') PRIMARY KEY,
    hyl_sage10 INT NOT NULL CHECK (hyl_sage10 >= 16 AND hyl_sage10 <= 35),
    hyl_sname10 VARCHAR(20) NOT NULL,
    hyl_sbirth10 DATE NOT NULL,
    hyl_splace10 VARCHAR(50) NOT NULL,
    hyl_ssex10 VARCHAR(10) NOT NULL CHECK(hyl_ssex10 IN('男','女')),
    hyl_screditsum10 DECIMAL(5,1) NOT NULL DEFAULT 0 CHECK (hyl_screditsum10 >= 0), -- 已修学分
    hyl_semail10 VARCHAR(100) UNIQUE,
    hyl_sphone10 VARCHAR(20) UNIQUE,
    hyl_senrolldate10 DATE DEFAULT CURRENT_DATE, -- 入学时间
    hyl_sstatus10 VARCHAR(20) DEFAULT '在读' CHECK(hyl_sstatus10 IN ('在读','休学','退学','毕业')),
    hyl_sgpa10 DECIMAL(4,3) NOT NULL DEFAULT 0 CHECK (hyl_sgpa10 >= 0 AND hyl_sgpa10 <= 5),
    hyl_srank10 INT NOT NULL DEFAULT 0,

    hyl_mno10 INT NOT NULL,
    CONSTRAINT FK_student10_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,
    hyl_acno10 INT NOT NULL,
    CONSTRAINT FK_student10_acno10 FOREIGN KEY (hyl_acno10) REFERENCES huyl_aclass10(hyl_acno10) ON DELETE CASCADE
);

-- 选课表
CREATE TABLE huyl_enroll10
(
    hyl_escore10 INT CHECK (hyl_escore10 >= 0 AND hyl_escore10 <= 100), -- 成绩整数
    hyl_egpa10 DECIMAL(2,1) CHECK (hyl_egpa10 >= 0 AND hyl_egpa10 <= 5.0), -- GPA改为小数
    hyl_open10 BOOLEAN NOT NULL DEFAULT true,
    hyl_enrolldate10 TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 选课时间
    hyl_status10 VARCHAR(20) DEFAULT '正常' CHECK(hyl_status10 IN ('正常','退课','重修')),

    hyl_tcno10 INT NOT NULL,
    CONSTRAINT FK_enroll10_tcno10 FOREIGN KEY (hyl_tcno10) REFERENCES huyl_tclass10(hyl_tcno10) ON DELETE CASCADE,
    hyl_sno10 INT NOT NULL,
    CONSTRAINT FK_enroll10_sno10 FOREIGN KEY (hyl_sno10) REFERENCES huyl_student10(hyl_sno10) ON DELETE CASCADE,

    PRIMARY KEY (hyl_sno10, hyl_tcno10)
);

-- 培养方案表（专业-课程关系）
CREATE TABLE huyl_cultivate10
(
    hyl_cid10 INT DEFAULT nextval('cultivate_seq') PRIMARY KEY,
    hyl_mno10 INT NOT NULL,
    hyl_cno10 INT NOT NULL,
    hyl_cterm10 INT CHECK (hyl_cterm10 BETWEEN 1 AND 8), -- 建议学期
    hyl_cmandatory10 BOOLEAN DEFAULT true, -- 是否必修

    CONSTRAINT FK_cultivate_mno10 FOREIGN KEY (hyl_mno10) REFERENCES huyl_major10(hyl_mno10) ON DELETE CASCADE,
    CONSTRAINT FK_cultivate_cno10 FOREIGN KEY (hyl_cno10) REFERENCES huyl_course10(hyl_cno10) ON DELETE CASCADE,

    UNIQUE(hyl_mno10, hyl_cno10) -- 同一专业的课程不重复
);

-- 创建索引以提高查询性能
-- ================== 优化并兼容 openGauss 的索引创建 ==================

-- 基础索引 (针对外键和常用单列查询/排序)
-- openGauss 通常会自动为PRIMARY KEY和UNIQUE约束创建索引，
-- 并且在外键创建时也会考虑索引。但为了明确性和性能考虑，可以显式创建。

-- 学生相关
CREATE INDEX idx_student_acno10 ON huyl_student10(hyl_acno10); -- 外键索引
CREATE INDEX idx_student_mno10 ON huyl_student10(hyl_mno10);   -- 外键索引
CREATE INDEX idx_student_sname10 ON huyl_student10(hyl_sname10); -- 用于按姓名查询
CREATE INDEX idx_student_splace10 ON huyl_student10(hyl_splace10); -- 用于生源地统计

-- 教学班相关
CREATE INDEX idx_tclass_cno10 ON huyl_tclass10(hyl_cno10);     -- 外键索引
CREATE INDEX idx_tclass_tno10 ON huyl_tclass10(hyl_tno10);     -- 外键索引
-- 复合索引，优化按学年学期降序排序或过滤的教学班查询
CREATE INDEX idx_tclass_year_term_combo ON huyl_tclass10(hyl_tcyear10 DESC, hyl_tcterm10 DESC);
-- 用于查询教师任课表，优化WHERE和ORDER BY
CREATE INDEX idx_tclass_teacher_schedule ON huyl_tclass10(hyl_tno10, hyl_tcyear10, hyl_tcterm10);

-- 选课相关
-- huyl_enroll10 的 PRIMARY KEY (hyl_sno10, hyl_tcno10) 会自动创建复合索引
-- 所以单独的 hyl_sno10 和 hyl_tcno10 索引通常是冗余的，这里不显式创建。
CREATE INDEX idx_enroll_escore10 ON huyl_enroll10(hyl_escore10); -- 成绩过滤/排序常用
CREATE INDEX idx_enroll_egpa10 ON huyl_enroll10(hyl_egpa10);     -- GPA查询/排序常用

-- 专业相关
CREATE INDEX idx_major_fno10 ON huyl_major10(hyl_fno10);       -- 外键索引
CREATE INDEX idx_major_mname10 ON huyl_major10(hyl_mname10);   -- 按专业名称查找

-- 教师相关
CREATE INDEX idx_teacher_fno10 ON huyl_teacher10(hyl_fno10);   -- 外键索引
CREATE INDEX idx_teacher_tname10 ON huyl_teacher10(hyl_tname10); -- 模糊查询姓名
CREATE INDEX idx_teacher_ttitle10 ON huyl_teacher10(hyl_ttitle10); -- 按职称查询

-- 课程相关
-- huyl_course10 的 UNIQUE(hyl_cname10, hyl_ctype10) 会自动创建索引
CREATE INDEX idx_course_cname10 ON huyl_course10(hyl_cname10); -- 如果经常单独按名称查询
CREATE INDEX idx_course_ctype10 ON huyl_course10(hyl_ctype10); -- 按类型查询

-- 上课时间地点相关
-- huyl_venue10 的 UNIQUE(hyl_tplace10, hyl_tstime10, hyl_tetime10, hyl_tweekday10) 会自动创建复合索引
-- 优化课表查询和冲突检测： (教学班, 星期几, 开始时间, 结束时间)
CREATE INDEX idx_venue_schedule_lookup ON huyl_venue10(hyl_tcno10, hyl_tweekday10, hyl_tstime10, hyl_tetime10);

-- 培养方案相关 (外键)
CREATE INDEX idx_cultivate_mno10 ON huyl_cultivate10(hyl_mno10);
CREATE INDEX idx_cultivate_cno10 ON huyl_cultivate10(hyl_cno10);


-- 针对特定查询和过滤条件的优化（过滤索引 - openGauss 语法：条件需要用括号括起来）
CREATE INDEX idx_student_status_active ON huyl_student10(hyl_sstatus10) WHERE (hyl_sstatus10 = '在读');
CREATE INDEX idx_teacher_status_active ON huyl_teacher10(hyl_tstatus10) WHERE (hyl_tstatus10 = '在职');
CREATE INDEX idx_enroll_status_normal ON huyl_enroll10(hyl_status10) WHERE (hyl_status10 = '正常');

-- 用于优化查询当前或最近学期的教学班，减少扫描范围
CREATE INDEX idx_tclass_recent_year_term ON huyl_tclass10(hyl_tcyear10, hyl_tcterm10)
    WHERE (hyl_tcyear10 >= EXTRACT(YEAR FROM CURRENT_DATE) - 1);


-- 其他通用但可能在特定查询模式下有用的复合索引
-- 用于按教学班计算成绩的聚合查询
CREATE INDEX idx_enroll_tc_score ON huyl_enroll10(hyl_tcno10, hyl_escore10);



-- ================== 4. 重新执行 code1.sql 里的所有视图、索引、触发器、函数定义 ==================
-- 直接复制 code1.sql 里所有视图、索引、函数、触发器定义到此处
-- （此处省略，实际使用时请粘贴 code1.sql 的全部定义）
--1创建视图
-- ================== 1. 创建视图 ==================

-- 1.1 学生成绩查询视图
-- 功能：综合查询学生的详细成绩信息
-- 包括：学号、学生姓名、课程名称、成绩、任课教师、学年、学期
CREATE OR REPLACE VIEW v_student_scores AS
SELECT
    e.hyl_sno10 AS student_id,           -- 学号
    s.hyl_sname10 AS student_name,       -- 学生姓名
    c.hyl_cname10 AS course_name,        -- 课程名称
    e.hyl_escore10 AS score,             -- 成绩
    t.hyl_tname10 AS teacher_name,       -- 任课教师
    tc.hyl_tcyear10 AS year,             -- 学年
    tc.hyl_tcterm10 AS term              -- 学期
FROM huyl_enroll10 e
    JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10
    JOIN huyl_tclass10 tc ON tc.hyl_tcno10 = e.hyl_tcno10
    JOIN huyl_course10 c ON c.hyl_cno10 = tc.hyl_cno10
    LEFT JOIN huyl_teacher10 t ON t.hyl_tno10 = tc.hyl_tno10; -- 教师可能为空，用LEFT JOIN更合理

-- 1.2 学生每学年成绩统计视图
-- 功能：统计每个学生每学年的平均成绩
-- 用途：年度成绩分析、学业表现趋势跟踪
CREATE OR REPLACE VIEW v_student_yearly_scores AS
SELECT
    s.hyl_sno10 AS student_id,           -- 学号
    s.hyl_sname10 AS student_name,       -- 学生姓名
    tc.hyl_tcyear10 AS year,             -- 学年
    ROUND(AVG(e.hyl_escore10), 2) AS avg_score  -- 平均成绩（保留2位小数）
FROM huyl_enroll10 e
    JOIN huyl_student10 s ON s.hyl_sno10 = e.hyl_sno10
    JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
WHERE e.hyl_escore10 IS NOT NULL -- 只统计有成绩的课程
GROUP BY s.hyl_sno10, s.hyl_sname10, tc.hyl_tcyear10
ORDER BY s.hyl_sno10, tc.hyl_tcyear10;

-- 1.3 课程平均成绩统计视图
-- 功能：统计每门课程的整体平均成绩
-- 用途：课程难度分析、教学质量评估
CREATE OR REPLACE VIEW v_course_avg_scores AS
SELECT
    c.hyl_cno10 AS course_id,            -- 课程编号
    c.hyl_cname10 AS course_name,        -- 课程名称
    ROUND(AVG(e.hyl_escore10), 2) AS avg_score,  -- 平均成绩
    COUNT(e.hyl_sno10) AS student_count   -- 选课学生数量
FROM huyl_enroll10 e
         JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
         JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
WHERE e.hyl_escore10 IS NOT NULL -- 只统计有成绩的选课记录
GROUP BY c.hyl_cno10, c.hyl_cname10
ORDER BY avg_score DESC;

-- 1.4 学生课程及学分统计视图
-- 功能：展示学生选修的所有课程及对应学分
-- 用途：学分统计、毕业审核
CREATE OR REPLACE VIEW v_student_courses AS
SELECT
    s.hyl_sno10 AS student_id,           -- 学号
    s.hyl_sname10 AS student_name,       -- 学生姓名
    c.hyl_cno10 AS course_id,            -- 课程编号
    c.hyl_cname10 AS course_name,        -- 课程名称
    c.hyl_ccredit10 AS course_credit,    -- 课程学分
    e.hyl_escore10 AS score,             -- 获得成绩
    tc.hyl_tcyear10 AS year,             -- 学年
    tc.hyl_tcterm10 AS term              -- 学期
FROM huyl_enroll10 e
    JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
    JOIN huyl_course10 c ON c.hyl_cno10 = tc.hyl_cno10
    JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10
ORDER BY s.hyl_sno10, tc.hyl_tcyear10, tc.hyl_tcterm10;

-- 1.5 教师任课查询视图
-- 功能：查询教师的详细任课信息
-- 包括：教师信息、课程信息、时间地点等
CREATE OR REPLACE VIEW v_teacher_courses AS
SELECT
    t.hyl_tno10 AS teacher_id,           -- 教师编号
    t.hyl_tname10 AS teacher_name,       -- 教师姓名
    c.hyl_cno10 AS course_id,            -- 课程编号
    c.hyl_cname10 AS course_name,        -- 课程名称
    tc.hyl_tcyear10 AS year,             -- 学年
    tc.hyl_tcterm10 AS term,             -- 学期
    tc.hyl_tcbatch10 AS batch,           -- 批次
    v.hyl_tstime10 AS start_time,        -- 开始时间
    v.hyl_tetime10 AS end_time,          -- 结束时间
    v.hyl_tplace10 AS place              -- 上课地点
FROM huyl_teacher10 t
    JOIN huyl_tclass10 tc ON t.hyl_tno10 = tc.hyl_tno10
    JOIN huyl_course10 c ON c.hyl_cno10 = tc.hyl_cno10
    LEFT JOIN huyl_venue10 v ON tc.hyl_tcno10 = v.hyl_tcno10 -- 考虑到可能没有时间地点信息
ORDER BY t.hyl_tno10, tc.hyl_tcyear10, tc.hyl_tcterm10;

-- 1.6 班级课程开设查询视图
-- 功能：查询某班级的课程开设情况（通过班级学生选课情况推断）
CREATE OR REPLACE VIEW v_class_courses AS
SELECT DISTINCT -- 使用 DISTINCT 避免重复课程记录
                ac.hyl_acno10 AS class_id,
                ac.hyl_acname10 AS class_name, -- 增加班级名称
                c.hyl_cname10 AS course_name,
                t.hyl_tname10 AS teacher_name,
                tc.hyl_tcyear10 AS year,
    tc.hyl_tcterm10 AS term
FROM
    huyl_aclass10 ac
    JOIN huyl_student10 s ON ac.hyl_acno10 = s.hyl_acno10
    JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10
    JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
    JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
    LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10; -- 教师可能为空

-- 1.7 课程名称下拉选项
CREATE OR REPLACE VIEW v_course_dropdown AS
SELECT
    c.hyl_cno10 AS course_id,
    c.hyl_cname10 AS course_name
FROM huyl_course10 c
ORDER BY c.hyl_cname10; -- 增加排序

-- 1.8 学生姓名下拉选项
CREATE OR REPLACE VIEW v_student_dropdown AS
SELECT
    s.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name
FROM huyl_student10 s
ORDER BY s.hyl_sname10; -- 增加排序

-- 1.9 教师姓名下拉选项
CREATE OR REPLACE VIEW v_teacher_dropdown AS
SELECT
    t.hyl_tno10 AS teacher_id,
    t.hyl_tname10 AS teacher_name
FROM huyl_teacher10 t
ORDER BY t.hyl_tname10; -- 增加排序

-- 1.10 班级名称下拉选项
CREATE OR REPLACE VIEW v_class_dropdown AS
SELECT
    ac.hyl_acno10 AS class_id,
    ac.hyl_acname10 AS class_name
FROM huyl_aclass10 ac
ORDER BY ac.hyl_acname10; -- 增加排序

-- 1.11 专业名称下拉选项
CREATE OR REPLACE VIEW v_major_dropdown AS
SELECT
    m.hyl_mno10 AS major_id,
    m.hyl_mname10 AS major_name
FROM huyl_major10 m
ORDER BY m.hyl_mname10; -- 增加排序

-- 1.12 学生所在地区成绩统计视图
-- 功能：统计学生所在地区（生源地）的平均成绩和学生数量
CREATE OR REPLACE VIEW v_student_region_scores AS
SELECT
    s.hyl_splace10 AS student_region,
    ROUND(AVG(e.hyl_escore10), 2) AS average_score,
    COUNT(DISTINCT s.hyl_sno10) AS student_count -- 统计不同学生数量
FROM huyl_enroll10 e
         JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10
WHERE e.hyl_escore10 IS NOT NULL -- 只统计有成绩的
GROUP BY s.hyl_splace10
ORDER BY average_score DESC;

-- 1.13 教师教授课程的学生成绩视图
-- 功能：查询教师所教授课程的学生成绩详情
CREATE OR REPLACE VIEW v_teacher_student_scores AS
SELECT
    t.hyl_tname10 AS teacher_name,
    s.hyl_sname10 AS student_name,
    c.hyl_cname10 AS course_name,
    e.hyl_escore10 AS score,
    tc.hyl_tcyear10 AS year,
    tc.hyl_tcterm10 AS term
FROM huyl_tclass10 tc
    JOIN huyl_teacher10 t ON t.hyl_tno10 = tc.hyl_tno10
    JOIN huyl_course10 c ON c.hyl_cno10 = tc.hyl_cno10
    JOIN huyl_enroll10 e ON e.hyl_tcno10 = tc.hyl_tcno10
    JOIN huyl_student10 s ON s.hyl_sno10 = e.hyl_sno10
WHERE t.hyl_tstatus10 = '在职' AND e.hyl_escore10 IS NOT NULL -- 仅限在职教师和有成绩的选课
ORDER BY teacher_name, year, term, score DESC;


-- 不推荐直接在视图中使用参数占位符（如 :search_term）
-- 对于以下功能，建议在应用层直接构建带参数的SQL查询，
-- 或者如果需要封装在数据库中，可以考虑创建"返回表的函数"（Table-Valued Function）。
-- 直接创建视图会导致语法错误或不符合视图的静态定义特性。

-- 废弃视图示例 (因包含参数化查询)：
-- v_student_name_search
-- v_course_name_search
-- v_teacher_name_search
-- v_student_score_search
-- v_student_search_with_weight
-- v_course_auto_complete
-- v_student_auto_complete

-- =============================================
-- 视图使用示例查询 (保持不变，这些是在应用中查询视图的例子)
-- =============================================

-- 示例1: 查询特定学生的所有成绩
-- SELECT * FROM v_student_scores WHERE student_id = 600001;

-- 示例2: 查询2023年所有学生的平均成绩
-- SELECT * FROM v_student_yearly_scores WHERE year = 2023 ORDER BY avg_score DESC;

-- 示例3: 查询平均成绩最高的前10门课程
-- SELECT * FROM v_course_avg_scores LIMIT 10;

-- 示例4: 统计学生总学分
-- SELECT student_id, student_name, SUM(course_credit) as total_credits
-- FROM v_student_courses GROUP BY student_id, student_name;

-- 示例5: 查询特定教师的任课安排
-- SELECT * FROM v_teacher_courses WHERE teacher_name = '张教授';

-- 示例6: 查询计科1班的课程开设情况
-- SELECT * FROM v_class_courses WHERE class_id = 300001;

-- 示例7: 查询生源地平均分最高的地区
-- SELECT * FROM v_student_region_scores LIMIT 1;

-- 示例8: 查询张教授所授课程的学生成绩
-- SELECT * FROM v_teacher_student_scores WHERE teacher_name = '张教授';
--------------------------------------------------------------------------------------------------------

-- ================== 2. 创建函数 ==================

-- 2.1 确保学生的专业与行政班专业一致的函数
CREATE OR REPLACE FUNCTION check_student_major_consistency()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM huyl_aclass10 ac
        WHERE ac.hyl_acno10 = NEW.hyl_acno10
          AND ac.hyl_mno10 = NEW.hyl_mno10
    ) THEN
        RAISE EXCEPTION '学生专业与行政班专业不匹配。学生专业ID:%, 行政班ID:%, 期望专业ID:%',
            NEW.hyl_mno10, NEW.hyl_acno10, (SELECT hyl_mno10 FROM huyl_aclass10 WHERE hyl_acno10 = NEW.hyl_acno10);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.2 自动更新学生已修学分函数
-- 逻辑：当学生选课成绩及格时增加学分，成绩由及格变为不及格时或退课（删除）时减少学分。
CREATE OR REPLACE FUNCTION update_student_credits()
    RETURNS TRIGGER AS $$
DECLARE
course_credit DECIMAL(3,1);
    current_student_credits DECIMAL(5,1);
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- 获取课程学分
SELECT c.hyl_ccredit10 INTO course_credit
FROM huyl_course10 c
         JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
WHERE tc.hyl_tcno10 = NEW.hyl_tcno10;

IF course_credit IS NULL THEN
            RAISE EXCEPTION '无法找到教学班 % 对应的课程学分，学分更新失败', NEW.hyl_tcno10;
END IF;

        -- 如果新成绩及格，增加学分
        IF NEW.hyl_escore10 IS NOT NULL AND NEW.hyl_escore10 >= 60 THEN
UPDATE huyl_student10
SET hyl_screditsum10 = COALESCE(hyl_screditsum10, 0) + course_credit
WHERE hyl_sno10 = NEW.hyl_sno10;
END IF;
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        -- 获取课程学分
SELECT c.hyl_ccredit10 INTO course_credit
FROM huyl_course10 c
         JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
WHERE tc.hyl_tcno10 = NEW.hyl_tcno10;

IF course_credit IS NULL THEN
            RAISE EXCEPTION '无法找到教学班 % 对应的课程学分，学分更新失败', NEW.hyl_tcno10;
END IF;

        -- 情况1: 成绩从不及格变为及格 或 新增成绩且及格
        IF (OLD.hyl_escore10 IS NULL OR OLD.hyl_escore10 < 60) AND (NEW.hyl_escore10 IS NOT NULL AND NEW.hyl_escore10 >= 60) THEN
UPDATE huyl_student10
SET hyl_screditsum10 = COALESCE(hyl_screditsum10, 0) + course_credit
WHERE hyl_sno10 = NEW.hyl_sno10;
-- 情况2: 成绩从及格变为不及格 或 成绩被删除
ELSIF (OLD.hyl_escore10 IS NOT NULL AND OLD.hyl_escore10 >= 60) AND (NEW.hyl_escore10 IS NULL OR NEW.hyl_escore10 < 60) THEN
UPDATE huyl_student10
SET hyl_screditsum10 = GREATEST(COALESCE(hyl_screditsum10, 0) - course_credit, 0)
WHERE hyl_sno10 = NEW.hyl_sno10;
END IF;
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        -- 获取课程学分
SELECT c.hyl_ccredit10 INTO course_credit
FROM huyl_course10 c
         JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
WHERE tc.hyl_tcno10 = OLD.hyl_tcno10;

IF course_credit IS NOT NULL THEN
            -- 如果删除的记录之前成绩及格，则减少学分
            IF OLD.hyl_escore10 IS NOT NULL AND OLD.hyl_escore10 >= 60 THEN
UPDATE huyl_student10
SET hyl_screditsum10 = GREATEST(COALESCE(hyl_screditsum10, 0) - course_credit, 0)
WHERE hyl_sno10 = OLD.hyl_sno10;
END IF;
END IF;
RETURN OLD;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- 2.3 自动更新教学班当前学生数 (已优化合并：原 update_tclass_student_count 的功能已并入此函数)
-- 逻辑：当学生选课、退课或更换教学班时，自动更新教学班的当前学生数。
CREATE OR REPLACE FUNCTION update_tclass_student_count()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
UPDATE huyl_tclass10
SET hyl_tccurstu10 = COALESCE(hyl_tccurstu10, 0) + 1
WHERE hyl_tcno10 = NEW.hyl_tcno10;
RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN
UPDATE huyl_tclass10
SET hyl_tccurstu10 = GREATEST(COALESCE(hyl_tccurstu10, 0) - 1, 0)
WHERE hyl_tcno10 = OLD.hyl_tcno10;
RETURN OLD;
ELSIF TG_OP = 'UPDATE' THEN
        -- 如果学生更换了教学班（hyl_tcno10 字段发生变化）
        IF OLD.hyl_tcno10 IS DISTINCT FROM NEW.hyl_tcno10 THEN
            -- 原教学班人数减1
UPDATE huyl_tclass10
SET hyl_tccurstu10 = GREATEST(COALESCE(hyl_tccurstu10, 0) - 1, 0)
WHERE hyl_tcno10 = OLD.hyl_tcno10;
-- 新教学班人数加1
UPDATE huyl_tclass10
SET hyl_tccurstu10 = COALESCE(hyl_tccurstu10, 0) + 1
WHERE hyl_tcno10 = NEW.hyl_tcno10;
END IF;
RETURN NEW;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- 2.4 自动更新学生的状态（如"毕业"）函数
-- 逻辑：当学生已修学分达到毕业要求，且所有课程都已及格时，自动将学生的状态设置为"毕业"。
-- 修正：修正了 JOIN 条件，使其正确关联 huyl_course10 表获取学分。
-- 注意：此逻辑只检查已记录成绩的课程是否及格并累计学分，更严谨的毕业判断可能需要确保所有培养方案中的必修课都已及格。
CREATE OR REPLACE FUNCTION update_student_status_on_graduation()
    RETURNS TRIGGER AS $$
DECLARE
required_credits DECIMAL(5,1) := 120.0; -- 假设毕业所需总学分
    current_earned_credits DECIMAL(5,1);
    has_failed_courses BOOLEAN;
BEGIN
    -- 仅当成绩更新且涉及分数时才触发后续逻辑
    IF TG_OP = 'UPDATE' AND (NEW.hyl_escore10 IS DISTINCT FROM OLD.hyl_escore10) THEN
        -- 获取该学生当前所有已及格课程的总学分
SELECT COALESCE(SUM(c.hyl_ccredit10), 0) INTO current_earned_credits
FROM huyl_enroll10 e
         JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
         JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
WHERE e.hyl_sno10 = NEW.hyl_sno10 AND e.hyl_escore10 >= 60;

-- 检查该学生是否有不及格的课程（排除未出成绩的）
SELECT EXISTS (
    SELECT 1
    FROM huyl_enroll10 e
    WHERE e.hyl_sno10 = NEW.hyl_sno10
      AND e.hyl_escore10 IS NOT NULL
      AND e.hyl_escore10 < 60
) INTO has_failed_courses;

-- 如果学分达到要求 并且 没有不及格的课程 并且 当前状态不是"毕业"
IF current_earned_credits >= required_credits AND NOT has_failed_courses THEN
UPDATE huyl_student10
SET hyl_sstatus10 = '毕业'
WHERE hyl_sno10 = NEW.hyl_sno10 AND hyl_sstatus10 != '毕业';
END IF;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 2.5 自动提醒学生课程选择冲突函数
-- 逻辑：在学生选课或更新选课时，检查新选课程的时间是否与已有课程时间重叠。
CREATE OR REPLACE FUNCTION check_course_schedule_conflict()
    RETURNS TRIGGER AS $$
DECLARE
conflict_count INT;
    new_weekday INT; -- 修正为 INT 类型
    new_start_time TIME;
    new_end_time TIME;
    conflict_info TEXT := ''; -- 用于存储冲突课程的详细信息
BEGIN
    -- 先获取新选课程的时间信息
SELECT hyl_tweekday10, hyl_tstime10, hyl_tetime10
INTO new_weekday, new_start_time, new_end_time
FROM huyl_venue10
WHERE hyl_tcno10 = NEW.hyl_tcno10;

-- 如果新课程没有时间安排，则不需要检查冲突
IF new_weekday IS NULL OR new_start_time IS NULL OR new_end_time IS NULL THEN
        RETURN NEW;
END IF;

    -- 检查新选的课程与学生已有课程时间是否冲突
SELECT COUNT(*),
       STRING_AGG(
               c.hyl_cname10 || ' (教学班ID:' || v1.hyl_tcno10 || ' 星期' || v1.hyl_tweekday10 || ' ' || v1.hyl_tstime10::TEXT || '-' || v1.hyl_tetime10::TEXT || ')',
               ', '
                   ORDER BY c.hyl_cname10) -- 按照课程名称排序，让错误信息更清晰
INTO conflict_count, conflict_info
FROM huyl_venue10 v1
         JOIN huyl_enroll10 e ON e.hyl_tcno10 = v1.hyl_tcno10
         JOIN huyl_tclass10 tc ON v1.hyl_tcno10 = tc.hyl_tcno10
         JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
WHERE e.hyl_sno10 = NEW.hyl_sno10           -- 同一学生
  AND v1.hyl_tcno10 != NEW.hyl_tcno10       -- 排除当前选择的课程 (对于UPDATE时，如果是修改为同一课程则不冲突)
      AND v1.hyl_tweekday10 = new_weekday       -- 同一星期几
      AND (
            -- 检查时间段重叠：新课程开始时间 < 已有课程结束时间 AND 新课程结束时间 > 已有课程开始时间
            -- 这是一个标准的判断两个时间段是否有重叠的条件
            (NEW.hyl_tcno10 != OLD.hyl_tcno10 AND NEW.hyl_sno10 = OLD.hyl_sno10) OR TG_OP = 'INSERT'
            AND new_start_time < v1.hyl_tetime10 AND new_end_time > v1.hyl_tstime10
          );

-- 如果发现冲突，抛出异常
IF conflict_count > 0 THEN
        RAISE EXCEPTION '课程时间冲突！您选择的课程在星期%（%-%）与已选课程时间重叠，冲突课程：% 。请选择其他时间的课程。',
            new_weekday, new_start_time::TEXT, new_end_time::TEXT, conflict_info;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 2.6 自动删除离职教师相关的教学班函数
-- 逻辑：当教师状态更新为"离职"时，自动删除该教师所有相关的教学班记录。
-- 注意：删除教学班会导致级联删除其下的选课记录和上课时间地点记录（由外键 ON DELETE CASCADE 确保）。
-- 这是一个强耦合的业务逻辑，实际使用需谨慎评估影响。
CREATE OR REPLACE FUNCTION delete_teacher_related_classes()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.hyl_tstatus10 = '离职' THEN
DELETE FROM huyl_tclass10
WHERE hyl_tno10 = NEW.hyl_tno10;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 2.7 自动更新课程平均成绩函数
-- 逻辑：当选课成绩插入、更新或删除时，自动计算并更新该课程的平均分。
CREATE OR REPLACE FUNCTION update_course_avg_score()
    RETURNS TRIGGER AS $$
DECLARE
avg_score DECIMAL(5,2);
    course_id INT;
BEGIN
    -- 确定需要更新平均分的课程ID
    course_id := (SELECT hyl_cno10 FROM huyl_tclass10 WHERE hyl_tcno10 = COALESCE(NEW.hyl_tcno10, OLD.hyl_tcno10));

    -- 计算该课程的平均分（只考虑有成绩的记录）
SELECT AVG(e.hyl_escore10) INTO avg_score
FROM huyl_enroll10 e
         JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
WHERE tc.hyl_cno10 = course_id AND e.hyl_escore10 IS NOT NULL;

-- 更新课程表中的平均成绩
UPDATE huyl_course10
SET hyl_cavgscore10 = COALESCE(avg_score, 0.00) -- 如果没有成绩，平均分设为0
WHERE hyl_cno10 = course_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 2.8 自动计算学生的 GPA 函数
-- 逻辑：当学生的选课记录发生变化（新增、更新、删除）时，自动重新计算该学生的总 GPA。
-- GPA 计算公式：SUM(课程GPA * 课程学分) / SUM(课程学分)
-- 假设 huyl_egpa10 存储的是该课程的绩点 (如4.0, 3.5等)，hyl_ccredit10是学分。
CREATE OR REPLACE FUNCTION update_student_gpa()
    RETURNS TRIGGER AS $$
DECLARE
    total_credits DECIMAL(5,1);
    total_grade_points DECIMAL(6,2); -- 绩点总和
    calculated_gpa DECIMAL(4,3);
    student_id_to_update INT;
BEGIN
    -- 确定需要更新GPA的学生ID (NEW 或 OLD)
    student_id_to_update := COALESCE(NEW.hyl_sno10, OLD.hyl_sno10);

    -- 计算该学生所有已及格课程的总学分和总绩点
    -- 注意：这里假设 hyl_egpa10 已经是该课程的绩点
    SELECT
        COALESCE(SUM(c.hyl_ccredit10), 0),
        COALESCE(SUM(e.hyl_egpa10 * c.hyl_ccredit10), 0) -- 绩点乘以学分
    INTO total_credits, total_grade_points
    FROM huyl_enroll10 e
             JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
             JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
    WHERE e.hyl_sno10 = student_id_to_update
      AND e.hyl_egpa10 IS NOT NULL; -- 只计算有GPA的课程

    -- 计算GPA
    IF total_credits > 0 THEN
        calculated_gpa := ROUND(total_grade_points / total_credits, 3); -- GPA精确到3位小数
    ELSE
        calculated_gpa := 0.000; -- 如果没有有效学分，则GPA为0.000
    END IF;

    -- 更新学生表中的GPA
    UPDATE huyl_student10
    SET hyl_sgpa10 = calculated_gpa
    WHERE hyl_sno10 = student_id_to_update;

    RETURN NEW; -- 返回NEW记录
END;
$$ LANGUAGE plpgsql;

-- 2.9 自动计算学生的专业排名函数
-- 推荐方案：更新整个专业所有学生的排名（更准确，但计算量相对大）
CREATE OR REPLACE FUNCTION update_major_all_students_rank()
    RETURNS TRIGGER AS $$
DECLARE
major_id_to_update INT;
BEGIN
    -- 获取需要更新的专业ID (NEW 或 OLD)
    -- 注意：hyl_sno10 是学生表的主键，因此 NEW.hyl_sno10 总是存在。
    major_id_to_update := NEW.hyl_mno10;

    -- 如果找不到学生专业信息，直接返回
    IF major_id_to_update IS NULL THEN
        RETURN NEW;
END IF;

    -- 更新该专业所有学生的排名
WITH ranked_students AS (
    SELECT
        hyl_sno10,
        RANK() OVER (ORDER BY hyl_sgpa10 DESC, hyl_sno10 ASC) AS new_rank -- GPA相同按学号排序
    FROM huyl_student10
    WHERE hyl_mno10 = major_id_to_update
      AND hyl_sgpa10 IS NOT NULL
)
UPDATE huyl_student10
SET hyl_srank10 = rs.new_rank
    FROM ranked_students rs
WHERE huyl_student10.hyl_sno10 = rs.hyl_sno10;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 2.10 批量重新计算所有专业排名的函数
-- 用途：当系统首次上线，或学生GPA数据发生大规模变动时，可以手动调用此函数进行一次性全量排名计算。
CREATE OR REPLACE FUNCTION recalculate_all_major_ranks()
    RETURNS VOID AS $$
DECLARE
major_record RECORD;
BEGIN
    -- 遍历所有有学生的专业
FOR major_record IN
SELECT DISTINCT hyl_mno10 FROM huyl_student10 WHERE hyl_mno10 IS NOT NULL
    LOOP
-- 更新该专业所有学生的排名
WITH ranked_students AS (
    SELECT
    hyl_sno10,
    RANK() OVER (ORDER BY hyl_sgpa10 DESC, hyl_sno10 ASC) AS new_rank
    FROM huyl_student10
    WHERE hyl_mno10 = major_record.hyl_mno10
    AND hyl_sgpa10 IS NOT NULL
    )
UPDATE huyl_student10
SET hyl_srank10 = rs.new_rank
    FROM ranked_students rs
WHERE huyl_student10.hyl_sno10 = rs.hyl_sno10;
END LOOP;

    RAISE NOTICE '所有专业的学生排名已重新计算完成。';
END;
$$ LANGUAGE plpgsql;


-- 2.11 自动生成学生密码函数 (安全性警告！)
-- 逻辑：根据学生学号自动生成一个简单的明文密码。
-- !!! 安全警告 !!!
-- 在生产环境中，绝不能以明文形式存储或生成密码。
-- 应使用强大的单向哈希函数 (如 bcrypt, scrypt, Argon2) 对密码进行哈希处理并加盐 (salting)，
-- 并在认证时比较哈希值。此函数仅为演示目的保留。
CREATE OR REPLACE FUNCTION generate_student_password()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.hyl_upassword10 := CONCAT('zjut', NEW.hyl_uno10); -- 假设 huyl_uno10 是用户表的ID
    -- 注意：这里应使用用户的唯一ID，例如用户表的主键 hyl_uno10
    -- 如果 hyl_sno10 (学生学号) 与 hyl_uno10 (用户ID) 存在一对一关系，
    -- 且在插入用户时能获取到 hyl_sno10，也可以考虑 CONCAT('stu', NEW.hyl_sno10)。
    -- 但根据表定义，hyl_uno10是主键。
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.12 级联删除学生相关记录函数 (已优化：若已设置外键 CASCADE，此函数和触发器可移除)
-- !!! 优化说明 !!!
-- 你的表定义中 huyl_enroll10 依赖 huyl_student10 的外键已经设置了 ON DELETE CASCADE。
-- 这意味着当学生记录从 huyl_student10 表中被删除时，数据库会自动级联删除其在 huyl_enroll10 表中的所有选课记录。
-- 因此，这个函数及其触发器是多余的，且数据库自带的级联删除效率更高。
-- 我会将其保留，但标记为可移除/冗余，因为 ON DELETE CASCADE 已经覆盖了。
CREATE OR REPLACE FUNCTION cascade_delete_student()
    RETURNS TRIGGER AS $$
BEGIN
    -- 这一步由外键的 ON DELETE CASCADE 自动完成，函数内无需显式 DELETE
    -- DELETE FROM huyl_enroll10 WHERE hyl_sno10 = OLD.hyl_sno10;
    RAISE NOTICE '学生 % 的选课记录已由外键级联删除。', OLD.hyl_sno10;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------------------------------------------------------------------------
-- ================== 3. 创建触发器 ==================

-- 3.1 触发器：确保学生的专业与行政班专业一致
CREATE TRIGGER tr_check_student_major_consistency
    BEFORE INSERT OR UPDATE ON huyl_student10
                         FOR EACH ROW EXECUTE procedure check_student_major_consistency();


-- 3.2 触发器：自动更新学生已修学分
CREATE TRIGGER tr_update_student_credits
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10
    FOR EACH ROW EXECUTE PROCEDURE update_student_credits();


-- 3.3 触发器：自动更新教学班当前学生数
CREATE TRIGGER tr_update_tclass_count
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10 -- 修正：增加UPDATE操作的触发
    FOR EACH ROW EXECUTE PROCEDURE update_tclass_student_count();


-- 3.4 触发器：自动更新学生的状态（如"毕业"）
CREATE TRIGGER tr_update_student_graduation_status
    AFTER UPDATE ON huyl_enroll10
    FOR EACH ROW
    WHEN (NEW.hyl_escore10 IS DISTINCT FROM OLD.hyl_escore10 OR NEW.hyl_status10 IS DISTINCT FROM OLD.hyl_status10) -- 仅当成绩或状态改变时触发
    EXECUTE PROCEDURE update_student_status_on_graduation();


-- 3.5 触发器：自动提醒学生课程选择冲突
-- BEFORE INSERT: 检查新选课是否冲突
DROP TRIGGER IF EXISTS trg_check_course_conflict ON huyl_enroll10; -- 先删除旧的
CREATE TRIGGER trg_check_course_conflict
    BEFORE INSERT ON huyl_enroll10
    FOR EACH ROW
    EXECUTE PROCEDURE check_course_schedule_conflict();

-- BEFORE UPDATE: 检查更新选课（如更换教学班）是否冲突
DROP TRIGGER IF EXISTS trg_check_course_conflict_update ON huyl_enroll10; -- 先删除旧的
CREATE TRIGGER trg_check_course_conflict_update
    BEFORE UPDATE ON huyl_enroll10
    FOR EACH ROW
    WHEN (OLD.hyl_tcno10 IS DISTINCT FROM NEW.hyl_tcno10) -- 仅当教学班号改变时检查
    EXECUTE PROCEDURE check_course_schedule_conflict();


-- 3.6 触发器：自动删除离职教师相关的教学班
CREATE TRIGGER tr_delete_teacher_classes
    AFTER UPDATE OF hyl_tstatus10 ON huyl_teacher10 -- 仅当状态改变时触发
    FOR EACH ROW
    WHEN (NEW.hyl_tstatus10 = '离职' AND OLD.hyl_tstatus10 IS DISTINCT FROM '离职') -- 仅当从非离职变为离职时
    EXECUTE PROCEDURE delete_teacher_related_classes();


-- 3.7 触发器：自动更新课程平均成绩
CREATE TRIGGER tr_update_course_avg_score
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10 -- 增加DELETE操作的触发
    FOR EACH ROW EXECUTE PROCEDURE update_course_avg_score();


-- 3.8 触发器：自动计算学生的GPA
CREATE TRIGGER tr_update_student_gpa
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10
    FOR EACH ROW EXECUTE PROCEDURE update_student_gpa();


-- 3.9 触发器：自动计算学生的专业排名
CREATE TRIGGER tr_update_student_major_rank
    AFTER UPDATE OF hyl_sgpa10 ON huyl_student10 -- 仅在 GPA 改变时触发
    FOR EACH ROW
    WHEN (OLD.hyl_sgpa10 IS DISTINCT FROM NEW.hyl_sgpa10) -- 仅当 GPA 值实际发生变化时
    EXECUTE PROCEDURE update_major_all_students_rank();



-- 3.11 触发器：级联删除学生相关记录 (已移除，由外键ON DELETE CASCADE处理)
-- 由于 huyl_enroll10 表的外键 FK_enroll10_sno10 已经设置了 ON DELETE CASCADE，
-- 当删除 huyl_student10 中的记录时，相关的 huyl_enroll10 记录会自动被数据库删除，
-- 无需额外的触发器。因此，此触发器被移除以避免冗余和潜在的性能开销。
-- DROP TRIGGER IF EXISTS tr_cascade_delete_student ON huyl_student10;

----------------------------------------------------------------------------------------------------------------
-- ================== 1. 辅助视图 (已更新) ==================

---
--- 辅助视图: v_enrollment_calculated_gpa
--- 功能：此视图提供了学生选课的详细信息，并根据百分制成绩统一计算每门课的绩点。
---
CREATE OR REPLACE VIEW v_enrollment_calculated_gpa AS
SELECT
    he.hyl_sno10,
    he.hyl_tcno10,
    he.hyl_escore10,
    htc.hyl_cno10,
    hc.hyl_ccredit10,
    he.hyl_open10,
    ROUND(
            CASE
                WHEN he.hyl_escore10 IS NULL THEN NULL -- 如果成绩为空，绩点也为空
                WHEN he.hyl_escore10 BETWEEN 60 AND 100 THEN (he.hyl_escore10 - 50) / 10.0
                ELSE 0.0
                END, 2
    ) AS calculated_gpa
FROM huyl_enroll10 he
         JOIN huyl_tclass10 htc ON he.hyl_tcno10 = htc.hyl_tcno10
         JOIN huyl_course10 hc ON htc.hyl_cno10 = hc.hyl_cno10;

-- 查询辅助视图示例：
-- SELECT * FROM v_enrollment_calculated_gpa LIMIT 10;

-- ================== 2. 核心业务视图 (已更新) ==================

---
--- 视图: v_tclass_avg_score
--- 功能：统计所有教学班的平均成绩和平均绩点。
---
CREATE OR REPLACE VIEW v_tclass_avg_score AS
SELECT
    htc.hyl_tcno10 AS tc_no,            -- 教学班编号
    htc.hyl_tcyear10 AS tc_year,         -- 学年
    htc.hyl_tcterm10 AS tc_term,         -- 学期
    htc.hyl_cno10 AS c_no,              -- 课程编号
    hc.hyl_cname10 AS c_name,           -- 课程名称
    h_tea.hyl_tname10 AS teacher_name,  -- 教师名称
    ROUND(AVG(hec.hyl_escore10), 2) AS avg_score, -- 平均分数
    ROUND(AVG(hec.calculated_gpa), 2) AS avg_gpa -- 平均绩点
FROM huyl_enroll10 hec_raw
         JOIN v_enrollment_calculated_gpa hec ON hec_raw.hyl_sno10 = hec.hyl_sno10 AND hec_raw.hyl_tcno10 = hec.hyl_tcno10 -- 使用包含计算绩点的辅助视图
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
         JOIN huyl_course10 hc ON htc.hyl_cno10 = hc.hyl_cno10
         LEFT JOIN huyl_teacher10 h_tea ON htc.hyl_tno10 = h_tea.hyl_tno10 -- 教师可能为空
WHERE hec.hyl_open10 = TRUE AND hec.hyl_escore10 IS NOT NULL -- 只统计已开放且有成绩的选课
GROUP BY htc.hyl_tcno10, htc.hyl_tcyear10, htc.hyl_tcterm10, htc.hyl_cno10, hc.hyl_cname10, h_tea.hyl_tname10
ORDER BY htc.hyl_tcyear10 DESC, htc.hyl_tcterm10 DESC, htc.hyl_tcno10;

-- 查询视图示例：
-- SELECT * FROM v_tclass_avg_score LIMIT 10;

---
--- 视图: v_course_semester_avg_score
--- 功能：统计所有课程每学期的平均分和平均绩点。
---
CREATE OR REPLACE VIEW v_course_semester_avg_score AS
SELECT
    htc.hyl_tcyear10 AS tc_year,         -- 学年
    htc.hyl_tcterm10 AS tc_term,         -- 学期
    htc.hyl_cno10 AS c_no,              -- 课程编号
    hc.hyl_cname10 AS c_name,           -- 课程名称
    ROUND(AVG(hec.hyl_escore10), 2) AS avg_score, -- 平均分数
    ROUND(AVG(hec.calculated_gpa), 2) AS avg_gpa -- 平均绩点
FROM huyl_enroll10 hec_raw
         JOIN v_enrollment_calculated_gpa hec ON hec_raw.hyl_sno10 = hec.hyl_sno10 AND hec_raw.hyl_tcno10 = hec.hyl_tcno10 -- 使用包含计算绩点的辅助视图
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
         JOIN huyl_course10 hc ON htc.hyl_cno10 = hc.hyl_cno10
WHERE hec.hyl_open10 = TRUE AND hec.hyl_escore10 IS NOT NULL -- 只统计已开放且有成绩的选课
GROUP BY htc.hyl_cno10, hc.hyl_cname10, htc.hyl_tcyear10, htc.hyl_tcterm10
ORDER BY htc.hyl_tcyear10 DESC, htc.hyl_tcterm10 DESC, hc.hyl_cname10;

-- 查询视图示例：
-- SELECT * FROM v_course_semester_avg_score LIMIT 10;

---
--- 视图: v_tclass_info10 (教学班详细信息)
--- 功能：展示教学班的学生选课详情，包括学生、课程、行政班和计算后的绩点。
---
CREATE OR REPLACE VIEW v_tclass_info10 AS
SELECT
    hs.hyl_sno10 AS s_no,             -- 学号
    hs.hyl_sname10 AS s_name,           -- 学生姓名
    hs.hyl_ssex10 AS s_sex,             -- 学生性别
    h_fac.hyl_fname10 AS faculty_name,  -- 学院名称
    hac.hyl_acname10 AS ac_name,        -- 行政班名称
    hec.hyl_escore10 AS score,          -- 成绩
    hec.calculated_gpa AS gpa,          -- 计算后的绩点
    htc.hyl_tcno10 AS tc_no,            -- 教学班编号
    htc.hyl_tcname10 AS tc_name,        -- 教学班名称
    hc.hyl_cno10 AS c_no,               -- 课程编号
    hc.hyl_cname10 AS c_name,           -- 课程名称
    hec.hyl_open10 AS open_status      -- 成绩开放状态
FROM v_enrollment_calculated_gpa hec -- 直接使用辅助视图
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
         JOIN huyl_student10 hs ON hec.hyl_sno10 = hs.hyl_sno10
         JOIN huyl_course10 hc ON htc.hyl_cno10 = hc.hyl_cno10
         JOIN huyl_aclass10 hac ON hac.hyl_acno10 = hs.hyl_acno10
         LEFT JOIN huyl_major10 h_maj ON hac.hyl_mno10 = h_maj.hyl_mno10
         LEFT JOIN huyl_faculty10 h_fac ON h_maj.hyl_fno10 = h_fac.hyl_fno10;

-- 查询视图示例：
-- SELECT * FROM v_tclass_info10 LIMIT 10;

---
--- 视图: v_teacher_class_scores (某教师所有教学班的成绩信息，内部已排序)
--- 功能：展示某教师所教授的教学班中，所有学生的详细成绩，并在视图内部按成绩降序排列。
---
CREATE OR REPLACE VIEW v_teacher_class_scores AS
SELECT
    htc.hyl_tcno10 AS tc_no,              -- 教学班编号
    htc.hyl_cno10 AS c_no,                -- 课程编号
    hc.hyl_cname10 AS c_name,             -- 课程名称
    hs.hyl_sno10 AS s_no,                 -- 学号
    hs.hyl_sname10 AS s_name,             -- 学生姓名
    hec.hyl_escore10 AS score,            -- 成绩
    hec.calculated_gpa AS gpa,            -- 计算后的绩点
    hec.hyl_open10 AS open_status,        -- 成绩开放状态
    ROW_NUMBER() OVER (PARTITION BY htc.hyl_tcno10, htc.hyl_cno10 ORDER BY hec.hyl_escore10 DESC, hs.hyl_sno10 ASC) AS rn_in_class -- 针对每个教学班和课程内部的成绩排名
FROM v_enrollment_calculated_gpa hec     -- 使用辅助视图
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
         JOIN huyl_student10 hs ON hec.hyl_sno10 = hs.hyl_sno10
         JOIN huyl_course10 hc ON htc.hyl_cno10 = hc.hyl_cno10
WHERE hec.hyl_escore10 IS NOT NULL; -- 只统计有成绩的记录

-- 查询某教师所有教学班的所有学生成绩信息，并按成绩降序排列示例：
-- SELECT tc_no, c_no, c_name, s_no, s_name, score, gpa, open_status
-- FROM v_teacher_class_scores
-- WHERE tc_no IN (
--   SELECT hyl_tcno10 FROM huyl_tclass10 WHERE hyl_tno10 = 70001 -- 替换为实际的教师编号
-- )
-- ORDER BY tc_no, c_no, rn_in_class;


---
--- 视图: v_student_overall_gpa (学生总绩点)
--- 功能：展示每个学生的总学分和总绩点。
---
CREATE OR REPLACE VIEW v_student_overall_gpa AS
SELECT
    hs.hyl_sno10 AS s_no,         -- 学号
    hs.hyl_sname10 AS s_name,       -- 学生姓名
    SUM(hec.hyl_ccredit10) AS total_credits, -- 总学分
    ROUND(SUM(hec.calculated_gpa * hec.hyl_ccredit10) / NULLIF(SUM(hec.hyl_ccredit10), 0), 2) AS overall_gpa -- 总绩点
FROM huyl_student10 hs
         JOIN v_enrollment_calculated_gpa hec ON hs.hyl_sno10 = hec.hyl_sno10
WHERE hec.hyl_open10 = TRUE AND hec.calculated_gpa IS NOT NULL -- 只统计已开放且有计算绩点的课程
GROUP BY hs.hyl_sno10, hs.hyl_sname10
ORDER BY hs.hyl_sno10;

-- 查询视图示例：
-- SELECT * FROM v_student_overall_gpa LIMIT 10;

---
--- 视图: v_student_semester_gpa (学生学期绩点)
--- 功能：展示每个学生在每个学期的总学分和学期绩点。
---
CREATE OR REPLACE VIEW v_student_semester_gpa AS
SELECT
    hs.hyl_sno10 AS s_no,         -- 学号
    hs.hyl_sname10 AS s_name,       -- 学生姓名
    htc.hyl_tcyear10 AS tc_year,     -- 学年
    htc.hyl_tcterm10 AS tc_term,     -- 学期
    SUM(hec.hyl_ccredit10) AS semester_credits, -- 学期总学分
    ROUND(SUM(hec.calculated_gpa * hec.hyl_ccredit10) / NULLIF(SUM(hec.hyl_ccredit10), 0), 2) AS semester_gpa -- 学期绩点
FROM huyl_student10 hs
         JOIN v_enrollment_calculated_gpa hec ON hs.hyl_sno10 = hec.hyl_sno10
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
WHERE hec.hyl_open10 = TRUE AND hec.calculated_gpa IS NOT NULL -- 只统计已开放且有计算绩点的课程
GROUP BY hs.hyl_sno10, hs.hyl_sname10, htc.hyl_tcyear10, htc.hyl_tcterm10
ORDER BY hs.hyl_sno10, htc.hyl_tcyear10, htc.hyl_tcterm10;

-- 查询视图示例：
-- SELECT * FROM v_student_semester_gpa LIMIT 10;

---
--- 视图: v_aclass_info10 (行政班详细信息)
--- 功能：展示行政班的基本信息及其所属学院。
---
CREATE OR REPLACE VIEW v_aclass_info10 AS
SELECT
    hac.hyl_acno10 AS ac_no,         -- 行政班编号
    hac.hyl_acname10 AS ac_name,       -- 行政班名称
    hmaj.hyl_mno10 AS major_no,        -- 专业编号
    hmaj.hyl_mname10 AS major_name,    -- 专业名称
    hfac.hyl_fno10 AS faculty_no,      -- 学院编号
    hfac.hyl_fname10 AS faculty_name   -- 学院名称
FROM huyl_aclass10 hac
         JOIN huyl_major10 hmaj ON hac.hyl_mno10 = hmaj.hyl_mno10
         JOIN huyl_faculty10 hfac ON hmaj.hyl_fno10 = hfac.hyl_fno10;

-- 查询视图示例：
-- SELECT * FROM v_aclass_info10 LIMIT 10;

-- ================== 3. 函数 (已更新) ==================
-- 登录表触发器
-- 自动添加学生用户
CREATE OR REPLACE FUNCTION insert_student_user()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO huyl_user10(hyl_uname10, hyl_upassword10, hyl_utype10)
    VALUES (
               CAST(NEW.hyl_sno10 AS VARCHAR), -- 将学号转换为VARCHAR作为用户名
               (CONCAT('zjut', NEW.hyl_sno10)), -- 使用 gs_encrypt_aes128 加密
               'student' -- 用户类型为 student
           ); -- 初始密码为zjut+学号，秘钥为Houchenyu@2024
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- 不加密的写法 CONCAT('zjut', NEW.hyl_sno10)

-- 触发器：自动添加学生用户
CREATE TRIGGER tr_insert_student_user -- 修正触发器名称以符合 huyl_ 命名和函数名
    AFTER INSERT ON huyl_student10
    FOR EACH ROW
EXECUTE PROCEDURE insert_student_user();

-- 自动添加教师用户
CREATE OR REPLACE FUNCTION insert_teacher_user()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO huyl_user10(hyl_uname10, hyl_upassword10, hyl_utype10)
    VALUES (
               CAST(NEW.hyl_tno10 AS VARCHAR), -- 将工号转换为VARCHAR作为用户名
               (CONCAT('zjut', NEW.hyl_tno10)), -- 使用 gs_encrypt_aes128 加密
               'teacher' -- 用户类型为 teacher
           ); -- 初始密码为zjut+工号，秘钥为Houchenyu@2024
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 触发器：自动添加教师用户
CREATE TRIGGER tr_insert_teacher_user -- 修正触发器名称以符合 huyl_ 命名和函数名
    AFTER INSERT ON huyl_teacher10
    FOR EACH ROW
EXECUTE PROCEDURE insert_teacher_user();

-- 自动删除学生用户
CREATE OR REPLACE FUNCTION delete_student_user()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM huyl_user10
    WHERE hyl_uname10 = CAST(OLD.hyl_sno10 AS VARCHAR); -- 将旧学号转换为VARCHAR进行匹配
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 触发器：自动删除学生用户
CREATE TRIGGER tr_delete_student_user -- 修正触发器名称以符合 huyl_ 命名和函数名
    AFTER DELETE ON huyl_student10
    FOR EACH ROW
EXECUTE PROCEDURE delete_student_user();

-- 自动删除教师用户
CREATE OR REPLACE FUNCTION delete_teacher_user()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM huyl_user10
    WHERE hyl_uname10 = CAST(OLD.hyl_tno10 AS VARCHAR); -- 将旧工号转换为VARCHAR进行匹配
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 触发器：自动删除教师用户
CREATE TRIGGER tr_delete_teacher_user -- 修正触发器名称以符合 huyl_ 命名和函数名
    AFTER DELETE ON huyl_teacher10
    FOR EACH ROW
EXECUTE PROCEDURE delete_teacher_user();


---
--- 函数: huyl_insert_student_user
--- 功能：在学生表插入新记录后，自动在用户表创建对应的学生用户。
--- 注意：密码加密方式 gs_encrypt_aes128 依赖 openGauss 的扩展函数。
--- 严重安全警告：在生产环境中，请勿使用简单连接字符串作为密钥，并考虑更强的哈希算法（如 bcrypt）。
---
CREATE OR REPLACE FUNCTION huyl_insert_student_user()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO huyl_user10(hyl_uname10, hyl_upassword10, hyl_utype10)
VALUES (CAST(NEW.hyl_sno10 AS VARCHAR), (CONCAT('zjut', NEW.hyl_sno10), 'Houchenyu@2024'), 'student'); -- 用户名为学号，类型为stu
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


---
--- 函数: huyl_insert_teacher_user
--- 功能：在教师表插入新记录后，自动在用户表创建对应的教师用户。
--- 安全警告同上。
---
--SET search_path TO "$user", public, pg_catalog; -- 确保包含 public 和 pg_catalog
CREATE OR REPLACE FUNCTION huyl_insert_teacher_user()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO huyl_user10(hyl_uname10, hyl_upassword10, hyl_utype10)
VALUES (CAST(NEW.hyl_tno10 AS VARCHAR), (CONCAT('zjut', NEW.hyl_tno10), 'Houchenyu@2024'), 'teacher'); -- 用户名为工号，类型为tea
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_delete_student_user
--- 功能：在学生表删除记录后，自动删除用户表中对应的学生用户。
---
CREATE OR REPLACE FUNCTION huyl_delete_student_user()
RETURNS TRIGGER AS $$
BEGIN
DELETE FROM huyl_user10
WHERE hyl_uname10 = CAST(OLD.hyl_sno10 AS VARCHAR);
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_delete_teacher_user
--- 功能：在教师表删除记录后，自动删除用户表中对应的教师用户。
---
CREATE OR REPLACE FUNCTION huyl_delete_teacher_user()
RETURNS TRIGGER AS $$
BEGIN
DELETE FROM huyl_user10
WHERE hyl_uname10 = CAST(OLD.hyl_tno10 AS VARCHAR);
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_auto_enroll_students
--- 功能：当默认排课信息新增或更新时，自动为行政班级的所有学生选上对应教学班。
--- 依赖：假设存在 huyl_default_scheduling10 表，其包含 hyl_acno10 和 hyl_tcno10 字段。
---
CREATE OR REPLACE FUNCTION huyl_auto_enroll_students()
RETURNS TRIGGER AS $$
DECLARE
current_ac_no INT;
    current_tc_no INT;
    student_record RECORD;
BEGIN
    current_ac_no := NEW.hyl_acno10; -- 假设默认排课表中有 hyl_acno10
    current_tc_no := NEW.hyl_tcno10; -- 假设默认排课表中有 hyl_tcno10

    -- 避免重复处理，仅当相关字段发生变化时
    IF TG_OP = 'UPDATE' AND OLD.hyl_acno10 = NEW.hyl_acno10 AND OLD.hyl_tcno10 = NEW.hyl_tcno10 THEN
        RETURN NEW;
END IF;

    -- 遍历该行政班的所有学生
FOR student_record IN
SELECT hyl_sno10 FROM huyl_student10 WHERE hyl_acno10 = current_ac_no
    LOOP
        -- 检查学生是否已经选了这门课，避免重复插入
        IF NOT EXISTS (SELECT 1 FROM huyl_enroll10 WHERE hyl_sno10 = student_record.hyl_sno10 AND hyl_tcno10 = current_tc_no) THEN
INSERT INTO huyl_enroll10(hyl_sno10, hyl_tcno10, hyl_escore10, hyl_egpa10, hyl_open10, hyl_enrolldate10, hyl_status10)
VALUES (student_record.hyl_sno10, current_tc_no, NULL, NULL, FALSE, CURRENT_TIMESTAMP, '正常');
END IF;
END LOOP;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_unenroll_students_on_schedule_change
--- 功能：当默认排课信息删除或更新时（行政班或教学班关联发生变化），自动为受影响的学生退选课程。
--- 依赖：假设存在 huyl_default_scheduling10 表。
---
CREATE OR REPLACE FUNCTION huyl_unenroll_students_on_schedule_change()
RETURNS TRIGGER AS $$
DECLARE
old_ac_no INT;
    old_tc_no INT;
    student_record RECORD;
BEGIN
    old_ac_no := OLD.hyl_acno10; -- 假设默认排课表中有 hyl_acno10
    old_tc_no := OLD.hyl_tcno10; -- 假设默认排课表中有 hyl_tcno10

    IF TG_OP = 'UPDATE' THEN
        -- 仅当行政班或教学班ID发生变化时才执行退选操作
        IF OLD.hyl_acno10 = NEW.hyl_acno10 AND OLD.hyl_tcno10 = NEW.hyl_tcno10 THEN
            RETURN NEW; -- 未发生变化，不执行退选
END IF;
END IF;

    -- 查询该行政班下原先选了该教学班的学生
FOR student_record IN
SELECT hs.hyl_sno10
FROM huyl_student10 hs
         JOIN huyl_enroll10 he ON hs.hyl_sno10 = he.hyl_sno10
WHERE hs.hyl_acno10 = old_ac_no AND he.hyl_tcno10 = old_tc_no
    LOOP
-- 删除学生的选课记录
DELETE FROM huyl_enroll10 WHERE hyl_sno10 = student_record.hyl_sno10 AND hyl_tcno10 = old_tc_no;
END LOOP;

RETURN OLD;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_calculate_enrollment_gpa
--- 功能：根据课程的百分制成绩，计算单条选课记录的 GPA，并更新到 huyl_enroll10 表的 hyl_egpa10 字段。
---
CREATE OR REPLACE FUNCTION huyl_calculate_enrollment_gpa() RETURNS TRIGGER AS $$
BEGIN
    -- 直接根据 NEW 记录中的成绩计算 GPA，避免在 BEFORE 触发器中查询正在被修改的表，从而引发 "no data found" 错误。
    IF NEW.hyl_escore10 IS NOT NULL THEN
        NEW.hyl_egpa10 := ROUND(
            CASE
                WHEN NEW.hyl_escore10 BETWEEN 60 AND 100 THEN (NEW.hyl_escore10 - 50) / 10.0
                ELSE 0.0
            END, 1
        );
    ELSE
        NEW.hyl_egpa10 := NULL; -- 如果成绩为空，绩点也为空
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_update_student_credit_on_open
--- 功能：当成绩开放查询时，如果成绩及格，更新学生的已修学分。
---
CREATE OR REPLACE FUNCTION huyl_update_student_credit_on_open() RETURNS TRIGGER AS $$
DECLARE
score INT;
    course_credit DECIMAL(3,1);
BEGIN
    score := NEW.hyl_escore10; -- 获取当前成绩

    -- 检查成绩是否及格 (这里假设及格线为60分)
    IF score >= 60 THEN
        -- 查询课程学分
SELECT hyl_ccredit10
INTO course_credit
FROM huyl_course10 hc
         JOIN huyl_tclass10 htc ON hc.hyl_cno10 = htc.hyl_cno10
WHERE htc.hyl_tcno10 = NEW.hyl_tcno10;

-- 更新学生已修学分
UPDATE huyl_student10
SET hyl_screditsum10 = COALESCE(hyl_screditsum10, 0) + course_credit
WHERE hyl_sno10 = NEW.hyl_sno10;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_update_student_credit_on_close
--- 功能：当成绩关闭查询时，如果原成绩及格，则减少学生的已修学分。
---
CREATE OR REPLACE FUNCTION huyl_update_student_credit_on_close() RETURNS TRIGGER AS $$
DECLARE
score INT;
    course_credit DECIMAL(3,1);
BEGIN
    score := OLD.hyl_escore10; -- 获取旧成绩

    -- 检查旧成绩是否及格 (这里假设及格线为60分)
    IF score >= 60 THEN
        -- 查询课程学分
SELECT hyl_ccredit10
INTO course_credit
FROM huyl_course10 hc
         JOIN huyl_tclass10 htc ON hc.hyl_cno10 = htc.hyl_cno10
WHERE htc.hyl_tcno10 = OLD.hyl_tcno10;

-- 更新学生已修学分
UPDATE huyl_student10
SET hyl_screditsum10 = GREATEST(COALESCE(hyl_screditsum10, 0) - course_credit, 0)
WHERE hyl_sno10 = OLD.hyl_sno10;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---
--- 函数: huyl_calc_student_gpa_overall
--- 功能：计算学生所有已开放查询课程的总体绩点。
---
CREATE OR REPLACE FUNCTION huyl_calc_student_gpa_overall(
    p_student_no INT -- 学生编号
) RETURNS FLOAT AS $$
DECLARE
total_gpa_weight FLOAT := 0; -- 绩点与学分乘积之和
    total_credits FLOAT := 0; -- 总学分
    result_gpa FLOAT; -- 最终计算出的总体绩点
BEGIN
    -- 计算每门课程的绩点*学分，并累加学分
SELECT
    COALESCE(SUM(hec.calculated_gpa * hec.hyl_ccredit10), 0),
    COALESCE(SUM(hec.hyl_ccredit10), 0)
INTO total_gpa_weight, total_credits
FROM v_enrollment_calculated_gpa hec
WHERE hec.hyl_sno10 = p_student_no
  AND hec.calculated_gpa IS NOT NULL
  AND hec.hyl_open10 = TRUE;

-- 防止除以零错误
IF total_credits > 0 THEN
        result_gpa := total_gpa_weight / total_credits;
ELSE
        result_gpa := NULL; -- 表示没有选课或没有有效绩点成绩
END IF;

RETURN ROUND(result_gpa, 2);
END;
$$ LANGUAGE plpgsql;

-- 实现示例：
-- SELECT huyl_calc_student_gpa_overall(600001);

---
--- 函数: huyl_calc_student_gpa_by_year
--- 功能：计算学生在某学年的绩点。
---
CREATE OR REPLACE FUNCTION huyl_calc_student_gpa_by_year(
    p_student_no INT, -- 学生编号
    p_year INT -- 学年标识
) RETURNS FLOAT AS $$
DECLARE
total_gpa_weight FLOAT := 0;
    total_credits FLOAT := 0;
    result_gpa FLOAT;
BEGIN
SELECT
    COALESCE(SUM(hec.calculated_gpa * hec.hyl_ccredit10), 0),
    COALESCE(SUM(hec.hyl_ccredit10), 0)
INTO total_gpa_weight, total_credits
FROM v_enrollment_calculated_gpa hec
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
WHERE hec.hyl_sno10 = p_student_no
  AND htc.hyl_tcyear10 = p_year
  AND hec.calculated_gpa IS NOT NULL
  AND hec.hyl_open10 = TRUE;

IF total_credits > 0 THEN
        result_gpa := total_gpa_weight / total_credits;
ELSE
        result_gpa := NULL;
END IF;

RETURN ROUND(result_gpa, 2);
END;
$$ LANGUAGE plpgsql;

-- 实现示例：
-- SELECT huyl_calc_student_gpa_by_year(600001, 2023);

---
--- 函数: huyl_calc_student_gpa_by_semester
--- 功能：计算学生在某学年某学期的绩点。
---
CREATE OR REPLACE FUNCTION huyl_calc_student_gpa_by_semester(
    p_student_no INT, -- 学生编号
    p_year INT, -- 学年标识
    p_semester INT -- 学期标识，例如 1, 2, 3
) RETURNS FLOAT AS $$
DECLARE
total_gpa_weight FLOAT := 0;
    total_credits FLOAT := 0;
    result_gpa FLOAT;
BEGIN
SELECT
    COALESCE(SUM(hec.calculated_gpa * hec.hyl_ccredit10), 0),
    COALESCE(SUM(hec.hyl_ccredit10), 0)
INTO total_gpa_weight, total_credits
FROM v_enrollment_calculated_gpa hec
         JOIN huyl_tclass10 htc ON hec.hyl_tcno10 = htc.hyl_tcno10
WHERE hec.hyl_sno10 = p_student_no
  AND htc.hyl_tcyear10 = p_year
  AND htc.hyl_tcterm10 = p_semester
  AND hec.calculated_gpa IS NOT NULL
  AND hec.hyl_open10 = TRUE;

IF total_credits > 0 THEN
        result_gpa := total_gpa_weight / total_credits;
ELSE
        result_gpa := NULL;
END IF;

RETURN ROUND(result_gpa, 2);
END;
$$ LANGUAGE plpgsql;

-- 实现示例：
-- SELECT huyl_calc_student_gpa_by_semester(600001, 2023, 1);

-- ================== 4. 触发器 (已更新) ==================

---
--- 触发器：自动添加学生用户
--- 绑定到 huyl_student10 表的 INSERT 操作。
---
CREATE TRIGGER tr_huyl_insert_student_user
    AFTER INSERT ON huyl_student10
    FOR EACH ROW
    EXECUTE PROCEDURE huyl_insert_student_user();

---
--- 触发器：自动添加教师用户
--- 绑定到 huyl_teacher10 表的 INSERT 操作。
---
CREATE TRIGGER tr_huyl_insert_teacher_user
    AFTER INSERT ON huyl_teacher10
    FOR EACH ROW
    EXECUTE PROCEDURE huyl_insert_teacher_user();

---
--- 触发器：自动删除学生用户
--- 绑定到 huyl_student10 表的 DELETE 操作。
---
CREATE TRIGGER tr_huyl_delete_student_user
    AFTER DELETE ON huyl_student10
    FOR EACH ROW
    EXECUTE PROCEDURE huyl_delete_student_user();

---
--- 触发器：自动删除教师用户
--- 绑定到 huyl_teacher10 表的 DELETE 操作。
---
CREATE TRIGGER tr_huyl_delete_teacher_user
    AFTER DELETE ON huyl_teacher10
    FOR EACH ROW
    EXECUTE PROCEDURE huyl_delete_teacher_user();

---
--- 触发器：自动选课（依赖 huyl_default_scheduling10 表，其结构需定义）
--- 绑定到 huyl_default_scheduling10 表的 INSERT 或 UPDATE 操作。
---
-- CREATE TRIGGER tr_huyl_auto_enroll_students
-- AFTER INSERT OR UPDATE OF hyl_acno10, hyl_tcno10 ON huyl_default_scheduling10 -- 假设有此表
-- FOR EACH ROW
-- EXECUTE PROCEDURE huyl_auto_enroll_students();

---
--- 触发器：计算单条选课绩点并更新 hyl_egpa10 字段
--- 绑定到 huyl_enroll10 表的 INSERT 或 UPDATE 操作。
---
CREATE TRIGGER tr_huyl_calculate_enrollment_gpa
    BEFORE INSERT OR UPDATE OF hyl_escore10, hyl_open10 ON huyl_enroll10 -- 当成绩或开放状态改变时触发
    FOR EACH ROW
    EXECUTE PROCEDURE huyl_calculate_enrollment_gpa();


---
--- 触发器：成绩开放查询时更新学生已修学分（加）
--- 绑定到 huyl_enroll10 表的 UPDATE 操作。
---
CREATE TRIGGER tr_huyl_update_student_credit_on_open
    AFTER UPDATE OF hyl_open10 ON huyl_enroll10
    FOR EACH ROW
    WHEN (NEW.hyl_open10 = TRUE AND OLD.hyl_open10 = FALSE AND NEW.hyl_escore10 IS NOT NULL) -- 仅当从关闭变为开放且有成绩时
    EXECUTE PROCEDURE huyl_update_student_credit_on_open();

---
--- 触发器：成绩关闭查询时更新学生已修学分（减）
--- 绑定到 huyl_enroll10 表的 UPDATE 操作。
---
CREATE TRIGGER tr_huyl_update_student_credit_on_close
    AFTER UPDATE OF hyl_open10 ON huyl_enroll10
    FOR EACH ROW
    WHEN (NEW.hyl_open10 = FALSE AND OLD.hyl_open10 = TRUE AND OLD.hyl_escore10 IS NOT NULL) -- 仅当从开放变为关闭且有成绩时
    EXECUTE PROCEDURE huyl_update_student_credit_on_close();

-- 备注：由于所有成绩均为百分制，原先的 'tr_huyl_prevent_clevel_change' 触发器已无必要，因此不再提供。
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


-- 3.10 触发器：自动生成用户密码 (安全性警告！)
CREATE TRIGGER tr_generate_user_password -- 命名更通用，因为是针对用户表
    BEFORE INSERT ON huyl_user10
    FOR EACH ROW EXECUTE PROCEDURE generate_student_password();


-- 3.11 触发器：级联删除学生相关记录 (已移除，由外键ON DELETE CASCADE处理)
-- 由于 huyl_enroll10 表的外键 FK_enroll10_sno10 已经设置了 ON DELETE CASCADE，
-- 当删除 huyl_student10 中的记录时，相关的 huyl_enroll10 记录会自动被数据库删除，
-- 无需额外的触发器。因此，此触发器被移除以避免冗余和潜在的性能开销。
-- DROP TRIGGER IF EXISTS tr_cascade_delete_student ON huyl_student10;

----------------------------------------------------------------------------------------------------------------

-- ================== 新增：统一的用户数据同步逻辑 ==================

-- 首先，清理所有旧的、重复的或命名不一致的用户同步函数和触发器
DROP TRIGGER IF EXISTS tr_generate_user_password ON huyl_user10 CASCADE;
DROP FUNCTION IF EXISTS generate_student_password() CASCADE;
DROP TRIGGER IF EXISTS tr_insert_student_user ON huyl_student10 CASCADE;
DROP FUNCTION IF EXISTS insert_student_user() CASCADE;
DROP TRIGGER IF EXISTS tr_insert_teacher_user ON huyl_teacher10 CASCADE;
DROP FUNCTION IF EXISTS insert_teacher_user() CASCADE;
DROP TRIGGER IF EXISTS tr_delete_student_user ON huyl_student10 CASCADE;
DROP FUNCTION IF EXISTS delete_student_user() CASCADE;
DROP TRIGGER IF EXISTS tr_delete_teacher_user ON huyl_teacher10 CASCADE;
DROP FUNCTION IF EXISTS delete_teacher_user() CASCADE;
DROP TRIGGER IF EXISTS tr_huyl_insert_student_user ON huyl_student10 CASCADE;
DROP FUNCTION IF EXISTS huyl_insert_student_user() CASCADE;
DROP TRIGGER IF EXISTS tr_huyl_insert_teacher_user ON huyl_teacher10 CASCADE;
DROP FUNCTION IF EXISTS huyl_insert_teacher_user() CASCADE;
DROP TRIGGER IF EXISTS tr_huyl_delete_student_user ON huyl_student10 CASCADE;
DROP FUNCTION IF EXISTS huyl_delete_student_user() CASCADE;
DROP TRIGGER IF EXISTS tr_huyl_delete_teacher_user ON huyl_teacher10 CASCADE;
DROP FUNCTION IF EXISTS huyl_delete_teacher_user() CASCADE;
DROP TRIGGER IF EXISTS tr_Teacher_Insert ON huyl_teacher10 CASCADE;
DROP FUNCTION IF EXISTS trig_CreateTeacherUser() CASCADE;
DROP TRIGGER IF EXISTS tr_Student_Insert ON huyl_student10 CASCADE;
DROP FUNCTION IF EXISTS trig_CreateStudentUser() CASCADE;

-- 函数：当新增学生时，在用户表创建对应记录
CREATE OR REPLACE FUNCTION sync_student_to_user_on_insert()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO huyl_user10 (hyl_uno10, hyl_uname10, hyl_upassword10, hyl_utype10, hyl_ucreated10, hyl_ulast_login10)
    VALUES (CAST(NEW.hyl_sno10 AS VARCHAR), CAST(NEW.hyl_sname10 AS VARCHAR), NEW.hyl_sno10, 'student', CURRENT_TIMESTAMP, NULL);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 触发器：学生表插入后触发
CREATE TRIGGER tr_sync_student_to_user_on_insert
    AFTER INSERT ON huyl_student10
    FOR EACH ROW
EXECUTE PROCEDURE sync_student_to_user_on_insert();

-- 函数：当删除学生时，在用户表删除对应记录
CREATE OR REPLACE FUNCTION sync_student_to_user_on_delete()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM huyl_user10 WHERE hyl_uname10 = CAST(OLD.hyl_sno10 AS VARCHAR);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 触发器：学生表删除后触发
CREATE TRIGGER tr_sync_student_to_user_on_delete
    AFTER DELETE ON huyl_student10
    FOR EACH ROW
EXECUTE PROCEDURE sync_student_to_user_on_delete();

-- 函数：当新增教师时，在用户表创建对应记录
CREATE OR REPLACE FUNCTION sync_teacher_to_user_on_insert()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO huyl_user10 (hyl_uno10, hyl_uname10, hyl_upassword10, hyl_utype10, hyl_ucreated10, hyl_ulast_login10)
    VALUES (CAST(NEW.hyl_tno10 AS VARCHAR), CAST(NEW.hyl_tname10 AS VARCHAR), NEW.hyl_tno10, 'teacher', CURRENT_TIMESTAMP, NULL);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 触发器：教师表插入后触发
CREATE TRIGGER tr_sync_teacher_to_user_on_insert
    AFTER INSERT ON huyl_teacher10
    FOR EACH ROW
EXECUTE PROCEDURE sync_teacher_to_user_on_insert();

-- 函数：当删除教师时，在用户表删除对应记录
CREATE OR REPLACE FUNCTION sync_teacher_to_user_on_delete()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM huyl_user10 WHERE hyl_uname10 = CAST(OLD.hyl_tno10 AS VARCHAR);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 触发器：教师表删除后触发
CREATE TRIGGER tr_sync_teacher_to_user_on_delete
    AFTER DELETE ON huyl_teacher10
    FOR EACH ROW
EXECUTE PROCEDURE sync_teacher_to_user_on_delete();

-- ================== 3. 插入丰富的测试数据 ==================
-- 插入管理员用户
INSERT INTO huyl_user10 (hyl_uno10, hyl_uname10, hyl_upassword10, hyl_utype10, hyl_ucreated10, hyl_ulast_login10)
VALUES ('100001', '管理员韩', '100001', 'admin', CURRENT_TIMESTAMP, NULL),
       ('100002', '管理员心', '100002', 'admin', CURRENT_TIMESTAMP, NULL),
       ('100003', '管理员邱', '100003', 'admin', CURRENT_TIMESTAMP, NULL);

-- 学生和教师用户将由触发器自动创建

-- 学院
INSERT INTO huyl_faculty10 (hyl_fname10, hyl_fdesc10, hyl_festablished10)
VALUES ('计算机学院', '专注于计算机科学与技术', '2000-09-01'),
       ('外国语学院', '外语教学与研究', '1998-09-01'),
       ('数学学院', '数学与应用数学', '2001-09-01'),
       ('物理学院', '物理学及其应用', '2002-09-01'),
       ('化学学院', '化学与分子科学', '2003-09-01'),
       ('经济管理学院', '经济与管理', '2004-09-01');

-- 专业
INSERT INTO huyl_major10 (hyl_mname10, hyl_mdegree10, hyl_myears10, hyl_fno10)
VALUES ('计算机科学与技术', '本科', 4, 800001),
       ('软件工程', '本科', 4, 800001),
       ('人工智能', '本科', 4, 800001),
       ('英语', '本科', 4, 800002),
       ('日语', '本科', 4, 800002),
       ('数学与应用数学', '本科', 4, 800003),
       ('信息与计算科学', '本科', 4, 800003),
       ('物理学', '本科', 4, 800004),
       ('应用物理学', '本科', 4, 800004),
       ('化学', '本科', 4, 800005),
       ('应用化学', '本科', 4, 800005),
       ('经济学', '本科', 4, 800006),
       ('工商管理', '本科', 4, 800006);

-- 行政班
INSERT INTO huyl_aclass10 (hyl_acname10, hyl_acyear10, hyl_acmaxstu10, hyl_mno10)
VALUES ('计科1班', 2022, 30, 200001),
       ('计科2班', 2022, 30, 200001),
       ('软工1班', 2022, 30, 200002),
       ('人工智能1班', 2022, 30, 200003),
       ('英语1班', 2022, 30, 200004),
       ('日语1班', 2022, 30, 200005),
       ('数学1班', 2022, 30, 200006),
       ('信计1班', 2022, 30, 200007),
       ('物理1班', 2022, 30, 200008),
       ('应物1班', 2022, 30, 200009),
       ('化学1班', 2022, 30, 200010),
       ('应化1班', 2022, 30, 200011),
       ('经济1班', 2022, 30, 200012),
       ('管理1班', 2022, 30, 200013);

-- 教师（10名，男女、职称、学院分布均衡）
INSERT INTO huyl_teacher10 (hyl_tage10, hyl_tname10, hyl_tbirth10, hyl_ttitle10, hyl_tsex10, hyl_temail10,
                            hyl_toffice10, hyl_tphone10, hyl_tjoindate10, hyl_tstatus10, hyl_fno10)
VALUES (35, '张教授', '1988-01-01', '教授', '男', 'zhang@univ.edu', 'A101', '13800000001', '2015-09-01', '在职',
        800001),
       (40, '李老师', '1983-05-12', '副教授', '女', 'li@univ.edu', 'A102', '13800000002', '2010-09-01', '在职', 800001),
       (30, '王老师', '1993-03-15', '讲师', '男', 'wang@univ.edu', 'B201', '13800000003', '2018-09-01', '在职', 800002),
       (45, '赵教授', '1978-07-20', '教授', '女', 'zhao@univ.edu', 'C301', '13800000004', '2005-09-01', '在职', 800003),
       (38, '钱老师', '1985-11-11', '副教授', '男', 'qian@univ.edu', 'D401', '13800000005', '2012-09-01', '在职',
        800004),
       (32, '孙老师', '1991-04-18', '讲师', '女', 'sun@univ.edu', 'E501', '13800000006', '2017-09-01', '在职', 800005),
       (50, '周教授', '1973-09-09', '教授', '男', 'zhou@univ.edu', 'F601', '13800000007', '2000-09-01', '在职', 800006),
       (29, '吴老师', '1994-12-12', '助教', '女', 'wu@univ.edu', 'G701', '13800000008', '2021-09-01', '在职', 800001),
       (36, '郑老师', '1987-06-06', '讲师', '男', 'zheng@univ.edu', 'H801', '13800000009', '2014-09-01', '在职',
        800002),
       (41, '冯老师', '1982-03-03', '副教授', '女', 'feng@univ.edu', 'I901', '13800000010', '2009-09-01', '在职',
        800003);

-- 课程（10门，覆盖各学院）
INSERT INTO huyl_course10 (hyl_cname10, hyl_ccredit10, hyl_chour10, hyl_ctest10, hyl_ctype10, hyl_cprereq10,
                           hyl_cdesc10)
VALUES ('数据库原理', 3.0, 48, '考试', '必修课', NULL, '数据库基础知识'),
       ('操作系统', 3.0, 48, '考试', '必修课', NULL, '操作系统原理'),
       ('英语写作', 2.0, 32, '考查', '通识课', NULL, '英语写作能力培养'),
       ('高等数学', 4.0, 64, '考试', '必修课', NULL, '数学基础'),
       ('大学物理', 3.5, 56, '考试', '必修课', NULL, '物理基础'),
       ('C语言程序设计', 2.5, 40, '考试', '必修课', NULL, '编程基础'),
       ('线性代数', 3.0, 48, '考试', '必修课', NULL, '线性代数基础'),
       ('微观经济学', 3.0, 48, '考试', '必修课', NULL, '经济学基础'),
       ('管理学原理', 2.5, 40, '考试', '必修课', NULL, '管理学基础'),
       ('有机化学', 3.0, 48, '考试', '必修课', NULL, '有机化学基础');

-- 教学班（每门课程1-2个班）
INSERT INTO huyl_tclass10 (hyl_tcname10, hyl_tcyear10, hyl_tcterm10, hyl_tcrepeat10, hyl_tcbatch10, hyl_tcmaxstu10,
                           hyl_tccurstu10, hyl_cno10, hyl_tno10)
VALUES ('数据库原理-1班', 2023, 1, '非重修班', '01', 50, 0, 400001, 700001),
       ('数据库原理-2班', 2023, 2, '非重修班', '01', 50, 0, 400001, 700002),
       ('操作系统-1班', 2023, 1, '非重修班', '01', 50, 0, 400002, 700002),
       ('英语写作-1班', 2023, 1, '非重修班', '01', 50, 0, 400003, 700003),
       ('高等数学-1班', 2023, 1, '非重修班', '01', 50, 0, 400004, 700004),
       ('大学物理-1班', 2023, 1, '非重修班', '01', 50, 0, 400005, 700005),
       ('C语言程序设计-1班', 2023, 2, '非重修班', '01', 50, 0, 400006, 700001),
       ('线性代数-1班', 2023, 2, '非重修班', '01', 50, 0, 400007, 700004),
       ('微观经济学-1班', 2023, 1, '非重修班', '01', 50, 0, 400008, 700007),
       ('管理学原理-1班', 2023, 2, '非重修班', '01', 50, 0, 400009, 700007),
       ('有机化学-1班', 2023, 1, '非重修班', '01', 50, 0, 400010, 700006);

-- 学生（20名，分布不同专业、班级、性别、地区）
INSERT INTO huyl_student10 (hyl_sage10, hyl_sname10, hyl_sbirth10, hyl_splace10, hyl_ssex10, hyl_screditsum10,
                            hyl_semail10, hyl_sphone10, hyl_senrolldate10, hyl_sstatus10, hyl_sgpa10, hyl_srank10,
                            hyl_mno10, hyl_acno10)
VALUES (20, '小明', '2003-05-01', '北京', '男', 0, 'xiaoming@univ.edu', '13900000001', '2022-09-01', '在读', 0, 0,
        200001, 300001),
       (21, '小红', '2002-08-12', '上海', '女', 0, 'xiaohong@univ.edu', '13900000002', '2022-09-01', '在读', 0, 0,
        200001, 300001),
       (22, '小刚', '2001-11-23', '广州', '男', 0, 'xiaogang@univ.edu', '13900000003', '2022-09-01', '在读', 0, 0,
        200003, 300004),
       (19, '李雷', '2004-02-14', '深圳', '男', 0, 'lilei@univ.edu', '13900000004', '2023-09-01', '在读', 0, 0, 200002,
        300003),
       (20, '韩梅梅', '2003-07-21', '南京', '女', 0, 'hanmeimei@univ.edu', '13900000005', '2022-09-01', '在读', 0, 0,
        200001, 300001),
       (21, '王芳', '2002-10-10', '成都', '女', 0, 'wangfang@univ.edu', '13900000006', '2022-09-01', '在读', 0, 0,
        200003, 300004),
       (22, '赵强', '2001-12-12', '重庆', '男', 0, 'zhaoqiang@univ.edu', '13900000007', '2022-09-01', '在读', 0, 0,
        200004, 300005),
       (20, '孙丽', '2003-03-03', '武汉', '女', 0, 'sunli@univ.edu', '13900000008', '2022-09-01', '在读', 0, 0, 200005,
        300006),
       (21, '陈晨', '2002-06-06', '西安', '男', 0, 'chenchen@univ.edu', '13900000009', '2022-09-01', '在读', 0, 0,
        200006, 300007),
       (22, '林林', '2001-09-09', '杭州', '女', 0, 'linlin@univ.edu', '13900000010', '2022-09-01', '在读', 0, 0,
        200007, 300008),
       (20, '周舟', '2003-11-11', '苏州', '男', 0, 'zhouzhou@univ.edu', '13900000011', '2022-09-01', '在读', 0, 0,
        200008, 300009),
       (21, '吴伟', '2002-04-04', '青岛', '男', 0, 'wuwei@univ.edu', '13900000012', '2022-09-01', '在读', 0, 0,
        200009, 300010),
       (22, '郑真', '2001-07-07', '大连', '女', 0, 'zhengzhen@univ.edu', '13900000013', '2022-09-01', '在读', 0, 0,
        200010, 300011),
       (20, '冯峰', '2003-08-08', '合肥', '男', 0, 'fengfeng@univ.edu', '13900000014', '2022-09-01', '在读', 0, 0,
        200011, 300012),
       (21, '褚楚', '2002-03-03', '南昌', '女', 0, 'zhuchu@univ.edu', '13900000015', '2022-09-01', '在读', 0, 0, 200012,
        300013),
       (22, '卫伟', '2001-05-05', '厦门', '男', 0, 'weiwei@univ.edu', '13900000016', '2022-09-01', '在读', 0, 0,
        200013, 300014),
       (20, '蒋静', '2003-12-12', '天津', '女', 0, 'jiangjing@univ.edu', '13900000017', '2022-09-01', '在读', 0, 0,
        200001, 300001),
       (21, '沈深', '2002-01-01', '深圳', '男', 0, 'shenshen@univ.edu', '13900000018', '2022-09-01', '在读', 0, 0,
        200002, 300003),
       (22, '韩寒', '2001-02-02', '哈尔滨', '女', 0, 'hanhan@univ.edu', '13900000019', '2022-09-01', '在读', 0, 0,
        200003, 300004),
       (20, '吕律', '2003-03-03', '兰州', '男', 0, 'lvlu@univ.edu', '13900000020', '2022-09-01', '在读', 0, 0, 200004,
        300005);

-- 上课时间地点
INSERT INTO huyl_venue10 (hyl_tplace10, hyl_tstime10, hyl_tetime10, hyl_tweekday10, hyl_tweeks10, hyl_tcno10)
VALUES ('教一-101', '08:00', '09:40', 1, '1-16周', 500001),
       ('教一-102', '10:00', '11:40', 3, '1-16周', 500002),
       ('教二-201', '14:00', '15:40', 5, '1-16周', 500003);

-- 选课
INSERT INTO huyl_enroll10 (hyl_escore10, hyl_egpa10, hyl_open10, hyl_enrolldate10, hyl_status10, hyl_tcno10, hyl_sno10)
VALUES (85, 4.0, true, now(), '正常', 500001, 600001),
       (90, 4.5, true, now(), '正常', 500002, 600002),
       (78, 3.5, true, now(), '正常', 500003, 600003);

-- 培养方案
INSERT INTO huyl_cultivate10 (hyl_mno10, hyl_cno10, hyl_cterm10, hyl_cmandatory10)
VALUES (200001, 400001, 3, true),
       (200001, 400002, 4, true),
       (200003, 400003, 2, true);
