-- 序列定义
-- 删除已存在的序列和表(如果存在)
DROP SEQUENCE IF EXISTS user_seq CASCADE;
DROP SEQUENCE IF EXISTS major_seq CASCADE;
DROP SEQUENCE IF EXISTS administrative_class_seq CASCADE;
DROP SEQUENCE IF EXISTS course_seq CASCADE;
DROP SEQUENCE IF EXISTS teaching_class_seq CASCADE;
DROP SEQUENCE IF EXISTS student_seq CASCADE;
DROP SEQUENCE IF EXISTS teacher_seq CASCADE;
DROP SEQUENCE IF EXISTS faculty_seq CASCADE;
DROP SEQUENCE IF EXISTS cultivate_seq CASCADE;

-- 删除已存在的表(如果存在) - 按依赖关系顺序删除
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
DROP TABLE IF EXISTS huyl_user10 CASCADE;

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
    hyl_uno10 INT DEFAULT nextval('user_seq') PRIMARY KEY,
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
CREATE INDEX idx_student_aclass ON huyl_student10(hyl_acno10);
CREATE INDEX idx_student_major ON huyl_student10(hyl_mno10);
CREATE INDEX idx_student_status ON huyl_student10(hyl_sstatus10);
CREATE INDEX idx_tclass_course ON huyl_tclass10(hyl_cno10);
CREATE INDEX idx_tclass_teacher ON huyl_tclass10(hyl_tno10);
CREATE INDEX idx_tclass_year_term ON huyl_tclass10(hyl_tcyear10, hyl_tcterm10);
CREATE INDEX idx_enroll_student ON huyl_enroll10(hyl_sno10);
CREATE INDEX idx_enroll_tclass ON huyl_enroll10(hyl_tcno10);
CREATE INDEX idx_enroll_score ON huyl_enroll10(hyl_escore10);
CREATE INDEX idx_enroll_status ON huyl_enroll10(hyl_status10);
CREATE INDEX idx_major_faculty ON huyl_major10(hyl_fno10);
CREATE INDEX idx_teacher_faculty ON huyl_teacher10(hyl_fno10);
CREATE INDEX idx_teacher_status ON huyl_teacher10(hyl_tstatus10);
CREATE INDEX idx_venue_time ON huyl_venue10(hyl_tstime10, hyl_tweekday10);

--------------------------------------------------------------------------------------------------------------------------
--1创建视图
-- 1. 学生成绩查询视图
-- 功能：综合查询学生的详细成绩信息
-- 包括：学号、学生姓名、课程名称、成绩、任课教师、学年、学期
CREATE VIEW v_student_scores AS
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
JOIN huyl_teacher10 t ON t.hyl_tno10 = tc.hyl_tno10;

-- 2. 学生每学年成绩统计视图
-- 功能：统计每个学生每学年的平均成绩
-- 用途：年度成绩分析、学业表现趋势跟踪
CREATE VIEW v_student_yearly_scores AS
SELECT
    s.hyl_sno10 AS student_id,           -- 学号
    s.hyl_sname10 AS student_name,       -- 学生姓名
    tc.hyl_tcyear10 AS year,             -- 学年
    ROUND(AVG(e.hyl_escore10), 2) AS avg_score  -- 平均成绩（保留2位小数）
FROM huyl_enroll10 e
JOIN huyl_student10 s ON s.hyl_sno10 = e.hyl_sno10
JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
GROUP BY s.hyl_sno10, s.hyl_sname10, tc.hyl_tcyear10
ORDER BY s.hyl_sno10, tc.hyl_tcyear10;

-- 3. 课程平均成绩统计视图
-- 功能：统计每门课程的整体平均成绩
-- 用途：课程难度分析、教学质量评估
CREATE VIEW v_course_avg_scores AS
SELECT
    c.hyl_cno10 AS course_id,            -- 课程编号
    c.hyl_cname10 AS course_name,        -- 课程名称
    ROUND(AVG(e.hyl_escore10), 2) AS avg_score,  -- 平均成绩
    COUNT(e.hyl_sno10) AS student_count   -- 选课学生数量
FROM huyl_enroll10 e
         JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
         JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
