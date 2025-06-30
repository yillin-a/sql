package org.example.demo111.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Student;
import org.example.demo111.util.DatabaseUtil;

/**
 * 学生数据访问对象
 */
public class StudentDAO {
    
    /**
     * 查询所有学生
     */
    public List<Student> findAll() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.*, m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "ORDER BY s.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                students.add(student);
            }
        }
        
        return students;
    }
    
    /**
     * 根据学号查询学生
     */
    public Student findByStudentId(Integer studentId) throws SQLException {
        String sql = "SELECT s.*, m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "WHERE s.hyl_sno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToStudent(rs);
            }
        }
        
        return null;
    }
    
    /**
     * 根据姓名模糊查询学生
     */
    public List<Student> findByName(String name) throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.*, m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "WHERE s.hyl_sname10 ILIKE ? " +
                     "ORDER BY s.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                students.add(student);
            }
        }
        
        return students;
    }
    
    /**
     * 添加学生
     */
    public boolean addStudent(Student student) throws SQLException {
        String sql = "INSERT INTO huyl_student10 (hyl_sage10, hyl_sname10, hyl_sbirth10, hyl_splace10, " +
                     "hyl_ssex10, hyl_semail10, hyl_sphone10, hyl_mno10, hyl_acno10) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, student.getHylSage10());
            pstmt.setString(2, student.getHylSname10());
            
            if (student.getHylSbirth10() != null) {
                pstmt.setDate(3, new java.sql.Date(student.getHylSbirth10().getTime()));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            
            pstmt.setString(4, student.getHylSplace10());
            pstmt.setString(5, student.getHylSsex10());
            
            if (student.getHylSemail10() != null && !student.getHylSemail10().trim().isEmpty()) {
                pstmt.setString(6, student.getHylSemail10());
            } else {
                pstmt.setNull(6, java.sql.Types.VARCHAR);
            }
            
            if (student.getHylSphone10() != null && !student.getHylSphone10().trim().isEmpty()) {
                pstmt.setString(7, student.getHylSphone10());
            } else {
                pstmt.setNull(7, java.sql.Types.VARCHAR);
            }
            
            pstmt.setInt(8, student.getHylMno10());
            pstmt.setInt(9, student.getHylAcno10());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新学生信息
     */
    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE huyl_student10 SET hyl_sage10=?, hyl_sname10=?, hyl_sbirth10=?, " +
                     "hyl_splace10=?, hyl_ssex10=?, hyl_semail10=?, hyl_sphone10=?, " +
                     "hyl_mno10=?, hyl_acno10=? WHERE hyl_sno10=?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, student.getHylSage10());
            pstmt.setString(2, student.getHylSname10());
            
            if (student.getHylSbirth10() != null) {
                pstmt.setDate(3, new java.sql.Date(student.getHylSbirth10().getTime()));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            
            pstmt.setString(4, student.getHylSplace10());
            pstmt.setString(5, student.getHylSsex10());
            
            if (student.getHylSemail10() != null && !student.getHylSemail10().trim().isEmpty()) {
                pstmt.setString(6, student.getHylSemail10());
            } else {
                pstmt.setNull(6, java.sql.Types.VARCHAR);
            }
            
            if (student.getHylSphone10() != null && !student.getHylSphone10().trim().isEmpty()) {
                pstmt.setString(7, student.getHylSphone10());
            } else {
                pstmt.setNull(7, java.sql.Types.VARCHAR);
            }
            
            pstmt.setInt(8, student.getHylMno10());
            pstmt.setInt(9, student.getHylAcno10());
            pstmt.setInt(10, student.getHylSno10());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新学生个人信息（仅限邮箱、电话、籍贯）
     */
    public boolean updateStudentProfile(Integer studentId, String email, String phone, String place) throws SQLException {
        String sql = "UPDATE huyl_student10 SET hyl_semail10 = ?, hyl_sphone10 = ?, hyl_splace10 = ? WHERE hyl_sno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, phone);
            pstmt.setString(3, place);
            pstmt.setInt(4, studentId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * 删除学生
     */
    public boolean deleteStudent(Integer studentId) throws SQLException {
        String sql = "DELETE FROM huyl_student10 WHERE hyl_sno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 查询学生成绩
     */
    public List<Student> findStudentsWithScores() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.*, m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "ORDER BY s.hyl_sgpa10 DESC NULLS LAST, s.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                students.add(student);
            }
        }
        
        return students;
    }
    
    /**
     * 获取学生详细成绩信息
     */
    public List<Map<String, Object>> getStudentScores(Integer studentId) throws SQLException {
        List<Map<String, Object>> scores = new ArrayList<>();
        String sql = "SELECT e.hyl_escore10, e.hyl_egpa10, e.hyl_status10, e.hyl_enrolldate10, " +
                     "c.hyl_cname10, c.hyl_ccredit10, c.hyl_ctype10, " +
                     "tc.hyl_tcname10, tc.hyl_tcyear10, tc.hyl_tcterm10, " +
                     "t.hyl_tname10 " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE e.hyl_sno10 = ? " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10 DESC, c.hyl_cname10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> score = new HashMap<>();
                score.put("score", rs.getInt("hyl_escore10"));
                score.put("gpa", rs.getDouble("hyl_egpa10"));
                score.put("status", rs.getString("hyl_status10"));
                score.put("enrollDate", rs.getTimestamp("hyl_enrolldate10"));
                score.put("courseName", rs.getString("hyl_cname10"));
                score.put("credit", rs.getDouble("hyl_ccredit10"));
                score.put("courseType", rs.getString("hyl_ctype10"));
                score.put("className", rs.getString("hyl_tcname10"));
                score.put("year", rs.getInt("hyl_tcyear10"));
                score.put("term", rs.getInt("hyl_tcterm10"));
                score.put("teacherName", rs.getString("hyl_tname10"));
                scores.add(score);
            }
        }
        
        return scores;
    }
    
    /**
     * 获取学生成绩统计信息
     */
    public Map<String, Object> getStudentScoreStats(Integer studentId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) as total_courses, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 THEN 1 END) as passed_courses, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as failed_courses, " +
                     "AVG(e.hyl_escore10) as avg_score, " +
                     "SUM(c.hyl_ccredit10) as total_credits, " +
                     "SUM(CASE WHEN e.hyl_escore10 >= 60 THEN c.hyl_ccredit10 ELSE 0 END) as earned_credits " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                     "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "WHERE e.hyl_sno10 = ? AND e.hyl_status10 = '正常'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.put("totalCourses", rs.getInt("total_courses"));
                stats.put("passedCourses", rs.getInt("passed_courses"));
                stats.put("failedCourses", rs.getInt("failed_courses"));
                stats.put("avgScore", rs.getDouble("avg_score"));
                stats.put("totalCredits", rs.getDouble("total_credits"));
                stats.put("earnedCredits", rs.getDouble("earned_credits"));
                
                // 计算通过率
                int totalCourses = rs.getInt("total_courses");
                int passedCourses = rs.getInt("passed_courses");
                if (totalCourses > 0) {
                    stats.put("passRate", (double) passedCourses / totalCourses * 100);
                } else {
                    stats.put("passRate", 0.0);
                }
            }
        }
        
        return stats;
    }
    
    /**
     * 获取所有学生的成绩排名
     */
    public List<Map<String, Object>> getAllStudentsRanking() throws SQLException {
        List<Map<String, Object>> rankings = new ArrayList<>();
        String sql = "SELECT s.hyl_sno10, s.hyl_sname10, s.hyl_sgpa10, s.hyl_srank10, " +
                     "m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name, " +
                     "COUNT(e.hyl_tcno10) as course_count, " +
                     "AVG(e.hyl_escore10) as avg_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10 " +
                     "GROUP BY s.hyl_sno10, s.hyl_sname10, s.hyl_sgpa10, s.hyl_srank10, m.hyl_mname10, ac.hyl_acname10 " +
                     "ORDER BY s.hyl_sgpa10 DESC NULLS LAST, s.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> ranking = new HashMap<>();
                ranking.put("studentId", rs.getInt("hyl_sno10"));
                ranking.put("studentName", rs.getString("hyl_sname10"));
                ranking.put("gpa", rs.getDouble("hyl_sgpa10"));
                ranking.put("rank", rs.getInt("hyl_srank10"));
                ranking.put("majorName", rs.getString("major_name"));
                ranking.put("className", rs.getString("class_name"));
                ranking.put("courseCount", rs.getInt("course_count"));
                ranking.put("avgScore", rs.getDouble("avg_score"));
                rankings.add(ranking);
            }
        }
        
        return rankings;
    }
    
    /**
     * 获取总体成绩分析
     */
    public Map<String, Object> getOverallScoreAnalysis() throws SQLException {
        Map<String, Object> analysis = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(DISTINCT s.hyl_sno10) as total_students, " +
                     "COUNT(DISTINCT e.hyl_tcno10) as total_courses, " +
                     "COUNT(CASE WHEN e.hyl_escore10 > 0 THEN 1 END) as total_scores, " +
                     "AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as avg_score, " +
                     "MIN(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as min_score, " +
                     "MAX(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as max_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                analysis.put("totalStudents", rs.getInt("total_students"));
                analysis.put("totalCourses", rs.getInt("total_courses"));
                analysis.put("totalScores", rs.getInt("total_scores"));
                
                double avgScore = rs.getDouble("avg_score");
                if (rs.wasNull()) {
                    avgScore = 0.0;
                }
                analysis.put("avgScore", avgScore);
                
                int minScore = rs.getInt("min_score");
                if (rs.wasNull()) {
                    minScore = 0;
                }
                analysis.put("minScore", minScore);
                
                int maxScore = rs.getInt("max_score");
                if (rs.wasNull()) {
                    maxScore = 0;
                }
                analysis.put("maxScore", maxScore);
            }
        }
        
        return analysis;
    }
    
    /**
     * 按专业获取成绩统计
     */
    public List<Map<String, Object>> getScoreStatsByMajor() throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT " +
                     "m.hyl_mname10 as major_name, " +
                     "COUNT(DISTINCT s.hyl_sno10) as student_count, " +
                     "AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) as avg_gpa " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "WHERE m.hyl_mname10 IS NOT NULL " +
                     "GROUP BY m.hyl_mname10 " +
                     "ORDER BY avg_gpa DESC NULLS LAST";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> majorStat = new HashMap<>();
                majorStat.put("majorName", rs.getString("major_name"));
                majorStat.put("studentCount", rs.getInt("student_count"));
                
                double avgGPA = rs.getDouble("avg_gpa");
                if (rs.wasNull()) {
                    avgGPA = 0.0;
                }
                majorStat.put("avgGPA", avgGPA);
                
                // 暂时设为0，后续可以从选课记录中计算
                majorStat.put("avgScore", 0.0);
                
                stats.add(majorStat);
            }
        }
        
        return stats;
    }
    
    /**
     * 获取成绩分布
     */
    public Map<String, Object> getScoreDistribution() throws SQLException {
        Map<String, Object> distribution = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as excellent, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as good, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as average, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as pass, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as fail " +
                     "FROM huyl_enroll10 e";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                distribution.put("excellent", rs.getInt("excellent"));
                distribution.put("good", rs.getInt("good"));
                distribution.put("average", rs.getInt("average"));
                distribution.put("pass", rs.getInt("pass"));
                distribution.put("fail", rs.getInt("fail"));
            }
        }
        
        return distribution;
    }
    
    /**
     * 按专业获取成绩排名
     */
    public List<Map<String, Object>> getScoreRankingByMajor(String major) throws SQLException {
        List<Map<String, Object>> rankings = new ArrayList<>();
        String sql = "SELECT s.hyl_sno10, s.hyl_sname10, s.hyl_sgpa10, s.hyl_srank10, " +
                     "m.hyl_mname10 as major_name, ac.hyl_acname10 as class_name, " +
                     "COUNT(e.hyl_tcno10) as course_count, " +
                     "AVG(e.hyl_escore10) as avg_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_aclass10 ac ON s.hyl_acno10 = ac.hyl_acno10 " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10 " +
                     "WHERE m.hyl_mname10 = ? " +
                     "GROUP BY s.hyl_sno10, s.hyl_sname10, s.hyl_sgpa10, s.hyl_srank10, m.hyl_mname10, ac.hyl_acname10 " +
                     "ORDER BY s.hyl_sgpa10 DESC NULLS LAST, s.hyl_sno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, major);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> ranking = new HashMap<>();
                ranking.put("studentId", rs.getInt("hyl_sno10"));
                ranking.put("studentName", rs.getString("hyl_sname10"));
                ranking.put("gpa", rs.getDouble("hyl_sgpa10"));
                ranking.put("rank", rs.getInt("hyl_srank10"));
                ranking.put("majorName", rs.getString("major_name"));
                ranking.put("className", rs.getString("class_name"));
                ranking.put("courseCount", rs.getInt("course_count"));
                ranking.put("avgScore", rs.getDouble("avg_score"));
                rankings.add(ranking);
            }
        }
        
        return rankings;
    }
    
    /**
     * 获取生源地总体统计
     */
    public Map<String, Object> getOriginOverallStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取基本统计信息
        String basicSql = "SELECT " +
                         "COUNT(DISTINCT hyl_sno10) as total_students, " +
                         "COUNT(DISTINCT hyl_splace10) as total_origins " +
                         "FROM huyl_student10 " +
                         "WHERE hyl_splace10 IS NOT NULL";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(basicSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                int totalStudents = rs.getInt("total_students");
                int totalOrigins = rs.getInt("total_origins");
                
                stats.put("totalStudents", totalStudents);
                stats.put("totalOrigins", totalOrigins);
                
                // 计算平均每地学生数
                double avgStudentsPerOrigin = totalOrigins > 0 ? (double) totalStudents / totalOrigins : 0.0;
                stats.put("avgStudentsPerOrigin", avgStudentsPerOrigin);
            }
        }
        
        // 获取最热门生源地
        String popularSql = "SELECT hyl_splace10 as most_popular_origin " +
                           "FROM huyl_student10 " +
                           "WHERE hyl_splace10 IS NOT NULL " +
                           "GROUP BY hyl_splace10 " +
                           "ORDER BY COUNT(*) DESC " +
                           "LIMIT 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(popularSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("mostPopularOrigin", rs.getString("most_popular_origin"));
            } else {
                stats.put("mostPopularOrigin", "暂无数据");
            }
        }
        
        return stats;
    }
    
    /**
     * 获取生源地分布
     */
    public Map<String, Object> getOriginDistribution() throws SQLException {
        Map<String, Object> distribution = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(CASE WHEN student_count >= 10 THEN 1 END) as high_density, " +
                     "COUNT(CASE WHEN student_count >= 5 AND student_count < 10 THEN 1 END) as medium_density, " +
                     "COUNT(CASE WHEN student_count >= 2 AND student_count < 5 THEN 1 END) as low_density, " +
                     "COUNT(CASE WHEN student_count = 1 THEN 1 END) as single_student " +
                     "FROM (SELECT hyl_splace10, COUNT(*) as student_count " +
                     "      FROM huyl_student10 " +
                     "      WHERE hyl_splace10 IS NOT NULL " +
                     "      GROUP BY hyl_splace10) origin_counts";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                distribution.put("highDensity", rs.getInt("high_density"));
                distribution.put("mediumDensity", rs.getInt("medium_density"));
                distribution.put("lowDensity", rs.getInt("low_density"));
                distribution.put("singleStudent", rs.getInt("single_student"));
            }
        }
        
        return distribution;
    }
    
    /**
     * 获取生源地分布列表
     */
    public List<Map<String, Object>> getOriginDistributionList() throws SQLException {
        List<Map<String, Object>> distribution = new ArrayList<>();
        String sql = "SELECT hyl_splace10 as origin_name, COUNT(*) as student_count " +
                     "FROM huyl_student10 " +
                     "WHERE hyl_splace10 IS NOT NULL " +
                     "GROUP BY hyl_splace10 " +
                     "ORDER BY student_count DESC;";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> origin = new HashMap<>();
                origin.put("originName", rs.getString("origin_name"));
                origin.put("studentCount", rs.getInt("student_count"));
                distribution.add(origin);
            }
        }
        
        return distribution;
    }
    
    /**
     * 获取生源地排名（按成绩排名）
     */
    public List<Map<String, Object>> getOriginRanking() throws SQLException {
        List<Map<String, Object>> ranking = new ArrayList<>();
        // 修改SQL查询，当所有学生GPA都为0时，改为按学生平均成绩排序
        String sql = "SELECT " +
                     "s.hyl_splace10 as origin_name, " +
                     "COUNT(*) as student_count, " +
                     "AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) as avg_gpa, " +
                     "COUNT(CASE WHEN s.hyl_sgpa10 >= 3.0 THEN 1 END) as good_students, " +
                     "AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as avg_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10 " +
                     "WHERE s.hyl_splace10 IS NOT NULL AND s.hyl_splace10 != '' " +
                     "GROUP BY s.hyl_splace10 " +
                     "HAVING COUNT(*) >= 1 " +
                     "ORDER BY " +
                     "CASE WHEN AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) IS NOT NULL " +
                     "     THEN AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) " +
                     "     ELSE COALESCE(AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END), 0) / 20.0 " +
                     "END DESC, " +
                     "student_count DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> origin = new HashMap<>();
                origin.put("originName", rs.getString("origin_name"));
                origin.put("studentCount", rs.getInt("student_count"));
                
                // 处理GPA，如果为0或null，则使用平均成绩计算
                double avgGPA = rs.getDouble("avg_gpa");
                if (rs.wasNull() || avgGPA == 0.0) {
                    double avgScore = rs.getDouble("avg_score");
                    if (!rs.wasNull() && avgScore > 0) {
                        // 简单的成绩到GPA转换：90-100=4.0, 80-89=3.0, 70-79=2.0, 60-69=1.0, <60=0
                        if (avgScore >= 90) avgGPA = 4.0;
                        else if (avgScore >= 80) avgGPA = 3.0;
                        else if (avgScore >= 70) avgGPA = 2.0;
                        else if (avgScore >= 60) avgGPA = 1.0;
                        else avgGPA = 0.0;
                    }
                }
                
                origin.put("avgGPA", avgGPA);
                origin.put("goodStudents", rs.getInt("good_students"));
                ranking.add(origin);
            }
        }
        
        return ranking;
    }
    
    /**
     * 获取生源地分析
     */
    public Map<String, Object> getOriginAnalysis() throws SQLException {
        Map<String, Object> analysis = new HashMap<>();
        
        // 获取基本统计信息
        String basicSql = "SELECT " +
                         "COUNT(DISTINCT hyl_splace10) as total_origins, " +
                         "COUNT(DISTINCT hyl_sno10) as total_students " +
                         "FROM huyl_student10 " +
                         "WHERE hyl_splace10 IS NOT NULL";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(basicSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                int totalOrigins = rs.getInt("total_origins");
                int totalStudents = rs.getInt("total_students");
                
                analysis.put("totalOrigins", totalOrigins);
                analysis.put("totalStudents", totalStudents);
                
                // 计算平均每地学生数
                double avgStudentsPerOrigin = totalOrigins > 0 ? (double) totalStudents / totalOrigins : 0.0;
                analysis.put("avgStudentsPerOrigin", avgStudentsPerOrigin);
            }
        }
        
        // 获取最大和最小学生数
        String minMaxSql = "SELECT " +
                          "MAX(student_count) as max_students_per_origin, " +
                          "MIN(student_count) as min_students_per_origin " +
                          "FROM (SELECT hyl_splace10, COUNT(*) as student_count " +
                          "      FROM huyl_student10 " +
                          "      WHERE hyl_splace10 IS NOT NULL " +
                          "      GROUP BY hyl_splace10) origin_counts";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(minMaxSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                analysis.put("maxStudentsPerOrigin", rs.getInt("max_students_per_origin"));
                analysis.put("minStudentsPerOrigin", rs.getInt("min_students_per_origin"));
            }
        }
        
        return analysis;
    }
    
    /**
     * 获取生源地表现（按成绩分析）
     */
    public List<Map<String, Object>> getOriginPerformance() throws SQLException {
        List<Map<String, Object>> performance = new ArrayList<>();
        // 修改SQL查询，当所有学生GPA都为0时，改为按学生平均成绩排序
        String sql = "SELECT " +
                     "s.hyl_splace10 as origin_name, " +
                     "COUNT(*) as student_count, " +
                     "AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) as avg_gpa, " +
                     "COUNT(CASE WHEN s.hyl_sgpa10 >= 4.0 THEN 1 END) as excellent_count, " +
                     "COUNT(CASE WHEN s.hyl_sgpa10 >= 3.0 AND s.hyl_sgpa10 < 4.0 THEN 1 END) as good_count, " +
                     "COUNT(CASE WHEN s.hyl_sgpa10 > 0 AND s.hyl_sgpa10 < 3.0 THEN 1 END) as poor_count, " +
                     "AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as avg_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10 " +
                     "WHERE s.hyl_splace10 IS NOT NULL AND s.hyl_splace10 != '' " +
                     "GROUP BY s.hyl_splace10 " +
                     "HAVING COUNT(*) >= 1 " +
                     "ORDER BY " +
                     "CASE WHEN AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) IS NOT NULL " +
                     "     THEN AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) " +
                     "     ELSE COALESCE(AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END), 0) / 20.0 " +
                     "END DESC, " +
                     "student_count DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> origin = new HashMap<>();
                origin.put("originName", rs.getString("origin_name"));
                origin.put("studentCount", rs.getInt("student_count"));
                
                // 处理GPA，如果为0或null，则使用平均成绩计算
                double avgGPA = rs.getDouble("avg_gpa");
                if (rs.wasNull() || avgGPA == 0.0) {
                    double avgScore = rs.getDouble("avg_score");
                    if (!rs.wasNull() && avgScore > 0) {
                        // 简单的成绩到GPA转换：90-100=4.0, 80-89=3.0, 70-79=2.0, 60-69=1.0, <60=0
                        if (avgScore >= 90) avgGPA = 4.0;
                        else if (avgScore >= 80) avgGPA = 3.0;
                        else if (avgScore >= 70) avgGPA = 2.0;
                        else if (avgScore >= 60) avgGPA = 1.0;
                        else avgGPA = 0.0;
                    }
                }
                
                origin.put("avgGPA", avgGPA);
                origin.put("excellentCount", rs.getInt("excellent_count"));
                origin.put("goodCount", rs.getInt("good_count"));
                origin.put("poorCount", rs.getInt("poor_count"));
                performance.add(origin);
            }
        }
        
        return performance;
    }
    
    /**
     * 获取前N个生源地
     */
    public List<Map<String, Object>> getTopOrigins(int limit) throws SQLException {
        List<Map<String, Object>> topOrigins = new ArrayList<>();
        String sql = "SELECT hyl_splace10 as origin_name, COUNT(*) as student_count " +
                     "FROM huyl_student10 " +
                     "WHERE hyl_splace10 IS NOT NULL " +
                     "GROUP BY hyl_splace10 " +
                     "ORDER BY student_count DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> origin = new HashMap<>();
                origin.put("originName", rs.getString("origin_name"));
                origin.put("studentCount", rs.getInt("student_count"));
                topOrigins.add(origin);
            }
        }
        
        return topOrigins;
    }
    
    /**
     * 获取总体成绩统计
     */
    public Map<String, Object> getOverallScoreStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取学生基本统计
        String studentSql = "SELECT " +
                           "COUNT(DISTINCT s.hyl_sno10) as total_students, " +
                           "AVG(CASE WHEN s.hyl_sgpa10 > 0 THEN s.hyl_sgpa10 ELSE NULL END) as avg_gpa, " +
                           "COUNT(CASE WHEN s.hyl_sgpa10 >= 4.0 THEN 1 END) as excellent_count, " +
                           "COUNT(CASE WHEN s.hyl_sgpa10 >= 3.0 AND s.hyl_sgpa10 < 4.0 THEN 1 END) as good_count, " +
                           "COUNT(CASE WHEN s.hyl_sgpa10 >= 2.0 AND s.hyl_sgpa10 < 3.0 THEN 1 END) as average_count, " +
                           "COUNT(CASE WHEN s.hyl_sgpa10 > 0 AND s.hyl_sgpa10 < 2.0 THEN 1 END) as poor_count " +
                           "FROM huyl_student10 s";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(studentSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalStudents", rs.getInt("total_students"));
                
                // 处理GPA统计
                double avgGPA = rs.getDouble("avg_gpa");
                if (rs.wasNull()) {
                    avgGPA = 0.0;
                }
                stats.put("avgGPA", avgGPA);
                
                stats.put("excellentCount", rs.getInt("excellent_count"));
                stats.put("goodCount", rs.getInt("good_count"));
                stats.put("averageCount", rs.getInt("average_count"));
                stats.put("poorCount", rs.getInt("poor_count"));
            }
        }
        
        // 获取成绩统计
        String scoreSql = "SELECT " +
                         "AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as avg_score, " +
                         "COUNT(CASE WHEN e.hyl_escore10 > 0 THEN 1 END) as total_scores " +
                         "FROM huyl_enroll10 e";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(scoreSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                double avgScore = rs.getDouble("avg_score");
                if (rs.wasNull()) {
                    avgScore = 0.0;
                }
                stats.put("avgScore", avgScore);
                stats.put("totalScores", rs.getInt("total_scores"));
            }
        }
        
        return stats;
    }
    
    /**
     * 按专业获取成绩分析
     */
    public Map<String, Object> getScoreAnalysisByMajor(String major) throws SQLException {
        Map<String, Object> analysis = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(DISTINCT s.hyl_sno10) as total_students, " +
                     "COUNT(DISTINCT e.hyl_tcno10) as total_courses, " +
                     "COUNT(CASE WHEN e.hyl_escore10 > 0 THEN 1 END) as total_scores, " +
                     "AVG(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as avg_score, " +
                     "MIN(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as min_score, " +
                     "MAX(CASE WHEN e.hyl_escore10 > 0 THEN e.hyl_escore10 ELSE NULL END) as max_score " +
                     "FROM huyl_student10 s " +
                     "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_enroll10 e ON s.hyl_sno10 = e.hyl_sno10 " +
                     "WHERE m.hyl_mname10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, major);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                analysis.put("totalStudents", rs.getInt("total_students"));
                analysis.put("totalCourses", rs.getInt("total_courses"));
                analysis.put("totalScores", rs.getInt("total_scores"));
                
                double avgScore = rs.getDouble("avg_score");
                if (rs.wasNull()) {
                    avgScore = 0.0;
                }
                analysis.put("avgScore", avgScore);
                
                int minScore = rs.getInt("min_score");
                if (rs.wasNull()) {
                    minScore = 0;
                }
                analysis.put("minScore", minScore);
                
                int maxScore = rs.getInt("max_score");
                if (rs.wasNull()) {
                    maxScore = 0;
                }
                analysis.put("maxScore", maxScore);
            }
        }
        
        return analysis;
    }
    
    /**
     * 按专业获取成绩分布
     */
    public Map<String, Object> getScoreDistributionByMajor(String major) throws SQLException {
        Map<String, Object> distribution = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 90 THEN 1 END) as excellent, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 80 AND e.hyl_escore10 < 90 THEN 1 END) as good, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 70 AND e.hyl_escore10 < 80 THEN 1 END) as average, " +
                     "COUNT(CASE WHEN e.hyl_escore10 >= 60 AND e.hyl_escore10 < 70 THEN 1 END) as pass, " +
                     "COUNT(CASE WHEN e.hyl_escore10 < 60 THEN 1 END) as fail " +
                     "FROM huyl_enroll10 e " +
                     "JOIN huyl_student10 s ON e.hyl_sno10 = s.hyl_sno10 " +
                     "JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                     "WHERE m.hyl_mname10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, major);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                distribution.put("excellent", rs.getInt("excellent"));
                distribution.put("good", rs.getInt("good"));
                distribution.put("average", rs.getInt("average"));
                distribution.put("pass", rs.getInt("pass"));
                distribution.put("fail", rs.getInt("fail"));
            }
        }
        
        return distribution;
    }
    
    /**
     * 获取学生专业排名信息
     */
    public Map<String, Object> getStudentRanking(Integer studentId) throws SQLException {
        Map<String, Object> ranking = new HashMap<>();
        
        // 获取学生信息
        String studentSql = "SELECT s.hyl_sno10, s.hyl_sname10, s.hyl_sgpa10, s.hyl_srank10, " +
                           "m.hyl_mname10 as major_name, m.hyl_mno10 " +
                           "FROM huyl_student10 s " +
                           "LEFT JOIN huyl_major10 m ON s.hyl_mno10 = m.hyl_mno10 " +
                           "WHERE s.hyl_sno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(studentSql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                ranking.put("studentId", rs.getInt("hyl_sno10"));
                ranking.put("studentName", rs.getString("hyl_sname10"));
                ranking.put("gpa", rs.getBigDecimal("hyl_sgpa10"));
                ranking.put("rank", rs.getInt("hyl_srank10"));
                ranking.put("majorName", rs.getString("major_name"));
                ranking.put("majorId", rs.getInt("hyl_mno10"));
                
                // 获取专业总人数
                String majorCountSql = "SELECT COUNT(*) as total_students " +
                                      "FROM huyl_student10 " +
                                      "WHERE hyl_mno10 = ?";
                
                try (PreparedStatement countPstmt = conn.prepareStatement(majorCountSql)) {
                    countPstmt.setInt(1, rs.getInt("hyl_mno10"));
                    ResultSet countRs = countPstmt.executeQuery();
                    
                    if (countRs.next()) {
                        int totalStudents = countRs.getInt("total_students");
                        ranking.put("totalStudents", totalStudents);
                        
                        // 计算排名百分比
                        int rank = rs.getInt("hyl_srank10");
                        if (rank > 0 && totalStudents > 0) {
                            double percentage = (double) rank / totalStudents * 100;
                            ranking.put("rankPercentage", Math.round(percentage * 100.0) / 100.0);
                        } else {
                            ranking.put("rankPercentage", 0.0);
                        }
                    }
                }
            }
        }
        
        return ranking;
    }
    
    /**
     * 将ResultSet映射到Student对象
     */
    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setHylSno10(rs.getInt("hyl_sno10"));
        student.setHylSage10(rs.getInt("hyl_sage10"));
        student.setHylSname10(rs.getString("hyl_sname10"));
        student.setHylSbirth10(rs.getDate("hyl_sbirth10"));
        student.setHylSplace10(rs.getString("hyl_splace10"));
        student.setHylSsex10(rs.getString("hyl_ssex10"));
        student.setHylScreditsum10(rs.getDouble("hyl_screditsum10"));
        student.setHylSemail10(rs.getString("hyl_semail10"));
        student.setHylSphone10(rs.getString("hyl_sphone10"));
        student.setHylSenrolldate10(rs.getDate("hyl_senrolldate10"));
        student.setHylSstatus10(rs.getString("hyl_sstatus10"));
        student.setHylSgpa10(rs.getDouble("hyl_sgpa10"));
        student.setHylSrank10(rs.getInt("hyl_srank10"));
        student.setHylMno10(rs.getInt("hyl_mno10"));
        student.setHylAcno10(rs.getInt("hyl_acno10"));
        student.setMajorName(rs.getString("major_name"));
        student.setClassName(rs.getString("class_name"));
        
        return student;
    }
    
    /**
     * 手动更新所有学生的GPA（基于选课成绩）
     */
    public void updateAllStudentsGPA() throws SQLException {
        String updateSql = "UPDATE huyl_student10 SET hyl_sgpa10 = (" +
                          "SELECT COALESCE(" +
                          "  ROUND(" +
                          "    SUM(CASE " +
                          "      WHEN e.hyl_escore10 >= 90 THEN 4.0 * c.hyl_ccredit10 " +
                          "      WHEN e.hyl_escore10 >= 80 THEN 3.0 * c.hyl_ccredit10 " +
                          "      WHEN e.hyl_escore10 >= 70 THEN 2.0 * c.hyl_ccredit10 " +
                          "      WHEN e.hyl_escore10 >= 60 THEN 1.0 * c.hyl_ccredit10 " +
                          "      ELSE 0.0 " +
                          "    END) / NULLIF(SUM(c.hyl_ccredit10), 0), 3" +
                          "  ), 0.0" +
                          ") " +
                          "FROM huyl_enroll10 e " +
                          "JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10 " +
                          "JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                          "WHERE e.hyl_sno10 = huyl_student10.hyl_sno10 " +
                          "  AND e.hyl_open10 = true " +
                          "  AND e.hyl_escore10 > 0" +
                          ")";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            
            int updatedRows = pstmt.executeUpdate();
            System.out.println("更新了 " + updatedRows + " 个学生的GPA");
        }
    }
} 