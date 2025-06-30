package org.example.demo111.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Enrollment;
import org.example.demo111.util.DatabaseUtil;

/**
 * 选课管理DAO
 */
public class EnrollmentDAO {
    // 查询所有选课记录
    public List<Enrollment> findAll() throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT * FROM huyl_enroll10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToEnrollment(rs));
            }
        }
        return list;
    }

    // 按学号查询该学生所有选课
    public List<Enrollment> findByStudentId(Integer hylSno10) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.hyl_sname10 as student_name, c.hyl_cname10 as course_name, " +
                     "t.hyl_tname10 as teacher_name, tc.hyl_tcyear10 as year, tc.hyl_tcterm10 as term, " +
                     "c.hyl_ccredit10 as course_credit " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10 " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE e.hyl_sno10 = ? " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10 DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hylSno10);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment e = mapResultSetToEnrollment(rs);
                    // 设置关联字段
                    e.setStudentName(rs.getString("student_name"));
                    e.setCourseName(rs.getString("course_name"));
                    e.setTeacherName(rs.getString("teacher_name"));
                    e.setYear(rs.getInt("year"));
                    e.setTerm(rs.getInt("term"));
                    e.setCourseCredit(rs.getBigDecimal("course_credit"));
                    list.add(e);
                }
            }
        }
        return list;
    }

    // 新增选课
    public boolean addEnrollment(Enrollment enrollment) throws SQLException {
        System.out.println("addEnrollment: " + enrollment);
        
        // 构建动态SQL，只插入非null字段
        StringBuilder sql = new StringBuilder("INSERT INTO huyl_enroll10 (hyl_sno10, hyl_tcno10");
        StringBuilder values = new StringBuilder(" VALUES (?, ?");
        
        List<Object> params = new ArrayList<>();
        params.add(enrollment.getHylSno10());
        params.add(enrollment.getHylTcno10());
        
        // 只有非null字段才插入
        if (enrollment.getHylEscore10() != null) {
            sql.append(", hyl_escore10");
            values.append(", ?");
            params.add(enrollment.getHylEscore10());
        }
        
        if (enrollment.getHylEgpa10() != null) {
            sql.append(", hyl_egpa10");
            values.append(", ?");
            params.add(enrollment.getHylEgpa10());
        }
        
        // hyl_open10字段：如果为null则使用数据库默认值true
        if (enrollment.getHylOpen10() != null) {
            sql.append(", hyl_open10");
            values.append(", ?");
            params.add(enrollment.getHylOpen10());
        }
        
        if (enrollment.getHylEnrolldate10() != null) {
            sql.append(", hyl_enrolldate10");
            values.append(", ?");
            params.add(new Timestamp(enrollment.getHylEnrolldate10().getTime()));
        }
        
        if (enrollment.getHylStatus10() != null) {
            sql.append(", hyl_status10");
            values.append(", ?");
            params.add(enrollment.getHylStatus10());
        }
        
        sql.append(")").append(values).append(")");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            // 设置参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            return pstmt.executeUpdate() > 0;
        }
    }

    // 删除选课
    public boolean deleteEnrollment(Integer hylSno10, Integer hylTcno10) throws SQLException {
        System.out.println("delete " + hylSno10 + " " + hylTcno10);
        String sql = "DELETE FROM huyl_enroll10 WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hylSno10);
            pstmt.setInt(2, hylTcno10);
            return pstmt.executeUpdate() > 0;
        }
    }

    // 更新成绩、状态等
    public boolean updateEnrollment(Enrollment enrollment) throws SQLException {
        String sql = "UPDATE huyl_enroll10 SET hyl_escore10 = ?, hyl_status10 = ? WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, enrollment.getHylEscore10(), Types.INTEGER);
            pstmt.setString(2, enrollment.getHylStatus10());
            pstmt.setInt(3, enrollment.getHylSno10());
            pstmt.setInt(4, enrollment.getHylTcno10());
            return pstmt.executeUpdate() > 0;
        }
    }

    // 更新学生成绩
    public boolean updateScore(Integer studentId, Integer teachingClassId, Integer score) throws SQLException {
        String sql = "UPDATE huyl_enroll10 SET hyl_escore10 = ? WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, score, Types.INTEGER);
            pstmt.setInt(2, studentId);
            pstmt.setInt(3, teachingClassId);
            return pstmt.executeUpdate() > 0;
        }
    }

    // 更新学生成绩和GPA
    public boolean updateScoreAndGPA(Integer studentId, Integer teachingClassId, Integer score, BigDecimal gpa) throws SQLException {
        String sql = "UPDATE huyl_enroll10 SET hyl_escore10 = ?, hyl_egpa10 = ? WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, score, Types.INTEGER);
            pstmt.setBigDecimal(2, gpa);
            pstmt.setInt(3, studentId);
            pstmt.setInt(4, teachingClassId);
            return pstmt.executeUpdate() > 0;
        }
    }

    // 批量更新GPA（根据成绩自动计算）
    public boolean batchUpdateGPA() throws SQLException {
        String sql = "UPDATE huyl_enroll10 SET hyl_egpa10 = CASE " +
                     "WHEN hyl_escore10 >= 60 THEN ROUND((hyl_escore10 - 50) / 10.0, 1) " +
                     "ELSE 0.0 END " +
                     "WHERE hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            return pstmt.executeUpdate() > 0;
        }
    }

    // 获取学生的总GPA
    public BigDecimal getStudentTotalGPA(Integer studentId) throws SQLException {
        String sql = "SELECT AVG(hyl_egpa10) as total_gpa FROM huyl_enroll10 " +
                     "WHERE hyl_sno10 = ? AND hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_gpa");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // 获取学生的加权GPA
    public BigDecimal getStudentWeightedGPA(Integer studentId) throws SQLException {
        String sql = "SELECT SUM(e.hyl_egpa10 * c.hyl_ccredit10) / SUM(c.hyl_ccredit10) as weighted_gpa " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("weighted_gpa");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // 获取学生指定学期的GPA
    public BigDecimal getStudentTermGPA(Integer studentId, Integer year, Integer term) throws SQLException {
        String sql = "SELECT AVG(e.hyl_egpa10) as term_gpa " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "WHERE e.hyl_sno10 = ? AND tc.hyl_tcyear10 = ? AND tc.hyl_tcterm10 = ? " +
                     "AND e.hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, year);
            pstmt.setInt(3, term);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("term_gpa");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // 获取课程的平均GPA
    public BigDecimal getCourseAverageGPA(Integer teachingClassId) throws SQLException {
        String sql = "SELECT AVG(hyl_egpa10) as avg_gpa FROM huyl_enroll10 " +
                     "WHERE hyl_tcno10 = ? AND hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, teachingClassId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("avg_gpa");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // 获取GPA分布统计
    public Map<String, Integer> getGPADistribution(Integer teachingClassId) throws SQLException {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT " +
                     "SUM(CASE WHEN hyl_egpa10 >= 4.0 THEN 1 ELSE 0 END) as excellent, " +
                     "SUM(CASE WHEN hyl_egpa10 >= 3.0 AND hyl_egpa10 < 4.0 THEN 1 ELSE 0 END) as good, " +
                     "SUM(CASE WHEN hyl_egpa10 >= 2.0 AND hyl_egpa10 < 3.0 THEN 1 ELSE 0 END) as average, " +
                     "SUM(CASE WHEN hyl_egpa10 >= 1.0 AND hyl_egpa10 < 2.0 THEN 1 ELSE 0 END) as pass, " +
                     "SUM(CASE WHEN hyl_egpa10 < 1.0 THEN 1 ELSE 0 END) as fail " +
                     "FROM huyl_enroll10 WHERE hyl_tcno10 = ? AND hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, teachingClassId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    distribution.put("excellent", rs.getInt("excellent"));
                    distribution.put("good", rs.getInt("good"));
                    distribution.put("average", rs.getInt("average"));
                    distribution.put("pass", rs.getInt("pass"));
                    distribution.put("fail", rs.getInt("fail"));
                }
            }
        }
        return distribution;
    }

    // 获取学生GPA排名
    public Integer getStudentGPARank(Integer studentId) throws SQLException {
        String sql = "SELECT rank FROM (" +
                     "SELECT hyl_sno10, ROW_NUMBER() OVER (ORDER BY AVG(hyl_egpa10) DESC) as rank " +
                     "FROM huyl_enroll10 " +
                     "WHERE hyl_escore10 IS NOT NULL " +
                     "GROUP BY hyl_sno10" +
                     ") ranked WHERE hyl_sno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("rank");
                }
            }
        }
        return null;
    }

    // 获取学生GPA历史记录
    public List<Map<String, Object>> getStudentGPAHistory(Integer studentId) throws SQLException {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT tc.hyl_tcyear10 as year, tc.hyl_tcterm10 as term, " +
                     "AVG(e.hyl_egpa10) as avg_gpa, COUNT(*) as course_count " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_escore10 IS NOT NULL " +
                     "GROUP BY tc.hyl_tcyear10, tc.hyl_tcterm10 " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10 DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("year", rs.getInt("year"));
                    record.put("term", rs.getInt("term"));
                    record.put("avgGPA", rs.getBigDecimal("avg_gpa"));
                    record.put("courseCount", rs.getInt("course_count"));
                    history.add(record);
                }
            }
        }
        return history;
    }

    // 按教学班编号查询该班所有选课
    public List<Enrollment> findByCourseId(Integer hylTcno10) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT * FROM huyl_enroll10 WHERE hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hylTcno10);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToEnrollment(rs));
                }
            }
        }
        return list;
    }

    // 查询单条选课记录
    public Enrollment findByStudentAndCourse(Integer hylSno10, Integer hylTcno10) throws SQLException {
        String sql = "SELECT * FROM huyl_enroll10 WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hylSno10);
            pstmt.setInt(2, hylTcno10);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEnrollment(rs);
                }
            }
        }
        return null;
    }

    // 根据学号和教学班编号查询选课记录
    public Enrollment findByStudentIdAndTeachingClassId(Integer studentId, Integer teachingClassId) throws SQLException {
        String sql = "SELECT * FROM huyl_enroll10 WHERE hyl_sno10 = ? AND hyl_tcno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, teachingClassId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEnrollment(rs);
                }
            }
        }
        return null;
    }

    // 按课程名称模糊查询选课记录（含学生、课程、教师等信息）
    public List<Enrollment> findByCourseName(String courseName) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.hyl_sname10 as student_name, c.hyl_cname10 as course_name, " +
                     "t.hyl_tname10 as teacher_name, tc.hyl_tcyear10 as year, tc.hyl_tcterm10 as term " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10 " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE c.hyl_cname10 ILIKE ? " +
                     "ORDER BY e.hyl_escore10 DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + courseName + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment e = mapResultSetToEnrollment(rs);
                    // 额外设置关联字段
                    e.setStudentName(rs.getString("student_name"));
                    e.setCourseName(rs.getString("course_name"));
                    e.setTeacherName(rs.getString("teacher_name"));
                    e.setYear(rs.getInt("year"));
                    e.setTerm(rs.getInt("term"));
                    list.add(e);
                }
            }
        }
        return list;
    }

    // 查询课程平均成绩统计
    public List<Enrollment> findCourseAverageScores() throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT " +
                "c.hyl_cname10 as course_name, " +
                "COUNT(e.hyl_sno10) as student_count, " +
                "ROUND(AVG(e.hyl_escore10), 2) as avg_score, " +
                "MAX(e.hyl_escore10) as max_score, " +
                "MIN(e.hyl_escore10) as min_score, " +
                "ROUND(SUM(CASE WHEN e.hyl_escore10 >= 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(e.hyl_sno10), 2) as pass_rate " +
                "FROM huyl_enroll10 e " +
                "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                "WHERE e.hyl_escore10 IS NOT NULL " +
                "GROUP BY c.hyl_cname10 " +
                "ORDER BY avg_score DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Enrollment e = new Enrollment();
                e.setCourseName(rs.getString("course_name"));
                e.setStudentCount(rs.getInt("student_count"));
                e.setAverageScore(rs.getDouble("avg_score"));
                e.setMaxScore(rs.getInt("max_score"));
                e.setMinScore(rs.getInt("min_score"));
                e.setPassRate(rs.getDouble("pass_rate") / 100);
                list.add(e);
            }
        }
        return list;
    }

    // 查询总体统计信息
    public Enrollment findOverallStatistics() throws SQLException {
        String sql = "SELECT " +
                "COUNT(DISTINCT tc.hyl_cno10) as total_courses, " +
                "COUNT(e.hyl_sno10) as total_enrollments, " +
                "ROUND(AVG(e.hyl_escore10), 2) as overall_avg_score, " +
                "ROUND(SUM(CASE WHEN e.hyl_escore10 >= 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(e.hyl_sno10), 2) as overall_pass_rate " +
                "FROM huyl_enroll10 e " +
                "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                "WHERE e.hyl_escore10 IS NOT NULL";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                Enrollment e = new Enrollment();
                e.setTotalCourses(rs.getInt("total_courses"));
                e.setTotalEnrollments(rs.getInt("total_enrollments"));
                e.setOverallAverageScore(rs.getDouble("overall_avg_score"));
                e.setOverallPassRate(rs.getDouble("overall_pass_rate") / 100);
                return e;
            }
        }
        return null;
    }

    // 按课程名称搜索课程平均成绩统计
    public List<Enrollment> findCourseAverageScoresByCourseName(String courseName) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT " +
                "c.hyl_cname10 as course_name, " +
                "COUNT(e.hyl_sno10) as student_count, " +
                "ROUND(AVG(e.hyl_escore10), 2) as avg_score, " +
                "MAX(e.hyl_escore10) as max_score, " +
                "MIN(e.hyl_escore10) as min_score, " +
                "ROUND(SUM(CASE WHEN e.hyl_escore10 >= 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(e.hyl_sno10), 2) as pass_rate " +
                "FROM huyl_enroll10 e " +
                "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                "WHERE e.hyl_escore10 IS NOT NULL AND c.hyl_cname10 ILIKE ? " +
                "GROUP BY c.hyl_cname10 " +
                "ORDER BY avg_score DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + courseName + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment e = new Enrollment();
                    e.setCourseName(rs.getString("course_name"));
                    e.setStudentCount(rs.getInt("student_count"));
                    e.setAverageScore(rs.getDouble("avg_score"));
                    e.setMaxScore(rs.getInt("max_score"));
                    e.setMinScore(rs.getInt("min_score"));
                    e.setPassRate(rs.getDouble("pass_rate") / 100);
                    list.add(e);
                }
            }
        }
        return list;
    }

    /**
     * 获取当前学期课表
     */
    public List<Map<String, Object>> getCurrentTermSchedule(Integer studentId) throws SQLException {
        List<Map<String, Object>> schedule = new ArrayList<>();
        String sql = "SELECT c.hyl_cname10 as course_name, tc.hyl_tcname10 as class_name, " +
                     "t.hyl_tname10 as teacher_name, v.hyl_tplace10 as classroom, " +
                     "v.hyl_tstime10 as start_time, v.hyl_tetime10 as end_time, " +
                     "v.hyl_tweekday10 as weekday, c.hyl_ccredit10 as credits " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "LEFT JOIN huyl_venue10 v ON tc.hyl_tcno10 = v.hyl_tcno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_status10 = '正常' " +
                     "AND tc.hyl_tcyear10 = (SELECT MAX(hyl_tcyear10) FROM huyl_tclass10) " +
                     "AND tc.hyl_tcterm10 = (SELECT MAX(hyl_tcterm10) FROM huyl_tclass10 WHERE hyl_tcyear10 = (SELECT MAX(hyl_tcyear10) FROM huyl_tclass10)) " +
                     "ORDER BY v.hyl_tweekday10, v.hyl_tstime10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> course = new HashMap<>();
                    course.put("courseName", rs.getString("course_name"));
                    course.put("className", rs.getString("class_name"));
                    course.put("teacherName", rs.getString("teacher_name"));
                    course.put("classroom", rs.getString("classroom"));
                    course.put("startTime", rs.getTime("start_time"));
                    course.put("endTime", rs.getTime("end_time"));
                    course.put("weekday", rs.getInt("weekday"));
                    course.put("credits", rs.getBigDecimal("credits"));
                    schedule.add(course);
                }
            }
        }
        return schedule;
    }

    /**
     * 获取GPA历史趋势
     */
    public List<Map<String, Object>> getGPAHistory(Integer studentId) throws SQLException {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT tc.hyl_tcyear10 as year, tc.hyl_tcterm10 as term, " +
                     "AVG(e.hyl_egpa10) as avg_gpa, COUNT(*) as course_count " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_egpa10 IS NOT NULL " +
                     "GROUP BY tc.hyl_tcyear10, tc.hyl_tcterm10 " +
                     "ORDER BY tc.hyl_tcyear10, tc.hyl_tcterm10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> term = new HashMap<>();
                    term.put("year", rs.getInt("year"));
                    term.put("term", rs.getInt("term"));
                    term.put("avgGPA", rs.getBigDecimal("avg_gpa"));
                    term.put("courseCount", rs.getInt("course_count"));
                    history.add(term);
                }
            }
        }
        return history;
    }

    /**
     * 获取成绩分布统计
     */
    public Map<String, Integer> getScoreDistribution(Integer studentId) throws SQLException {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT " +
                     "CASE " +
                     "  WHEN hyl_escore10 >= 90 THEN '优秀' " +
                     "  WHEN hyl_escore10 >= 80 THEN '良好' " +
                     "  WHEN hyl_escore10 >= 70 THEN '中等' " +
                     "  WHEN hyl_escore10 >= 60 THEN '及格' " +
                     "  ELSE '不及格' " +
                     "END as grade_level, " +
                     "COUNT(*) as count " +
                     "FROM huyl_enroll10 " +
                     "WHERE hyl_sno10 = ? AND hyl_escore10 IS NOT NULL " +
                     "GROUP BY grade_level " +
                     "ORDER BY count DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    distribution.put(rs.getString("grade_level"), rs.getInt("count"));
                }
            }
        }
        return distribution;
    }

    /**
     * 根据教学班ID查询所有选课记录（包括学生姓名）
     */
    public List<Enrollment> findEnrollmentsByTeachingClassId(Integer teachingClassId) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.hyl_sname10 " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10 " +
                     "WHERE e.hyl_tcno10 = ? " +
                     "ORDER BY e.hyl_sno10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, teachingClassId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = mapResultSetToEnrollment(rs);
                    enrollment.setStudentName(rs.getString("hyl_sname10"));
                    list.add(enrollment);
                }
            }
        }
        return list;
    }

    // 将ResultSet映射为Enrollment对象
    private Enrollment mapResultSetToEnrollment(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setHylSno10(rs.getInt("hyl_sno10"));
        enrollment.setHylTcno10(rs.getInt("hyl_tcno10"));
        
        // 处理可能为null的成绩
        int score = rs.getInt("hyl_escore10");
        enrollment.setHylEscore10(rs.wasNull() ? null : score);
        
        enrollment.setHylEgpa10(rs.getBigDecimal("hyl_egpa10"));
        enrollment.setHylOpen10(rs.getBoolean("hyl_open10"));
        
        Timestamp enrollDate = rs.getTimestamp("hyl_enrolldate10");
        if (enrollDate != null) {
            enrollment.setHylEnrolldate10(new Date(enrollDate.getTime()));
        }
        
        enrollment.setHylStatus10(rs.getString("hyl_status10"));
        return enrollment;
    }

    /**
     * 获取学生可选的教学班列表（排除已选课程，显示有余量的教学班）
     */
    public List<Map<String, Object>> getAvailableTeachingClasses(Integer studentId) throws SQLException {
        List<Map<String, Object>> availableClasses = new ArrayList<>();
        String sql = "SELECT tc.hyl_tcno10, tc.hyl_tcname10, tc.hyl_tcyear10, tc.hyl_tcterm10, " +
                     "tc.hyl_tcrepeat10, tc.hyl_tcbatch10, tc.hyl_tcmaxstu10, tc.hyl_tccurstu10, " +
                     "c.hyl_cno10, c.hyl_cname10, c.hyl_ccredit10, c.hyl_chour10, c.hyl_ctest10, c.hyl_ctype10, " +
                     "t.hyl_tname10 as teacher_name, " +
                     "v.hyl_tplace10, v.hyl_tstime10, v.hyl_tetime10, v.hyl_tweekday10 " +
                     "FROM huyl_tclass10 tc " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "LEFT JOIN huyl_venue10 v ON tc.hyl_tcno10 = v.hyl_tcno10 " +
                     "WHERE tc.hyl_tcno10 NOT IN (" +
                     "    SELECT e.hyl_tcno10 FROM huyl_enroll10 e " +
                     "    WHERE e.hyl_sno10 = ? AND e.hyl_status10 = '正常'" +
                     ") " +
                     "AND tc.hyl_tccurstu10 < tc.hyl_tcmaxstu10 " + // 还有余量
                     "AND tc.hyl_tcyear10 >= 2023 " + // 只显示当前和未来学年的课程
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10, c.hyl_cname10, tc.hyl_tcbatch10";
                     
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> teachingClass = new HashMap<>();
                    teachingClass.put("tcno", rs.getInt("hyl_tcno10"));
                    teachingClass.put("tcname", rs.getString("hyl_tcname10"));
                    teachingClass.put("year", rs.getInt("hyl_tcyear10"));
                    teachingClass.put("term", rs.getInt("hyl_tcterm10"));
                    teachingClass.put("repeat", rs.getString("hyl_tcrepeat10"));
                    teachingClass.put("batch", rs.getString("hyl_tcbatch10"));
                    teachingClass.put("maxStudents", rs.getInt("hyl_tcmaxstu10"));
                    teachingClass.put("currentStudents", rs.getInt("hyl_tccurstu10"));
                    teachingClass.put("courseId", rs.getInt("hyl_cno10"));
                    teachingClass.put("courseName", rs.getString("hyl_cname10"));
                    teachingClass.put("credit", rs.getBigDecimal("hyl_ccredit10"));
                    teachingClass.put("hour", rs.getInt("hyl_chour10"));
                    teachingClass.put("testType", rs.getString("hyl_ctest10"));
                    teachingClass.put("courseType", rs.getString("hyl_ctype10"));
                    teachingClass.put("teacherName", rs.getString("teacher_name"));
                    teachingClass.put("classroom", rs.getString("hyl_tplace10"));
                    teachingClass.put("startTime", rs.getTime("hyl_tstime10"));
                    teachingClass.put("endTime", rs.getTime("hyl_tetime10"));
                    teachingClass.put("weekday", rs.getInt("hyl_tweekday10"));
                    availableClasses.add(teachingClass);
                }
            }
        }
        return availableClasses;
    }

    /**
     * 获取学生已选的教学班列表（用于退选）
     */
    public List<Map<String, Object>> getEnrolledTeachingClasses(Integer studentId) throws SQLException {
        List<Map<String, Object>> enrolledClasses = new ArrayList<>();
        String sql = "SELECT tc.hyl_tcno10, tc.hyl_tcname10, tc.hyl_tcyear10, tc.hyl_tcterm10, " +
                     "c.hyl_cname10, c.hyl_ccredit10, c.hyl_chour10, c.hyl_ctest10, c.hyl_ctype10, " +
                     "t.hyl_tname10 as teacher_name, e.hyl_enrolldate10, e.hyl_status10 " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_status10 = '正常' " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10, c.hyl_cname10";
                     
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> enrolledClass = new HashMap<>();
                    enrolledClass.put("tcno", rs.getInt("hyl_tcno10"));
                    enrolledClass.put("tcname", rs.getString("hyl_tcname10"));
                    enrolledClass.put("year", rs.getInt("hyl_tcyear10"));
                    enrolledClass.put("term", rs.getInt("hyl_tcterm10"));
                    enrolledClass.put("courseName", rs.getString("hyl_cname10"));
                    enrolledClass.put("credit", rs.getBigDecimal("hyl_ccredit10"));
                    enrolledClass.put("hour", rs.getInt("hyl_chour10"));
                    enrolledClass.put("testType", rs.getString("hyl_ctest10"));
                    enrolledClass.put("courseType", rs.getString("hyl_ctype10"));
                    enrolledClass.put("teacherName", rs.getString("teacher_name"));
                    enrolledClass.put("enrollDate", rs.getTimestamp("hyl_enrolldate10"));
                    enrolledClass.put("status", rs.getString("hyl_status10"));
                    enrolledClasses.add(enrolledClass);
                }
            }
        }
        return enrolledClasses;
    }
} 