GROUP BY c.hyl_cno10, c.hyl_cname10
ORDER BY avg_score DESC;

-- 4. 学生课程及学分统计视图
-- 功能：展示学生选修的所有课程及对应学分
-- 用途：学分统计、毕业审核
CREATE VIEW v_student_courses AS
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

-- 5. 教师任课查询视图
-- 功能：查询教师的详细任课信息
-- 包括：教师信息、课程信息、时间地点等
CREATE VIEW v_teacher_courses AS
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
JOIN huyl_venue10 v ON tc.hyl_tcno10 = v.hyl_tcno10
ORDER BY t.hyl_tno10, tc.hyl_tcyear10, tc.hyl_tcterm10;

-- =============================================
-- 视图使用示例查询
-- =============================================

-- 示例1: 查询特定学生的所有成绩
-- SELECT * FROM v_student_scores WHERE student_id = '20240001';

-- 示例2: 查询2024年所有学生的平均成绩
-- SELECT * FROM v_student_yearly_scores WHERE year = '2024' ORDER BY avg_score DESC;

-- 示例3: 查询平均成绩最高的前10门课程
-- SELECT * FROM v_course_avg_scores LIMIT 10;

-- 示例4: 统计学生总学分
-- SELECT student_id, student_name, SUM(course_credit) as total_credits
-- FROM v_student_courses GROUP BY student_id, student_name;

-- 示例5: 查询特定教师的任课安排
-- SELECT * FROM v_teacher_courses WHERE teacher_name = '张教授';

--1.6班级课程开设查询视图
--该视图查询某班级的课程开设情况。
CREATE VIEW v_class_courses AS
SELECT
    ac.hyl_acno10 AS class_id,
    c.hyl_cname10 AS course_name,
    t.hyl_tname10 AS teacher_name,
    tc.hyl_tcyear10 AS year,
    tc.hyl_tcterm10 AS term
FROM
    huyl_aclass10 ac
JOIN huyl_student10 s ON ac.hyl_acno10 = s.hyl_acno10
JOIN huyl_enroll10 e on s.hyl_sno10 = e.hyl_sno10
JOIN huyl_tclass10 tc on e.hyl_tcno10 = tc.hyl_tcno10
JOIN huyl_course10 c on tc.hyl_cno10 = c.hyl_cno10
JOIN huyl_teacher10 t on tc.hyl_tno10 = t.hyl_tno10
WHERE ac.hyl_acno10=s.hyl_acno10;

--1.7
-- 创建学生姓名的模糊查询视图
CREATE VIEW v_student_name_search AS
SELECT
    s.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name,
    s.hyl_splace10 AS student_place
FROM huyl_student10 s
WHERE s.hyl_sname10 ILIKE '%' || :search_term || '%';

--1.8
-- 创建课程名称的模糊查询视图
CREATE VIEW v_course_name_search AS
SELECT
    c.hyl_cno10 AS course_id,
    c.hyl_cname10 AS course_name,
    c.hyl_ccredit10 AS course_credit
FROM huyl_course10 c
WHERE c.hyl_cname10 ILIKE '%' || :search_term || '%';

--1.9
-- 创建教师姓名的模糊查询视图
CREATE VIEW v_teacher_name_search AS
SELECT
    t.hyl_tno10 AS teacher_id,
    t.hyl_tname10 AS teacher_name,
    t.hyl_ttitle10 AS teacher_title
FROM huyl_teacher10 t
WHERE t.hyl_tname10 ILIKE '%' || :search_term || '%';

--1.10
-- 通过学号或课程名称模糊匹配查询成绩
CREATE VIEW v_student_score_search AS
SELECT
    e.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name,
    c.hyl_cname10 AS course_name,
    e.hyl_escore10 AS score
FROM huyl_enroll10 e
         JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10
         JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
         JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
WHERE s.hyl_sno10::TEXT ILIKE '%' || :search_term || '%'
   OR c.hyl_cname10 ILIKE '%' || :search_term || '%';

--1.11
-- 课程名称下拉选项
CREATE VIEW v_course_dropdown AS
SELECT
    c.hyl_cno10 AS course_id,
    c.hyl_cname10 AS course_name
FROM huyl_course10 c;

