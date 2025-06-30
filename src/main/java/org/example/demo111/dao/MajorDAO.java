package org.example.demo111.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Major;
import org.example.demo111.util.DatabaseUtil;

/**
 * 专业数据访问对象
 */
public class MajorDAO {
    
    /**
     * 获取所有专业
     */
    public List<Major> findAll() throws SQLException {
        List<Major> majors = new ArrayList<>();
        String sql = "SELECT m.*, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_mno10 = m.hyl_mno10) as student_count " +
                     "FROM huyl_major10 m " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "ORDER BY m.hyl_mno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Major major = mapResultSetToMajor(rs);
                majors.add(major);
            }
        }
        
        return majors;
    }
    
    /**
     * 根据专业编号查询专业
     */
    public Major findById(Integer majorId) throws SQLException {
        String sql = "SELECT m.*, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_mno10 = m.hyl_mno10) as student_count " +
                     "FROM huyl_major10 m " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE m.hyl_mno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, majorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToMajor(rs);
            }
        }
        
        return null;
    }
    
    /**
     * 根据专业名称和学院查询专业（检查重复）
     */
    public Major findByNameAndFaculty(String majorName, Integer facultyId) throws SQLException {
        String sql = "SELECT m.*, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_mno10 = m.hyl_mno10) as student_count " +
                     "FROM huyl_major10 m " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE m.hyl_mname10 = ? AND m.hyl_fno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, majorName);
            pstmt.setInt(2, facultyId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToMajor(rs);
            }
        }
        
        return null;
    }
    
    /**
     * 添加专业
     */
    public boolean addMajor(Major major) throws SQLException {
        String sql = "INSERT INTO huyl_major10 (hyl_mname10, hyl_mdegree10, hyl_myears10, hyl_fno10) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, major.getHylMname10());
            pstmt.setString(2, major.getHylMdegree10());
            pstmt.setInt(3, major.getHylMyears10());
            pstmt.setInt(4, major.getHylFno10());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新专业信息
     */
    public boolean updateMajor(Major major) throws SQLException {
        String sql = "UPDATE huyl_major10 SET hyl_mname10 = ?, hyl_mdegree10 = ?, " +
                     "hyl_myears10 = ?, hyl_fno10 = ? WHERE hyl_mno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, major.getHylMname10());
            pstmt.setString(2, major.getHylMdegree10());
            pstmt.setInt(3, major.getHylMyears10());
            pstmt.setInt(4, major.getHylFno10());
            pstmt.setInt(5, major.getHylMno10());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 删除专业
     */
    public boolean deleteMajor(Integer majorId) throws SQLException {
        String sql = "DELETE FROM huyl_major10 WHERE hyl_mno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, majorId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 检查专业是否存在学生（用于删除前检查）
     */
    public boolean hasStudents(Integer majorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM huyl_student10 WHERE hyl_mno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, majorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }
    
    /**
     * 搜索专业
     */
    public List<Major> searchMajors(String keyword, Integer facultyId) throws SQLException {
        List<Major> majors = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT m.*, f.hyl_fname10 as faculty_name, ");
        sql.append("(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_mno10 = m.hyl_mno10) as student_count ");
        sql.append("FROM huyl_major10 m ");
        sql.append("LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (m.hyl_mname10 ILIKE ? OR f.hyl_fname10 ILIKE ?) ");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        
        if (facultyId != null && facultyId > 0) {
            sql.append("AND m.hyl_fno10 = ? ");
            params.add(facultyId);
        }
        
        sql.append("ORDER BY m.hyl_mno10");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Major major = mapResultSetToMajor(rs);
                majors.add(major);
            }
        }
        
        return majors;
    }
    
    /**
     * 获取专业统计信息
     */
    public Map<String, Object> getMajorStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = "SELECT " +
                     "COUNT(*) as total_majors, " +
                     "COUNT(CASE WHEN hyl_mdegree10 = '本科' THEN 1 END) as undergraduate_count, " +
                     "COUNT(CASE WHEN hyl_mdegree10 = '硕士' THEN 1 END) as master_count, " +
                     "COUNT(CASE WHEN hyl_mdegree10 = '博士' THEN 1 END) as doctoral_count, " +
                     "COUNT(DISTINCT hyl_fno10) as faculty_count, " +
                     "ROUND(AVG(hyl_myears10), 1) as avg_years " +
                     "FROM huyl_major10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalMajors", rs.getInt("total_majors"));
                stats.put("undergraduateCount", rs.getInt("undergraduate_count"));
                stats.put("masterCount", rs.getInt("master_count"));
                stats.put("doctoralCount", rs.getInt("doctoral_count"));
                stats.put("facultyCount", rs.getInt("faculty_count"));
                stats.put("avgYears", rs.getDouble("avg_years"));
            }
        }
        
        // 获取学生总数
        String studentSql = "SELECT COUNT(*) as total_students FROM huyl_student10";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(studentSql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalStudents", rs.getInt("total_students"));
            }
        }
        
        return stats;
    }
    
    /**
     * 获取各学院专业分布
     */
    public List<Map<String, Object>> getFacultyMajorDistribution() throws SQLException {
        List<Map<String, Object>> distribution = new ArrayList<>();
        String sql = "SELECT f.hyl_fname10 as faculty_name, " +
                     "COUNT(DISTINCT m.hyl_mno10) as major_count, " +
                     "COUNT(DISTINCT s.hyl_sno10) as student_count " +
                     "FROM huyl_faculty10 f " +
                     "LEFT JOIN huyl_major10 m ON f.hyl_fno10 = m.hyl_fno10 " +
                     "LEFT JOIN huyl_student10 s ON m.hyl_mno10 = s.hyl_mno10 " +
                     "GROUP BY f.hyl_fno10, f.hyl_fname10 " +
                     "ORDER BY major_count DESC, faculty_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("facultyName", rs.getString("faculty_name"));
                item.put("majorCount", rs.getInt("major_count"));
                item.put("studentCount", rs.getInt("student_count"));
                distribution.add(item);
            }
        }
        
        return distribution;
    }
    
    /**
     * 获取所有学院列表（用于下拉选择）
     */
    public List<Map<String, Object>> getAllFaculties() throws SQLException {
        List<Map<String, Object>> faculties = new ArrayList<>();
        String sql = "SELECT hyl_fno10, hyl_fname10 FROM huyl_faculty10 ORDER BY hyl_fno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> faculty = new HashMap<>();
                faculty.put("facultyId", rs.getInt("hyl_fno10"));
                faculty.put("facultyName", rs.getString("hyl_fname10"));
                faculties.add(faculty);
            }
        }
        
        return faculties;
    }
    
    /**
     * 将ResultSet映射到Major对象
     */
    private Major mapResultSetToMajor(ResultSet rs) throws SQLException {
        Major major = new Major();
        major.setHylMno10(rs.getInt("hyl_mno10"));
        major.setHylMname10(rs.getString("hyl_mname10"));
        major.setHylMdegree10(rs.getString("hyl_mdegree10"));
        major.setHylMyears10(rs.getInt("hyl_myears10"));
        major.setHylFno10(rs.getInt("hyl_fno10"));
        major.setFacultyName(rs.getString("faculty_name"));
        major.setStudentCount(rs.getInt("student_count"));
        
        return major;
    }
} 