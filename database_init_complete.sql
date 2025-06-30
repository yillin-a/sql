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

DROP FUNCTION IF EXISTS check_student_major_consistency CASCADE;
DROP FUNCTION IF EXISTS update_student_credits CASCADE;
DROP FUNCTION IF EXISTS update_tclass_student_count CASCADE;
DROP FUNCTION IF EXISTS update_student_status_on_graduation CASCADE;
DROP FUNCTION IF EXISTS check_course_schedule_conflict CASCADE;
DROP FUNCTION IF EXISTS delete_teacher_related_classes CASCADE;
DROP FUNCTION IF EXISTS update_course_avg_score CASCADE;
DROP FUNCTION IF EXISTS update_course_enrollment_count CASCADE;
DROP FUNCTION IF EXISTS update_student_gpa CASCADE;
DROP FUNCTION IF EXISTS update_single_student_major_rank CASCADE;
DROP FUNCTION IF EXISTS update_major_all_students_rank CASCADE;
DROP FUNCTION IF EXISTS recalculate_all_major_ranks CASCADE;
DROP FUNCTION IF EXISTS update_course_rank CASCADE;
DROP FUNCTION IF EXISTS calculate_total_credits_for_term CASCADE;
DROP FUNCTION IF EXISTS generate_student_password CASCADE;
DROP FUNCTION IF EXISTS cascade_delete_student CASCADE;

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
-- 直接复制 code1.sql 的建表、建序列、建索引、建视图、建函数、建触发器部分
-- （此处省略，实际使用时请粘贴 code1.sql 的全部定义）

-- ================== 3. 插入丰富的测试数据 ==================
-- 学院
INSERT INTO huyl_faculty10 (hyl_fname10, hyl_fdesc10, hyl_festablished10) VALUES
('计算机学院', '专注于计算机科学与技术', '2000-09-01'),
('外国语学院', '外语教学与研究', '1998-09-01'),
('数学学院', '数学与应用数学', '2001-09-01'),
('物理学院', '物理学及其应用', '2002-09-01'),
('化学学院', '化学与分子科学', '2003-09-01'),
('经济管理学院', '经济与管理', '2004-09-01');

-- 专业
INSERT INTO huyl_major10 (hyl_mname10, hyl_mdegree10, hyl_myears10, hyl_fno10) VALUES
('计算机科学与技术', '本科', 4, 800001),
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
INSERT INTO huyl_aclass10 (hyl_acname10, hyl_acyear10, hyl_acmaxstu10, hyl_mno10) VALUES
('计科1班', 2022, 30, 200001),
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
INSERT INTO huyl_teacher10 (hyl_tage10, hyl_tname10, hyl_tbirth10, hyl_ttitle10, hyl_tsex10, hyl_temail10, hyl_toffice10, hyl_tphone10, hyl_tjoindate10, hyl_tstatus10, hyl_fno10) VALUES
(35, '张教授', '1988-01-01', '教授', '男', 'zhang@univ.edu', 'A101', '13800000001', '2015-09-01', '在职', 800001),
(40, '李老师', '1983-05-12', '副教授', '女', 'li@univ.edu', 'A102', '13800000002', '2010-09-01', '在职', 800001),
(30, '王老师', '1993-03-15', '讲师', '男', 'wang@univ.edu', 'B201', '13800000003', '2018-09-01', '在职', 800002),
(45, '赵教授', '1978-07-20', '教授', '女', 'zhao@univ.edu', 'C301', '13800000004', '2005-09-01', '在职', 800003),
(38, '钱老师', '1985-11-11', '副教授', '男', 'qian@univ.edu', 'D401', '13800000005', '2012-09-01', '在职', 800004),
(32, '孙老师', '1991-04-18', '讲师', '女', 'sun@univ.edu', 'E501', '13800000006', '2017-09-01', '在职', 800005),
(50, '周教授', '1973-09-09', '教授', '男', 'zhou@univ.edu', 'F601', '13800000007', '2000-09-01', '在职', 800006),
(29, '吴老师', '1994-12-12', '助教', '女', 'wu@univ.edu', 'G701', '13800000008', '2021-09-01', '在职', 800001),
(36, '郑老师', '1987-06-06', '讲师', '男', 'zheng@univ.edu', 'H801', '13800000009', '2014-09-01', '在职', 800002),
(41, '冯老师', '1982-03-03', '副教授', '女', 'feng@univ.edu', 'I901', '13800000010', '2009-09-01', '在职', 800003);