--1.12
-- 学生姓名下拉选项
CREATE VIEW v_student_dropdown AS
SELECT
    s.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name
FROM huyl_student10 s;

--1.13
-- 教师姓名下拉选项
CREATE VIEW v_teacher_dropdown AS
SELECT
    t.hyl_tno10 AS teacher_id,
    t.hyl_tname10 AS teacher_name
FROM huyl_teacher10 t;

--1.14
-- 班级名称下拉选项
CREATE VIEW v_class_dropdown AS
SELECT
    ac.hyl_acno10 AS class_id,
    ac.hyl_acname10 AS class_name
FROM huyl_aclass10 ac;

--1.15
-- 专业名称下拉选项
CREATE VIEW v_major_dropdown AS
SELECT
    m.hyl_mno10 AS major_id,
    m.hyl_mname10 AS major_name
FROM huyl_major10 m;

--
-- 加权模糊搜索：按姓名和学号的匹配程度排序
CREATE VIEW v_student_search_with_weight AS
SELECT
    s.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name,
    CASE
        WHEN s.hyl_sname10 ILIKE '%' || :search_term || '%' THEN 2
        WHEN s.hyl_sno10::TEXT ILIKE '%' || :search_term || '%' THEN 1
        ELSE 0
        END AS weight
FROM huyl_student10 s
WHERE s.hyl_sname10 ILIKE '%' || :search_term || '%'
   OR s.hyl_sno10::TEXT ILIKE '%' || :search_term || '%'
ORDER BY weight DESC;

-- 课程自动补全查询
CREATE VIEW v_course_auto_complete AS
SELECT
    c.hyl_cname10 AS course_name
FROM huyl_course10 c
WHERE c.hyl_cname10 ILIKE :search_term || '%';

-- 学生自动补全查询
CREATE VIEW v_student_auto_complete AS
SELECT
    s.hyl_sno10 AS student_id,
    s.hyl_sname10 AS student_name
FROM huyl_student10 s
WHERE s.hyl_sname10 ILIKE :search_term || '%'
   OR s.hyl_sno10::TEXT ILIKE :search_term || '%';


-------------------------------------------------------------------------------------------------
-- 2.1 支持学生成绩查询视图 (v_student_scores) 的索引
-- 原视图查询: student_id, year, term
--可以在检索时利用索引同时按 hyl_escore10 进行排序
CREATE INDEX idx_enroll_student_performance ON huyl_enroll10(hyl_sno10, hyl_escore10);
CREATE INDEX idx_tclass_year_term ON huyl_tclass10(hyl_tcyear10, hyl_tcterm10, hyl_cno10);
CREATE INDEX idx_student_name_lookup ON huyl_student10(hyl_sno10, hyl_sname10);

-- 2.2 支持教师任课查询视图 (v_teacher_courses) 的索引
-- 原视图查询: teacher_id, year, term
CREATE INDEX idx_tclass_teacher_schedule ON huyl_tclass10(hyl_tno10, hyl_tcyear10, hyl_tcterm10);
CREATE INDEX idx_teacher_name_lookup ON huyl_teacher10(hyl_tno10, hyl_tname10);
CREATE INDEX idx_venue_tclass_time ON huyl_venue10(hyl_tcno10, hyl_tweekday10, hyl_tstime10,hyl_tetime10);

-- 2.3 支持班级课程查询视图 (v_class_courses) 的索引
-- 原视图查询: class_id, year, term
CREATE INDEX idx_student_aclass_lookup ON huyl_student10(hyl_acno10, hyl_sno10);
CREATE INDEX idx_aclass_name_lookup ON huyl_aclass10(hyl_acno10, hyl_acname10);

-- 2.4 支持课程平均成绩视图 (v_course_avg_scores) 的索引
-- 原视图查询: course_name
CREATE INDEX idx_course_name_lookup ON huyl_course10(hyl_cname10, hyl_cno10);
CREATE INDEX idx_enroll_score_calc ON huyl_enroll10(hyl_tcno10, hyl_escore10);

-- 2.5 支持学生年度成绩视图 (v_student_yearly_scores) 的索引
-- 原视图查询: student_id, year
CREATE INDEX idx_student_yearly_performance ON huyl_enroll10(hyl_sno10);
-- 复用已创建的: idx_tclass_year_term

