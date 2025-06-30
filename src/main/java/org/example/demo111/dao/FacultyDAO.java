package org.example.demo111.dao;

import org.example.demo111.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 学院数据访问对象
 */
public class FacultyDAO {
    
    /**
     * 获取所有学院
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
     * 根据学院编号获取学院名称
     */
    public String getFacultyNameById(Integer facultyId) throws SQLException {
        if (facultyId == null) {
            return null;
        }
        
        String sql = "SELECT hyl_fname10 FROM huyl_faculty10 WHERE hyl_fno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, facultyId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("hyl_fname10");
            }
        }
        
        return null;
    }
    
    /**
     * 根据学院名称获取学院编号
     */
    public Integer getFacultyIdByName(String facultyName) throws SQLException {
        if (facultyName == null || facultyName.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT hyl_fno10 FROM huyl_faculty10 WHERE hyl_fname10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, facultyName.trim());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("hyl_fno10");
            }
        }
        
        return null;
    }
    
    /**
     * 添加学院
     */
    public boolean addFaculty(String facultyName, String description) throws SQLException {
        String sql = "INSERT INTO huyl_faculty10 (hyl_fname10, hyl_fdesc10) VALUES (?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, facultyName);
            pstmt.setString(2, description);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新学院信息
     */
    public boolean updateFaculty(Integer facultyId, String facultyName, String description) throws SQLException {
        String sql = "UPDATE huyl_faculty10 SET hyl_fname10 = ?, hyl_fdesc10 = ? WHERE hyl_fno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, facultyName);
            pstmt.setString(2, description);
            pstmt.setInt(3, facultyId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 删除学院
     */
    public boolean deleteFaculty(Integer facultyId) throws SQLException {
        String sql = "DELETE FROM huyl_faculty10 WHERE hyl_fno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, facultyId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 检查学院是否存在
     */
    public boolean existsById(Integer facultyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM huyl_faculty10 WHERE hyl_fno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, facultyId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }
} 