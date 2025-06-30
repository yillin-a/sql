package org.example.demo111.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.TeachingClass;
import org.example.demo111.util.DatabaseUtil;

/**
 * 教学班数据访问对象
 */
public class TeachingClassDAO {

    /**
     * 获取所有教学班
     */
    public List<TeachingClass> getAllTeachingClasses() throws SQLException {
        List<TeachingClass> teachingClasses = new ArrayList<>();
        String sql = "SELECT tc.*, c.hyl_cname10, c.hyl_ctype10, c.hyl_ccredit10, " +
                     "c.hyl_chour10, c.hyl_ctest10, t.hyl_tname10 " +
                     "FROM huyl_tclass10 tc " +
                     "LEFT JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10, c.hyl_cname10, tc.hyl_tcbatch10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                teachingClasses.add(mapResultSetToTeachingClass(rs));
            }
        }
        return teachingClasses;
    }

    /**
     * 根据ID获取教学班
     */
    public TeachingClass getTeachingClassById(Integer id) throws SQLException {
        String sql = "SELECT tc.*, c.hyl_cname10, c.hyl_ctype10, c.hyl_ccredit10, " +
                     "c.hyl_chour10, c.hyl_ctest10, t.hyl_tname10 " +
                     "FROM huyl_tclass10 tc " +
                     "LEFT JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE tc.hyl_tcno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTeachingClass(rs);
                }
            }
        }
        return null;
    }

    /**
     * 添加教学班
     */
    public boolean addTeachingClass(TeachingClass teachingClass) throws SQLException {
        String sql = "INSERT INTO huyl_tclass10 (hyl_tcname10, hyl_tcyear10, hyl_tcterm10, " +
                     "hyl_tcrepeat10, hyl_tcbatch10, hyl_tcmaxstu10, hyl_tccurstu10, " +
                     "hyl_cno10, hyl_tno10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, teachingClass.getHylTcname10());
            pstmt.setInt(2, teachingClass.getHylTcyear10());
            pstmt.setInt(3, teachingClass.getHylTcterm10());
            pstmt.setString(4, teachingClass.getHylTcrepeat10());
            pstmt.setString(5, teachingClass.getHylTcbatch10());
            pstmt.setInt(6, teachingClass.getHylTcmaxstu10());
            pstmt.setInt(7, teachingClass.getHylTccurstu10() != null ? teachingClass.getHylTccurstu10() : 0);
            pstmt.setInt(8, teachingClass.getHylCno10());
            pstmt.setInt(9, teachingClass.getHylTno10());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 更新教学班
     */
    public boolean updateTeachingClass(TeachingClass teachingClass) throws SQLException {
        String sql = "UPDATE huyl_tclass10 SET hyl_tcname10 = ?, hyl_tcyear10 = ?, " +
                     "hyl_tcterm10 = ?, hyl_tcrepeat10 = ?, hyl_tcbatch10 = ?, " +
                     "hyl_tcmaxstu10 = ?, hyl_cno10 = ?, hyl_tno10 = ? " +
                     "WHERE hyl_tcno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, teachingClass.getHylTcname10());
            pstmt.setInt(2, teachingClass.getHylTcyear10());
            pstmt.setInt(3, teachingClass.getHylTcterm10());
            pstmt.setString(4, teachingClass.getHylTcrepeat10());
            pstmt.setString(5, teachingClass.getHylTcbatch10());
            pstmt.setInt(6, teachingClass.getHylTcmaxstu10());
            pstmt.setInt(7, teachingClass.getHylCno10());
            pstmt.setInt(8, teachingClass.getHylTno10());
            pstmt.setInt(9, teachingClass.getHylTcno10());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 删除教学班
     */
    public boolean deleteTeachingClass(Integer id) throws SQLException {
        String sql = "DELETE FROM huyl_tclass10 WHERE hyl_tcno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 搜索教学班
     */
    public List<TeachingClass> searchTeachingClasses(String keyword) throws SQLException {
        List<TeachingClass> teachingClasses = new ArrayList<>();
        String sql = "SELECT tc.*, c.hyl_cname10, c.hyl_ctype10, c.hyl_ccredit10, " +
                     "c.hyl_chour10, c.hyl_ctest10, t.hyl_tname10 " +
                     "FROM huyl_tclass10 tc " +
                     "LEFT JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10 " +
                     "LEFT JOIN huyl_teacher10 t ON tc.hyl_tno10 = t.hyl_tno10 " +
                     "WHERE tc.hyl_tcname10 LIKE ? OR c.hyl_cname10 LIKE ? OR t.hyl_tname10 LIKE ? " +
                     "ORDER BY tc.hyl_tcyear10 DESC, tc.hyl_tcterm10, c.hyl_cname10, tc.hyl_tcbatch10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    teachingClasses.add(mapResultSetToTeachingClass(rs));
                }
            }
        }
        return teachingClasses;
    }

    /**
     * 获取可用的课程列表
     */
    public List<Map<String, Object>> getAvailableCourses() throws SQLException {
        List<Map<String, Object>> courses = new ArrayList<>();
        String sql = "SELECT hyl_cno10, hyl_cname10, hyl_ctype10 FROM huyl_course10 ORDER BY hyl_cname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("courseId", rs.getInt("hyl_cno10"));
                course.put("courseName", rs.getString("hyl_cname10"));
                course.put("courseType", rs.getString("hyl_ctype10"));
                courses.add(course);
            }
        }
        return courses;
    }

    /**
     * 获取可用的教师列表
     */
    public List<Map<String, Object>> getAvailableTeachers() throws SQLException {
        List<Map<String, Object>> teachers = new ArrayList<>();
        String sql = "SELECT hyl_tno10, hyl_tname10, hyl_ttitle10 FROM huyl_teacher10 " +
                     "WHERE hyl_tstatus10 = '在职' ORDER BY hyl_tname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> teacher = new HashMap<>();
                teacher.put("teacherId", rs.getInt("hyl_tno10"));
                teacher.put("teacherName", rs.getString("hyl_tname10"));
                teacher.put("title", rs.getString("hyl_ttitle10"));
                teachers.add(teacher);
            }
        }
        return teachers;
    }

    /**
     * 检查教学班是否冲突（同一课程、同一学期、同一班次）
     */
    public boolean isTeachingClassConflict(Integer courseId, Integer year, Integer term, String batch, Integer excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM huyl_tclass10 " +
                     "WHERE hyl_cno10 = ? AND hyl_tcyear10 = ? AND hyl_tcterm10 = ? AND hyl_tcbatch10 = ?";
        
        if (excludeId != null) {
            sql += " AND hyl_tcno10 != ?";
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, courseId);
            pstmt.setInt(2, year);
            pstmt.setInt(3, term);
            pstmt.setString(4, batch);
            
            if (excludeId != null) {
                pstmt.setInt(5, excludeId);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * 获取教学班统计信息
     */
    public Map<String, Object> getTeachingClassStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = "SELECT " +
                     "COUNT(*) as total_classes, " +
                     "SUM(hyl_tccurstu10) as total_students, " +
                     "AVG(hyl_tccurstu10) as avg_students, " +
                     "COUNT(DISTINCT hyl_cno10) as distinct_courses, " +
                     "COUNT(DISTINCT hyl_tno10) as distinct_teachers " +
                     "FROM huyl_tclass10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                stats.put("totalClasses", rs.getInt("total_classes"));
                stats.put("totalStudents", rs.getInt("total_students"));
                stats.put("avgStudents", rs.getDouble("avg_students"));
                stats.put("distinctCourses", rs.getInt("distinct_courses"));
                stats.put("distinctTeachers", rs.getInt("distinct_teachers"));
            }
        }
        return stats;
    }

    /**
     * 将ResultSet映射为TeachingClass对象
     */
    private TeachingClass mapResultSetToTeachingClass(ResultSet rs) throws SQLException {
        TeachingClass teachingClass = new TeachingClass();
        
        teachingClass.setHylTcno10(rs.getInt("hyl_tcno10"));
        teachingClass.setHylTcname10(rs.getString("hyl_tcname10"));
        teachingClass.setHylTcyear10(rs.getInt("hyl_tcyear10"));
        teachingClass.setHylTcterm10(rs.getInt("hyl_tcterm10"));
        teachingClass.setHylTcrepeat10(rs.getString("hyl_tcrepeat10"));
        teachingClass.setHylTcbatch10(rs.getString("hyl_tcbatch10"));
        teachingClass.setHylTcmaxstu10(rs.getInt("hyl_tcmaxstu10"));
        teachingClass.setHylTccurstu10(rs.getInt("hyl_tccurstu10"));
        teachingClass.setHylCno10(rs.getInt("hyl_cno10"));
        teachingClass.setHylTno10(rs.getInt("hyl_tno10"));
        
        // 设置关联字段
        teachingClass.setCourseName(rs.getString("hyl_cname10"));
        teachingClass.setTeacherName(rs.getString("hyl_tname10"));
        teachingClass.setCourseType(rs.getString("hyl_ctype10"));
        
        BigDecimal credit = rs.getBigDecimal("hyl_ccredit10");
        if (credit != null) {
            teachingClass.setCourseCredit(credit.doubleValue());
        }
        
        teachingClass.setCourseHour(rs.getInt("hyl_chour10"));
        teachingClass.setTestType(rs.getString("hyl_ctest10"));
        
        return teachingClass;
    }
} 