-- 2.6 支持学生课程视图 (v_student_courses) 的索引
-- 原视图查询: student_id
CREATE INDEX idx_enroll_student_courses ON huyl_enroll10(hyl_sno10, hyl_tcno10);
CREATE INDEX idx_course_credit_lookup ON huyl_course10(hyl_cno10, hyl_cname10, hyl_ccredit10);

-- 2.7 额外的性能优化索引
-- 优化JOIN操作
CREATE INDEX idx_tclass_course_teacher ON huyl_tclass10(hyl_cno10, hyl_tno10);
CREATE INDEX idx_student_enroll_lookup ON huyl_student10(hyl_sno10, hyl_acno10);

-- 优化常用查询条件
CREATE INDEX idx_student_status ON huyl_student10(hyl_sstatus10) WHERE hyl_sstatus10 = '在读';
CREATE INDEX idx_teacher_status ON huyl_teacher10(hyl_tstatus10) WHERE hyl_tstatus10 = '在职';
CREATE INDEX idx_enroll_status ON huyl_enroll10(hyl_status10) WHERE hyl_status10 = '正常';

-- 优化时间相关查询
CREATE INDEX idx_tclass_current_term ON huyl_tclass10(hyl_tcyear10, hyl_tcterm10)
    WHERE hyl_tcyear10 >= EXTRACT(YEAR FROM CURRENT_DATE) - 1;

-- --2创建索引
-- CREATE INDEX idx_student_scores
--     ON v_student_scores(student_id,year,term);
-- CREATE INDEX idx_teacher_courses
--     ON v_teacher_courses(teacher_id,year,term);
-- CREATE INDEX idx_class_courses
--     ON v_class_courses(class_id,year,term);
-- CREATE INDEX idx_course_avg_scores
--     ON v_course_avg_scores(course_name);
-- CREATE INDEX idx_student_yearly_scores
--     ON v_student_yearly_scores(student_id);
-- CREATE INDEX idx_student_courses
--     ON v_student_courses (student_id);
-------------------------------------------------------------------------------------------------

-- 确保学生的专业与行政班专业一致的触发器或约束
CREATE OR REPLACE FUNCTION check_student_major_consistency()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM huyl_aclass10 ac
        WHERE ac.hyl_acno10 = NEW.hyl_acno10
          AND ac.hyl_mno10 = NEW.hyl_mno10
    ) THEN
        RAISE EXCEPTION '学生专业与行政班专业不匹配';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--3创建触发器
--3.1自动更新学生已修学分
--在学生插入或更新成绩时，自动更新其已修学分
-- CREATE OR REPLACE FUNCTION update_student_credits()
--     RETURNS TRIGGER AS $$
-- DECLARE
--     course_credit DECIMAL(3,1);
--     student_id INT;
-- BEGIN
--     IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
--         student_id := NEW.hyl_sno10;
--
--         -- 获取课程学分
--         SELECT c.hyl_ccredit10 INTO course_credit
--         FROM huyl_course10 c
--                  JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
--         WHERE tc.hyl_tcno10 = NEW.hyl_tcno10;
--
--         -- 当成绩及格时（>=60），更新学分
--         IF NEW.hyl_escore10 IS NOT NULL AND NEW.hyl_escore10 >= 60 THEN
--             -- 检查是否是首次及格（避免重复计算学分）
--             IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.hyl_escore10 IS NULL OR OLD.hyl_escore10 < 60)) THEN
--                 UPDATE huyl_student10
--                 SET hyl_screditsum10 = hyl_screditsum10 + course_credit
--                 WHERE hyl_sno10 = student_id;
--             END IF;
--             -- 当成绩从及格变为不及格时，减少学分
--         ELSIF TG_OP = 'UPDATE' AND OLD.hyl_escore10 IS NOT NULL AND OLD.hyl_escore10 >= 60
--             AND (NEW.hyl_escore10 IS NULL OR NEW.hyl_escore10 < 60) THEN
--             UPDATE huyl_student10
--             SET hyl_screditsum10 = hyl_screditsum10 - course_credit
--             WHERE hyl_sno10 = student_id;
--         END IF;
--
--         RETURN NEW;
--     ELSIF TG_OP = 'DELETE' THEN
--         student_id := OLD.hyl_sno10;
--
--         -- 删除选课记录时，如果之前及格则减少学分
--         IF OLD.hyl_escore10 IS NOT NULL AND OLD.hyl_escore10 >= 60 THEN
--             SELECT c.hyl_ccredit10 INTO course_credit
--             FROM huyl_course10 c
--                      JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
--             WHERE tc.hyl_tcno10 = OLD.hyl_tcno10;
--
--             UPDATE huyl_student10
--             SET hyl_screditsum10 = hyl_screditsum10 - course_credit
--             WHERE hyl_sno10 = student_id;
--         END IF;
--
--         RETURN OLD;
--     END IF;
--
--     RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_student_credits()
    RETURNS TRIGGER AS $$