-- 课程（10门，覆盖各学院）
INSERT INTO huyl_course10 (hyl_cname10, hyl_ccredit10, hyl_chour10, hyl_ctest10, hyl_ctype10, hyl_cprereq10, hyl_cdesc10) VALUES
('数据库原理', 3.0, 48, '考试', '必修课', NULL, '数据库基础知识'),
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
INSERT INTO huyl_tclass10 (hyl_tcname10, hyl_tcyear10, hyl_tcterm10, hyl_tcrepeat10, hyl_tcbatch10, hyl_tcmaxstu10, hyl_tccurstu10, hyl_cno10, hyl_tno10) VALUES
('数据库原理-1班', 2023, 1, '非重修班', '01', 50, 0, 400001, 700001),
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
INSERT INTO huyl_student10 (hyl_sage10, hyl_sname10, hyl_sbirth10, hyl_splace10, hyl_ssex10, hyl_screditsum10, hyl_semail10, hyl_sphone10, hyl_senrolldate10, hyl_sstatus10, hyl_sgpa10, hyl_srank10, hyl_mno10, hyl_acno10) VALUES
(20, '小明', '2003-05-01', '北京', '男', 0, 'xiaoming@univ.edu', '13900000001', '2022-09-01', '在读', 0, 0, 200001, 300001),
(21, '小红', '2002-08-12', '上海', '女', 0, 'xiaohong@univ.edu', '13900000002', '2022-09-01', '在读', 0, 0, 200002, 300002),
(22, '小刚', '2001-11-23', '广州', '男', 0, 'xiaogang@univ.edu', '13900000003', '2022-09-01', '在读', 0, 0, 200003, 300003),
(19, '李雷', '2004-02-14', '深圳', '男', 0, 'lilei@univ.edu', '13900000004', '2023-09-01', '在读', 0, 0, 200001, 300002),
(20, '韩梅梅', '2003-07-21', '南京', '女', 0, 'hanmeimei@univ.edu', '13900000005', '2022-09-01', '在读', 0, 0, 200002, 300002),
(21, '王芳', '2002-10-10', '成都', '女', 0, 'wangfang@univ.edu', '13900000006', '2022-09-01', '在读', 0, 0, 200003, 300003),
(22, '赵强', '2001-12-12', '重庆', '男', 0, 'zhaoqiang@univ.edu', '13900000007', '2022-09-01', '在读', 0, 0, 200004, 300004),
(20, '孙丽', '2003-03-03', '武汉', '女', 0, 'sunli@univ.edu', '13900000008', '2022-09-01', '在读', 0, 0, 200005, 300005),
(21, '陈晨', '2002-06-06', '西安', '男', 0, 'chenchen@univ.edu', '13900000009', '2022-09-01', '在读', 0, 0, 200006, 300006),
(22, '林林', '2001-09-09', '杭州', '女', 0, 'linlin@univ.edu', '13900000010', '2022-09-01', '在读', 0, 0, 200007, 300007),
(20, '周舟', '2003-11-11', '苏州', '男', 0, 'zhouzhou@univ.edu', '13900000011', '2022-09-01', '在读', 0, 0, 200008, 300008),
(21, '吴伟', '2002-04-04', '青岛', '男', 0, 'wuwei@univ.edu', '13900000012', '2022-09-01', '在读', 0, 0, 200009, 300009),
(22, '郑真', '2001-07-07', '大连', '女', 0, 'zhengzhen@univ.edu', '13900000013', '2022-09-01', '在读', 0, 0, 200010, 300010),
(20, '冯峰', '2003-08-08', '合肥', '男', 0, 'fengfeng@univ.edu', '13900000014', '2022-09-01', '在读', 0, 0, 200011, 300011),
(21, '褚楚', '2002-03-03', '南昌', '女', 0, 'zhuchu@univ.edu', '13900000015', '2022-09-01', '在读', 0, 0, 200012, 300012),
(22, '卫伟', '2001-05-05', '厦门', '男', 0, 'weiwei@univ.edu', '13900000016', '2022-09-01', '在读', 0, 0, 200013, 300013),
(20, '蒋静', '2003-12-12', '天津', '女', 0, 'jiangjing@univ.edu', '13900000017', '2022-09-01', '在读', 0, 0, 200001, 300001),
(21, '沈深', '2002-01-01', '深圳', '男', 0, 'shenshen@univ.edu', '13900000018', '2022-09-01', '在读', 0, 0, 200002, 300002),
(22, '韩寒', '2001-02-02', '哈尔滨', '女', 0, 'hanhan@univ.edu', '13900000019', '2022-09-01', '在读', 0, 0, 200003, 300003),
(20, '吕律', '2003-03-03', '兰州', '男', 0, 'lvlu@univ.edu', '13900000020', '2022-09-01', '在读', 0, 0, 200004, 300004);

-- 选课
INSERT INTO huyl_enroll10 (hyl_escore10, hyl_egpa10, hyl_open10, hyl_enrolldate10, hyl_status10, hyl_tcno10, hyl_sno10) VALUES
(85, 4.0, true, now(), '正常', 500001, 600001),
(90, 4.5, true, now(), '正常', 500002, 600002),
(78, 3.5, true, now(), '正常', 500003, 600003);

-- 上课时间地点
INSERT INTO huyl_venue10 (hyl_tplace10, hyl_tstime10, hyl_tetime10, hyl_tweekday10, hyl_tweeks10, hyl_tcno10) VALUES
('教一-101', '08:00', '09:40', 1, '1-16周', 500001),
('教一-102', '10:00', '11:40', 3, '1-16周', 500002),
('教二-201', '14:00', '15:40', 5, '1-16周', 500003);

-- 用户
INSERT INTO huyl_user10 (hyl_uname10, hyl_utype10, hyl_upassword10) VALUES
('xiaoming', 'student', 'stu600001'),
('xiaohong', 'student', 'stu600002'),
('xiaogang', 'student', 'stu600003'),
('zhang', 'teacher', 'tea700001'),
('li', 'teacher', 'tea700002'),
('admin', 'admin', 'admin123');

-- 培养方案
INSERT INTO huyl_cultivate10 (hyl_mno10, hyl_cno10, hyl_cterm10, hyl_cmandatory10) VALUES
(200001, 400001, 3, true),
(200001, 400002, 4, true),
(200003, 400003, 2, true);

-- ================== 4. 重新执行 code1.sql 里的所有视图、索引、触发器、函数定义 ==================
-- 直接复制 code1.sql 里所有视图、索引、函数、触发器定义到此处
-- （此处省略，实际使用时请粘贴 code1.sql 的全部定义） 