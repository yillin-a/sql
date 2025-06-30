package org.example.demo111.dao;

import org.example.demo111.model.Course;
import org.example.demo111.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * 课程数据访问对象
 */
public class CourseDAO {
    
    /**
     * 查询所有课程
     */
    public List<Course> findAll() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM huyl_course10 ORDER BY hyl_cno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * 根据课程编号查询课程
     */
    public Course findByCourseId(Integer courseId) throws SQLException {
        String sql = "SELECT * FROM huyl_course10 WHERE hyl_cno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
        }
        
        return null;
    }
    
    /**
     * 根据课程名称模糊查询课程
     */
    public List<Course> findByName(String name) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM huyl_course10 WHERE hyl_cname10 ILIKE ? ORDER BY hyl_cno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * 根据课程类型查询课程
     */
    public List<Course> findByType(String type) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM huyl_course10 WHERE hyl_ctype10 = ? ORDER BY hyl_cno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, type);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = mapResultSetToCourse(rs);
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * 添加课程
     * 对应表的结构
     */
    public boolean addCourse(Course course) throws SQLException {
        // 数据验证
        validateCourseData(course);

        String sql = "INSERT INTO huyl_course10 (hyl_cname10, hyl_ccredit10, hyl_chour10, " +
                "hyl_ctest10, hyl_ctype10, hyl_cprereq10, hyl_cdesc10, hyl_cavgscore10) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, course.getHylCname10());
            pstmt.setBigDecimal(2, course.getHylCcredit10());
            pstmt.setInt(3, course.getHylChour10());
            pstmt.setString(4, course.getHylCtest10());
            pstmt.setString(5, course.getHylCtype10());

            // 处理可选字段
            setNullableString(pstmt, 6, course.getHylCprereq10());
            setNullableString(pstmt, 7, course.getHylCdesc10());

            // 处理平均分字段（新增加的）
            if (course.getHylCavgscore10() != null) {
                pstmt.setBigDecimal(8, course.getHylCavgscore10());
            } else {
                pstmt.setNull(8, java.sql.Types.DECIMAL);
            }

            return pstmt.executeUpdate() > 0;
        }
    }

    private void validateCourseData(Course course) {
        if (course.getHylCcredit10().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("学分必须大于0");
        }
        if (course.getHylChour10() <= 0) {
            throw new IllegalArgumentException("学时必须大于0");
        }
        if (!Arrays.asList("考试", "考查").contains(course.getHylCtest10())) {
            throw new IllegalArgumentException("考试方式只能是'考试'或'考查'");
        }
        if (!Arrays.asList("通识课", "必修课", "限选课", "体育课", "实践课").contains(course.getHylCtype10())) {
            throw new IllegalArgumentException("课程类型不合法");
        }
    }

    private void setNullableString(PreparedStatement pstmt, int index, String value) throws SQLException {
        if (value != null && !value.trim().isEmpty()) {
            pstmt.setString(index, value);
        } else {
            pstmt.setNull(index, java.sql.Types.VARCHAR);
        }
    }
    
    /**
     * 更新课程信息
     */
    public boolean updateCourse(Course course) throws SQLException {
        // 数据验证
        validateCourseForUpdate(course);

        String sql = "UPDATE huyl_course10 SET hyl_cname10=?, hyl_ccredit10=?, hyl_chour10=?, " +
                "hyl_ctest10=?, hyl_ctype10=?, hyl_cprereq10=?, hyl_cdesc10=?, hyl_cavgscore10=? " +
                "WHERE hyl_cno10=?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, course.getHylCname10());
            pstmt.setBigDecimal(2, course.getHylCcredit10());
            pstmt.setInt(3, course.getHylChour10());
            pstmt.setString(4, course.getHylCtest10());
            pstmt.setString(5, course.getHylCtype10());

            setNullableString(pstmt, 6, course.getHylCprereq10());
            setNullableString(pstmt, 7, course.getHylCdesc10());

            // 处理平均分字段
            if (course.getHylCavgscore10() != null) {
                pstmt.setBigDecimal(8, course.getHylCavgscore10());
            } else {
                pstmt.setNull(8, java.sql.Types.DECIMAL);
            }

            pstmt.setInt(9, course.getHylCno10());

            return pstmt.executeUpdate() > 0;
        }
    }

    private void validateCourseForUpdate(Course course) throws SQLException {
        // 验证必填字段
        if (course.getHylCno10() == null || course.getHylCno10() <= 0) {
            throw new IllegalArgumentException("课程编号不能为空且必须大于0");
        }

        // 验证数值约束
        if (course.getHylCcredit10().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("学分必须大于0");
        }
        if (course.getHylChour10() <= 0) {
            throw new IllegalArgumentException("学时必须大于0");
        }

        // 验证枚举值约束
        if (!Arrays.asList("考试", "考查").contains(course.getHylCtest10())) {
            throw new IllegalArgumentException("考试方式只能是'考试'或'考查'");
        }
        if (!Arrays.asList("通识课", "必修课", "限选课", "体育课", "实践课").contains(course.getHylCtype10())) {
            throw new IllegalArgumentException("课程类型不合法");
        }

        // 验证唯一性约束（需要查询数据库）
        checkCourseNameTypeUniqueness(course);
    }

    private void checkCourseNameTypeUniqueness(Course course) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM huyl_course10 WHERE hyl_cname10=? AND hyl_ctype10=? AND hyl_cno10!=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkSql)) {

            pstmt.setString(1, course.getHylCname10());
            pstmt.setString(2, course.getHylCtype10());
            pstmt.setInt(3, course.getHylCno10());

            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new SQLException("课程名称和类型的组合已存在");
            }
        }
    }
    
    /**
     * 删除课程
     */
    public boolean deleteCourse(Integer courseId) throws SQLException {
        String sql = "DELETE FROM huyl_course10 WHERE hyl_cno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 获取课程统计信息
     */
    public Map<String, Object> getCourseStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // 总课程数
        String totalSql = "SELECT COUNT(*) as total FROM huyl_course10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(totalSql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                stats.put("totalCourses", rs.getInt("total"));
            }
        }
        
        // 按类型统计
        String typeSql = "SELECT hyl_ctype10, COUNT(*) as count FROM huyl_course10 GROUP BY hyl_ctype10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(typeSql);
             ResultSet rs = pstmt.executeQuery()) {
            Map<String, Integer> typeStats = new HashMap<>();
            while (rs.next()) {
                typeStats.put(rs.getString("hyl_ctype10"), rs.getInt("count"));
            }
            stats.put("typeStats", typeStats);
        }
        
        // 按考核方式统计
        String testSql = "SELECT hyl_ctest10, COUNT(*) as count FROM huyl_course10 GROUP BY hyl_ctest10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(testSql);
             ResultSet rs = pstmt.executeQuery()) {
            Map<String, Integer> testStats = new HashMap<>();
            while (rs.next()) {
                testStats.put(rs.getString("hyl_ctest10"), rs.getInt("count"));
            }
            stats.put("testStats", testStats);
        }
        
        // 平均学分
        String avgCreditSql = "SELECT AVG(hyl_ccredit10) as avgCredit FROM huyl_course10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(avgCreditSql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                stats.put("avgCredit", rs.getBigDecimal("avgCredit"));
            }
        }
        
        // 平均学时
        String avgHourSql = "SELECT AVG(hyl_chour10) as avgHour FROM huyl_course10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(avgHourSql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                stats.put("avgHour", rs.getDouble("avgHour"));
            }
        }
        
        return stats;
    }
    
    /**
     * 获取课程成绩统计
     */
    public List<Map<String, Object>> getCourseScoreStats() throws SQLException {
        List<Map<String, Object>> scoreStats = new ArrayList<>();
        String sql = "SELECT c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10, " +
                     "COUNT(e.hyl_sno10) as studentCount, " +
                     "AVG(e.hyl_escore10) as avgScore, " +
                     "MAX(e.hyl_escore10) as maxScore, " +
                     "MIN(e.hyl_escore10) as minScore " +
                     "FROM huyl_course10 c " +
                     "LEFT JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "LEFT JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE e.hyl_escore10 IS NOT NULL " +
                     "GROUP BY c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10 " +
                     "ORDER BY avgScore DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("courseId", rs.getInt("hyl_cno10"));
                stat.put("courseName", rs.getString("hyl_cname10"));
                stat.put("courseType", rs.getString("hyl_ctype10"));
                stat.put("studentCount", rs.getInt("studentCount"));
                stat.put("avgScore", rs.getDouble("avgScore"));
                stat.put("maxScore", rs.getInt("maxScore"));
                stat.put("minScore", rs.getInt("minScore"));
                scoreStats.add(stat);
            }
        }
        
        return scoreStats;
    }
    
    /**
     * 获取课程平均成绩详细统计（按教学班）
     */
    public List<Map<String, Object>> getCourseAverageScoreDetails() throws SQLException {
        List<Map<String, Object>> scoreStats = new ArrayList<>();
        String sql = "SELECT c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10, " +
                     "tc.hyl_tcno10 as teaching_class_id, " +
                     "t.hyl_tname10 as teacher_name, " +
                     "tc.hyl_tcyear10 as year, " +
                     "tc.hyl_tcterm10 as term, " +
                     "COUNT(e.hyl_sno10) as student_count, " +
                     "ROUND(AVG(e.hyl_escore10), 2) as avg_score, " +
                     "MAX(e.hyl_escore10) as max_score, " +
                     "MIN(e.hyl_escore10) as min_score, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as excellent_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as good_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as average_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as pass_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as fail_count " +
                     "FROM huyl_course10 c " +
                     "JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "LEFT JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE e.hyl_escore10 IS NOT NULL " +
                     "GROUP BY c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10, tc.hyl_tcno10, t.hyl_tname10, tc.hyl_tcyear10, tc.hyl_tcterm10 " +
                     "ORDER BY avg_score DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("courseId", rs.getInt("hyl_cno10"));
                stat.put("courseName", rs.getString("hyl_cname10"));
                stat.put("courseType", rs.getString("hyl_ctype10"));
                stat.put("teachingClassId", rs.getInt("teaching_class_id"));
                stat.put("teacherName", rs.getString("teacher_name"));
                stat.put("year", rs.getInt("year"));
                stat.put("term", rs.getInt("term"));
                stat.put("studentCount", rs.getInt("student_count"));
                stat.put("avgScore", rs.getDouble("avg_score"));
                stat.put("maxScore", rs.getInt("max_score"));
                stat.put("minScore", rs.getInt("min_score"));
                stat.put("excellentCount", rs.getInt("excellent_count"));
                stat.put("goodCount", rs.getInt("good_count"));
                stat.put("averageCount", rs.getInt("average_count"));
                stat.put("passCount", rs.getInt("pass_count"));
                stat.put("failCount", rs.getInt("fail_count"));
                scoreStats.add(stat);
            }
        }
        
        return scoreStats;
    }
    
    /**
     * 按课程名称搜索课程平均成绩
     */
    public List<Map<String, Object>> getCourseAverageScoreByCourseName(String courseName) throws SQLException {
        List<Map<String, Object>> scoreStats = new ArrayList<>();
        String sql = "SELECT c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10, " +
                     "tc.hyl_tcno10 as teaching_class_id, " +
                     "t.hyl_tname10 as teacher_name, " +
                     "tc.hyl_tcyear10 as year, " +
                     "tc.hyl_tcterm10 as term, " +
                     "COUNT(e.hyl_sno10) as student_count, " +
                     "ROUND(AVG(e.hyl_escore10), 2) as avg_score, " +
                     "MAX(e.hyl_escore10) as max_score, " +
                     "MIN(e.hyl_escore10) as min_score, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as excellent_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as good_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as average_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as pass_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as fail_count " +
                     "FROM huyl_course10 c " +
                     "JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "LEFT JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE e.hyl_escore10 IS NOT NULL AND c.hyl_cname10 ILIKE ? " +
                     "GROUP BY c.hyl_cno10, c.hyl_cname10, c.hyl_ctype10, tc.hyl_tcno10, t.hyl_tname10, tc.hyl_tcyear10, tc.hyl_tcterm10 " +
                     "ORDER BY avg_score DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + courseName + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> stat = new HashMap<>();
                    stat.put("courseId", rs.getInt("hyl_cno10"));
                    stat.put("courseName", rs.getString("hyl_cname10"));
                    stat.put("courseType", rs.getString("hyl_ctype10"));
                    stat.put("teachingClassId", rs.getInt("teaching_class_id"));
                    stat.put("teacherName", rs.getString("teacher_name"));
                    stat.put("year", rs.getInt("year"));
                    stat.put("term", rs.getInt("term"));
                    stat.put("studentCount", rs.getInt("student_count"));
                    stat.put("avgScore", rs.getDouble("avg_score"));
                    stat.put("maxScore", rs.getInt("max_score"));
                    stat.put("minScore", rs.getInt("min_score"));
                    stat.put("excellentCount", rs.getInt("excellent_count"));
                    stat.put("goodCount", rs.getInt("good_count"));
                    stat.put("averageCount", rs.getInt("average_count"));
                    stat.put("passCount", rs.getInt("pass_count"));
                    stat.put("failCount", rs.getInt("fail_count"));
                    scoreStats.add(stat);
                }
            }
        }
        
        return scoreStats;
    }
    
    /**
     * 获取课程平均成绩总体统计
     */
    public Map<String, Object> getCourseAverageScoreOverallStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(DISTINCT c.hyl_cno10) as total_courses, " +
                     "COUNT(DISTINCT tc.hyl_tcno10) as total_teaching_classes, " +
                     "COUNT(DISTINCT e.hyl_sno10) as total_students, " +
                     "COUNT(e.hyl_sno10) as total_enrollments, " +
                     "ROUND(AVG(e.hyl_escore10), 2) as overall_avg_score, " +
                     "MAX(e.hyl_escore10) as overall_max_score, " +
                     "MIN(e.hyl_escore10) as overall_min_score, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as total_excellent, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as total_good, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as total_average, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as total_pass, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as total_fail " +
                     "FROM huyl_course10 c " +
                     "JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE e.hyl_escore10 IS NOT NULL";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalCourses", rs.getInt("total_courses"));
                stats.put("totalTeachingClasses", rs.getInt("total_teaching_classes"));
                stats.put("totalStudents", rs.getInt("total_students"));
                stats.put("totalEnrollments", rs.getInt("total_enrollments"));
                stats.put("overallAvgScore", rs.getDouble("overall_avg_score"));
                stats.put("overallMaxScore", rs.getInt("overall_max_score"));
                stats.put("overallMinScore", rs.getInt("overall_min_score"));
                stats.put("totalExcellent", rs.getInt("total_excellent"));
                stats.put("totalGood", rs.getInt("total_good"));
                stats.put("totalAverage", rs.getInt("total_average"));
                stats.put("totalPass", rs.getInt("total_pass"));
                stats.put("totalFail", rs.getInt("total_fail"));
            }
        }
        
        return stats;
    }
    
    /**
     * 按教师统计课程平均成绩
     */
    public List<Map<String, Object>> getCourseAverageScoreByTeacher() throws SQLException {
        List<Map<String, Object>> scoreStats = new ArrayList<>();
        String sql = "SELECT t.hyl_tno10, t.hyl_tname10 as teacher_name, " +
                     "COUNT(DISTINCT c.hyl_cno10) as course_count, " +
                     "COUNT(DISTINCT tc.hyl_tcno10) as teaching_class_count, " +
                     "COUNT(e.hyl_sno10) as total_students, " +
                     "ROUND(AVG(e.hyl_escore10), 2) as avg_score, " +
                     "MAX(e.hyl_escore10) as max_score, " +
                     "MIN(e.hyl_escore10) as min_score, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as excellent_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as good_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as average_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as pass_count, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as fail_count " +
                     "FROM huyl_teacher10 t " +
                     "JOIN huyl_tclass10 tc ON t.hyl_tno10 = tc.hyl_tno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE e.hyl_escore10 IS NOT NULL " +
                     "GROUP BY t.hyl_tno10, t.hyl_tname10 " +
                     "ORDER BY avg_score DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("teacherId", rs.getInt("hyl_tno10"));
                stat.put("teacherName", rs.getString("teacher_name"));
                stat.put("courseCount", rs.getInt("course_count"));
                stat.put("teachingClassCount", rs.getInt("teaching_class_count"));
                stat.put("totalStudents", rs.getInt("total_students"));
                stat.put("avgScore", rs.getDouble("avg_score"));
                stat.put("maxScore", rs.getInt("max_score"));
                stat.put("minScore", rs.getInt("min_score"));
                stat.put("excellentCount", rs.getInt("excellent_count"));
                stat.put("goodCount", rs.getInt("good_count"));
                stat.put("averageCount", rs.getInt("average_count"));
                stat.put("passCount", rs.getInt("pass_count"));
                stat.put("failCount", rs.getInt("fail_count"));
                scoreStats.add(stat);
            }
        }
        
        return scoreStats;
    }
    
    /**
     * 检查课程是否被使用（有学生选课）
     */
    public boolean isCourseUsed(Integer courseId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM huyl_tclass10 tc " +
                     "JOIN huyl_enroll10 e ON tc.hyl_tcno10 = e.hyl_tcno10 " +
                     "WHERE tc.hyl_cno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        
        return false;
    }
    
    /**
     * 将ResultSet映射为Course对象
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setHylCno10(rs.getInt("hyl_cno10"));
        course.setHylCname10(rs.getString("hyl_cname10"));
        course.setHylCcredit10(rs.getBigDecimal("hyl_ccredit10"));
        course.setHylChour10(rs.getInt("hyl_chour10"));
        course.setHylCtest10(rs.getString("hyl_ctest10"));
        course.setHylCtype10(rs.getString("hyl_ctype10"));
        course.setHylCprereq10(rs.getString("hyl_cprereq10"));
        course.setHylCdesc10(rs.getString("hyl_cdesc10"));
        
        // 处理平均成绩字段
        BigDecimal avgScore = rs.getBigDecimal("hyl_cavgscore10");
        if (avgScore != null) {
            course.setHylCavgscore10(avgScore);
        }
        
        return course;
    }

    /**
     * 获取学生可选的所有课程（排除已选课程）
     */
    public List<Map<String, Object>> getAllCoursesForSelection(Integer studentId) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT DISTINCT c.hyl_cno10, c.hyl_cname10, c.hyl_ccredit10, c.hyl_chour10, c.hyl_ctest10, c.hyl_ctype10 " +
                     "FROM huyl_course10 c " +
                     "JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "WHERE c.hyl_cno10 NOT IN (" +
                     "    SELECT DISTINCT tc2.hyl_cno10 " +
                     "    FROM huyl_enroll10 e " +
                     "    JOIN huyl_tclass10 tc2 ON e.hyl_tcno10 = tc2.hyl_tcno10 " +
                     "    WHERE e.hyl_sno10 = ? AND e.hyl_status10 = '正常'" +
                     ") " +
                     "ORDER BY c.hyl_cno10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("courseId", rs.getInt("hyl_cno10"));
                map.put("courseName", rs.getString("hyl_cname10"));
                map.put("credit", rs.getBigDecimal("hyl_ccredit10"));
                map.put("hour", rs.getInt("hyl_chour10"));
                map.put("testType", rs.getString("hyl_ctest10"));
                map.put("type", rs.getString("hyl_ctype10"));
                result.add(map);
            }
        }
        return result;
    }

    /**
     * 根据教师ID查询其教授的所有教学班
     * @param teacherId 教师工号
     * @return 教学班列表，每个教学班是一个包含详细信息的Map
     */
    public List<Map<String, Object>> findTeachingClassesByTeacherId(Integer teacherId) throws SQLException {
        List<Map<String, Object>> teachingClasses = new ArrayList<>();
        String sql = "SELECT tc.hyl_tcno10, tc.hyl_term10, c.hyl_cno10, c.hyl_cname10 " +
                     "FROM huyl_tclass10 tc " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "WHERE tc.hyl_tno10 = ? " +
                     "ORDER BY tc.hyl_term10 DESC, c.hyl_cname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> tClass = new HashMap<>();
                tClass.put("hyl_tcno10", rs.getInt("hyl_tcno10"));
                tClass.put("hyl_term10", rs.getString("hyl_term10"));
                tClass.put("hyl_cno10", rs.getInt("hyl_cno10"));
                tClass.put("hyl_cname10", rs.getString("hyl_cname10"));
                teachingClasses.add(tClass);
            }
        }
        return teachingClasses;
    }

    /**
     * 根据教学班ID查询课程
     */
    public Course findByTeachingClassId(Integer teachingClassId) throws SQLException {
        String sql = "SELECT c.* FROM huyl_course10 c " +
                     "JOIN huyl_tclass10 tc ON c.hyl_cno10 = tc.hyl_cno10 " +
                     "WHERE tc.hyl_tcno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teachingClassId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
        }
        
        return null;
    }
} 