DECLARE
    course_credit DECIMAL(3,1);
    student_id INT;
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        student_id := NEW.hyl_sno10;

        -- 获取课程学分
        SELECT c.hyl_ccredit10 INTO course_credit
        FROM huyl_course10 c
                 JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
        WHERE tc.hyl_tcno10 = NEW.hyl_tcno10;

        -- 检查是否找到课程学分
        IF course_credit IS NULL THEN
            RAISE EXCEPTION '无法找到教学班 % 对应的课程学分', NEW.hyl_tcno10;
        END IF;

        -- 当成绩及格时（>=60），更新学分
        -- 学分只增不减：一旦获得学分就永久保持
        IF NEW.hyl_escore10 IS NOT NULL AND NEW.hyl_escore10 >= 60 THEN
            -- 检查是否是首次及格（避免重复计算学分）
            IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.hyl_escore10 IS NULL OR OLD.hyl_escore10 < 60)) THEN
                UPDATE huyl_student10
                SET hyl_screditsum10 = COALESCE(hyl_screditsum10, 0) + course_credit
                WHERE hyl_sno10 = student_id;
            END IF;
        END IF;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        student_id := OLD.hyl_sno10;

        -- 删除选课记录时，如果之前及格则减少学分
        -- 这里保留删除逻辑，因为删除选课记录意味着完全撤销该课程
        IF OLD.hyl_escore10 IS NOT NULL AND OLD.hyl_escore10 >= 60 THEN
            SELECT c.hyl_ccredit10 INTO course_credit
            FROM huyl_course10 c
                     JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10
            WHERE tc.hyl_tcno10 = OLD.hyl_tcno10;

            IF course_credit IS NOT NULL THEN
                UPDATE huyl_student10
                SET hyl_screditsum10 = GREATEST(COALESCE(hyl_screditsum10, 0) - course_credit, 0)
                WHERE hyl_sno10 = student_id;
            END IF;
        END IF;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER tr_update_student_credits
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10
    FOR EACH ROW EXECUTE FUNCTION update_student_credits();

--3.2自动更新教学班当前学生数
--当学生选课或退课时，自动更新教学班的当前学生数
CREATE OR REPLACE FUNCTION update_tclass_student_count()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE huyl_tclass10
        SET hyl_tccurstu10 = hyl_tccurstu10 + 1
        WHERE hyl_tcno10 = NEW.hyl_tcno10;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE huyl_tclass10
        SET hyl_tccurstu10 = hyl_tccurstu10 - 1
        WHERE hyl_tcno10 = OLD.hyl_tcno10;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER tr_update_tclass_count
    AFTER INSERT OR DELETE ON huyl_enroll10
    FOR EACH ROW EXECUTE FUNCTION update_tclass_student_count();

--3.3自动更新学生的状态（如"毕业"）
--当学生的所有课程成绩都及格，并且修满了所有学分时，自动将学生的状态设置为"毕业"
CREATE OR REPLACE FUNCTION update_student_status_on_graduation()
    RETURNS TRIGGER AS $$
