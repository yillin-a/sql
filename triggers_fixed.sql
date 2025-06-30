-- 删除已存在的触发器和函数
DROP TRIGGER IF EXISTS tr_Teacher_Insert ON huyl_teacher10;
DROP FUNCTION IF EXISTS trig_CreateTeacherUser();

-- 创建教师触发器函数
CREATE OR REPLACE FUNCTION trig_CreateTeacherUser()
    RETURNS TRIGGER AS $$
BEGIN
    -- 在huyl_user10表中创建新教师账户
    INSERT INTO huyl_user10 (hyl_uname10, hyl_utype10, hyl_upassword10, hyl_ucreated10)
    VALUES (CAST(NEW.hyl_tno10 AS VARCHAR), 'teacher', CAST(NEW.hyl_tno10 AS VARCHAR), CURRENT_TIMESTAMP);

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