DECLARE
    total_credits DECIMAL(5,1);
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.hyl_escore10 >= 60 THEN
        -- 获取该学生的所有学分
        SELECT SUM(c.hyl_ccredit10) INTO total_credits
        FROM huyl_enroll10 e
                 JOIN huyl_course10 c ON e.hyl_tcno10 = c.hyl_cno10
        WHERE e.hyl_sno10 = NEW.hyl_sno10 AND e.hyl_escore10 >= 60;

        -- 检查是否修满学分，且所有课程及格，若符合条件则更新学生状态为"毕业"
        IF total_credits >= 120 THEN -- 假设120学分为毕业要求
            UPDATE huyl_student10
            SET hyl_sstatus10 = '毕业'
            WHERE hyl_sno10 = NEW.hyl_sno10;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_student_graduation_status
    AFTER UPDATE ON huyl_enroll10
    FOR EACH ROW EXECUTE FUNCTION update_student_status_on_graduation();

--3.4自动提醒学生课程选择冲突
--如果学生选修的课程时间冲突，可以使用触发器来进行检查和自动通知
-- 在数据库中，课程的上课时间可以通过查询 huyl_venue10 表来检查是否有时间重叠的情况
CREATE OR REPLACE FUNCTION check_course_schedule_conflict()
    RETURNS TRIGGER AS $$
DECLARE
    conflict_count INT;
    new_weekday VARCHAR(10);
    --new_time VARCHAR(20);
    new_start_time TIME;
    new_end_time TIME;
    conflict_courses TEXT := '';
BEGIN
    -- 先获取新选课程的时间信息
    SELECT hyl_tweekday10, hyl_tstime10 ,hyl_tetime10
    INTO new_weekday, new_start_time,new_end_time
    FROM huyl_venue10
    WHERE hyl_tcno10 = NEW.hyl_tcno10;

    -- 如果新课程没有时间安排，则不需要检查冲突
    IF new_weekday IS NULL OR new_start_time IS NULL OR new_end_time IS NULL THEN
        RETURN NEW;
    END IF;

    -- 检查新选的课程与学生已有课程时间是否冲突
    SELECT COUNT(*), STRING_AGG(v1.hyl_tcno10, ', ')
    INTO conflict_count, conflict_courses
    FROM huyl_venue10 v1
             JOIN huyl_enroll10 e ON e.hyl_tcno10 = v1.hyl_tcno10
    WHERE e.hyl_sno10 = NEW.hyl_sno10           -- 同一学生
      AND v1.hyl_tcno10 != NEW.hyl_tcno10       -- 排除当前选择的课程
      AND v1.hyl_tweekday10 = new_weekday       -- 同一星期几
      AND (
        -- 检查时间段重叠：新课程开始时间 < 已有课程结束时间 AND 新课程结束时间 > 已有课程开始时间
        new_start_time < v1.hyl_tetime10 AND new_end_time > v1.hyl_tstime10
        );

    -- 如果发现冲突，抛出异常
    IF conflict_count > 0 THEN
        RAISE EXCEPTION '课程时间冲突！您选择的课程在%（%-%）与已选课程（课程号：%）时间重叠，请选择其他时间的课程',
            new_weekday, new_start_time::TEXT, new_end_time::TEXT, conflict_courses;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
DROP TRIGGER IF EXISTS trg_check_course_conflict ON huyl_enroll10;
CREATE TRIGGER trg_check_course_conflict
    BEFORE INSERT ON huyl_enroll10
    FOR EACH ROW
EXECUTE FUNCTION check_course_schedule_conflict();

-- 示例：如果需要在更新选课时也检查冲突，可以添加UPDATE触发器
CREATE TRIGGER trg_check_course_conflict_update
    BEFORE UPDATE ON huyl_enroll10
    FOR EACH ROW
    WHEN (OLD.hyl_tcno10 IS DISTINCT FROM NEW.hyl_tcno10)
EXECUTE FUNCTION check_course_schedule_conflict();

--3.5自动删除离职教师相关的教学班
--当教师离职时，自动删除该教师的所有教学班记录，或者标记教学班状态为"无效"
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

CREATE TRIGGER tr_delete_teacher_classes
    AFTER UPDATE ON huyl_teacher10
    FOR EACH ROW EXECUTE FUNCTION delete_teacher_related_classes();

--3.6自动更新课程成绩的统计信息
--当选课成绩插入或更新时，使用触发器自动计算并更新该课程的平均分，避免手动更新
CREATE OR REPLACE FUNCTION update_course_avg_score()
    RETURNS TRIGGER AS $$
DECLARE
    avg_score DECIMAL(5,2);
BEGIN
    -- 计算该课程的平均分
    SELECT AVG(hyl_escore10) INTO avg_score
    FROM huyl_enroll10
    WHERE hyl_tcno10 = NEW.hyl_tcno10;

    -- 更新课程的平均成绩
    UPDATE huyl_course10
    SET hyl_cavgscore10 = avg_score
    WHERE hyl_cno10 = (SELECT hyl_cno10 FROM huyl_tclass10 WHERE hyl_tcno10 = NEW.hyl_tcno10);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_course_avg_score
    AFTER INSERT OR UPDATE ON huyl_enroll10
    FOR EACH ROW EXECUTE FUNCTION update_course_avg_score();

--3.7自动跟踪课程的"选课人数"
--当学生选课时，自动增加课程的选课人数；退课时，自动减少选课人数。
CREATE OR REPLACE FUNCTION update_course_enrollment_count()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE huyl_tclass10
        SET hyl_tccurstu10 = hyl_tccurstu10 + 1
        WHERE hyl_tcno10 = NEW.hyl_tcno10;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE huyl_tclass10
        SET hyl_tccurstu10 = hyl_tccurstu10 - 1
        WHERE hyl_tcno10 = OLD.hyl_tcno10;
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        -- 如果更换了课程
        IF OLD.hyl_tcno10 != NEW.hyl_tcno10 THEN
            -- 原课程人数减1
            UPDATE huyl_tclass10
            SET hyl_tccurstu10 = hyl_tccurstu10 - 1
            WHERE hyl_tcno10 = OLD.hyl_tcno10;
            -- 新课程人数加1
            UPDATE huyl_tclass10
            SET hyl_tccurstu10 = hyl_tccurstu10 + 1
            WHERE hyl_tcno10 = NEW.hyl_tcno10;
        END IF;
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_update_course_enrollment_count ON huyl_enroll10;
CREATE TRIGGER tr_update_course_enrollment_count
    AFTER INSERT OR DELETE ON huyl_enroll10
FOR EACH ROW EXECUTE FUNCTION update_course_enrollment_count();

-- 3.8自动计算学生的GPA（绩点）
-- 自动计算学生的GPA（绩点）
CREATE OR REPLACE FUNCTION update_student_gpa()
    RETURNS TRIGGER AS $
DECLARE
total_credits DECIMAL(5,1);
    total_points DECIMAL(6,2);
    gpa DECIMAL(4,3);  -- 总体GPA：3位小数，范围0.000-5.000
    student_id VARCHAR(20);
BEGIN
    -- 根据操作类型确定学生ID
    student_id := CASE WHEN TG_OP = 'DELETE' THEN OLD.hyl_sno10 ELSE NEW.hyl_sno10 END;

    -- 计算学生修读的所有有成绩课程的总学分和总绩点
SELECT
    COALESCE(SUM(c.hyl_ccredit10), 0),
    COALESCE(SUM(e.hyl_escore10 * c.hyl_ccredit10), 0)
INTO total_credits, total_points
FROM huyl_enroll10 e
         JOIN huyl_course10 c ON e.hyl_tcno10 = c.hyl_cno10
WHERE e.hyl_sno10 = student_id
  AND e.hyl_escore10 IS NOT NULL    -- 只计算有成绩的课程
  AND e.hyl_escore10 BETWEEN 0 AND 5; -- 成绩范围0-5

-- 计算GPA
IF total_credits > 0 THEN
        gpa := ROUND(total_points / total_credits, 3); -- GPA精确到3位小数
ELSE
        gpa := 0.000; -- 如果没有有效学分，则GPA为0.000
END IF;

    -- 更新学生表中的GPA
UPDATE huyl_student10
SET hyl_sgpa10 = gpa
WHERE hyl_sno10 = student_id;

-- 根据操作类型返回相应的记录
RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器：处理选课记录的增删改
DROP TRIGGER IF EXISTS tr_update_student_gpa ON huyl_enroll10;
CREATE TRIGGER tr_update_student_gpa
    AFTER INSERT OR UPDATE OR DELETE ON huyl_enroll10
    FOR EACH ROW EXECUTE FUNCTION update_student_gpa();

--3.9自动计算学生的专业排名
--在学生的GPA更新时，根据GPA重新计算学生在其专业中的排名
-- 方案1：只更新单个学生的排名（可能不准确，因为其他学生排名也会变化）
CREATE OR REPLACE FUNCTION update_single_student_major_rank()
    RETURNS TRIGGER AS $$
DECLARE
student_major VARCHAR(20);
    major_rank INT;
BEGIN
    -- 获取学生的专业信息
SELECT hyl_mno10 INTO student_major
FROM huyl_student10
WHERE hyl_sno10 = NEW.hyl_sno10;

-- 如果找不到学生专业信息，直接返回
IF student_major IS NULL THEN
        RETURN NEW;
END IF;

    -- 计算该学生在所属专业中的排名
WITH ranked_students AS (
    SELECT hyl_sno10,
           RANK() OVER (ORDER BY hyl_sgpa10 DESC) AS rank
    FROM huyl_student10
    WHERE hyl_mno10 = student_major
      AND hyl_sgpa10 IS NOT NULL
)
SELECT rank INTO major_rank
FROM ranked_students
WHERE hyl_sno10 = NEW.hyl_sno10;

-- 更新学生表中的专业排名
UPDATE huyl_student10
SET hyl_srank10 = major_rank
WHERE hyl_sno10 = NEW.hyl_sno10;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 方案2：更新整个专业所有学生的排名（推荐）
CREATE OR REPLACE FUNCTION update_major_all_students_rank()
    RETURNS TRIGGER AS $$
DECLARE
student_major VARCHAR(20);
BEGIN
    -- 获取学生的专业信息
SELECT hyl_mno10 INTO student_major
FROM huyl_student10
WHERE hyl_sno10 = NEW.hyl_sno10;

-- 如果找不到学生专业信息，直接返回
IF student_major IS NULL THEN
        RETURN NEW;
END IF;

    -- 更新该专业所有学生的排名
WITH ranked_students AS
(
    SELECT hyl_sno10,
           RANK() OVER (ORDER BY hyl_sgpa10 DESC) AS new_rank
    FROM huyl_student10
    WHERE hyl_mno10 = student_major
      AND hyl_sgpa10 IS NOT NULL
)
UPDATE huyl_student10
SET hyl_srank10 = rs.new_rank
    FROM ranked_students rs
WHERE huyl_student10.hyl_sno10 = rs.hyl_sno10;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器（推荐使用方案2）
-- 注意：这个触发器应该绑定到 huyl_student10 表的 hyl_sgpa10 字段更新
DROP TRIGGER IF EXISTS tr_update_student_major_rank ON huyl_student10;
CREATE TRIGGER tr_update_student_major_rank
    AFTER UPDATE OF hyl_sgpa10 ON huyl_student10
    FOR EACH ROW
    WHEN (OLD.hyl_sgpa10 IS DISTINCT FROM NEW.hyl_sgpa10)
    EXECUTE FUNCTION update_major_all_students_rank();

-- 创建一个批量重新计算所有专业排名的函数
CREATE OR REPLACE FUNCTION recalculate_all_major_ranks()
    RETURNS VOID AS $$
DECLARE
major_record RECORD;
BEGIN
    -- 遍历所有专业
FOR major_record IN
SELECT DISTINCT hyl_mno10 FROM huyl_student10 WHERE hyl_mno10 IS NOT NULL
    LOOP
-- 更新该专业所有学生的排名
WITH ranked_students AS (
    SELECT hyl_sno10,
    RANK() OVER (ORDER BY hyl_sgpa10 DESC) AS new_rank
    FROM huyl_student10
    WHERE hyl_mno10 = major_record.hyl_mno10
    AND hyl_sgpa10 IS NOT NULL
    )
UPDATE huyl_student10
SET hyl_srank10 = rs.new_rank
    FROM ranked_students rs
WHERE huyl_student10.hyl_sno10 = rs.hyl_sno10;
END LOOP;

    RAISE NOTICE '已重新计算所有专业的学生排名';
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------------------------------------------------
