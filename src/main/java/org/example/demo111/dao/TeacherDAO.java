package org.example.demo111.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.example.demo111.model.Teacher;
import org.example.demo111.util.DatabaseUtil;

/**
 * 教师数据访问对象
 */
public class TeacherDAO {
    
    /**
     * 查询所有教师
     */
    public List<Teacher> findAll() throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        String sql = "SELECT t.*, f.hyl_fname10 as faculty_name " +
                     "FROM huyl_teacher10 t " +
                     "LEFT JOIN huyl_faculty10 f ON t.hyl_fno10 = f.hyl_fno10 " +
                     "ORDER BY t.hyl_tno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    /**
     * 根据教师编号查询教师
     */
    public Teacher findByTeacherId(Integer teacherId) throws SQLException {
        String sql = "SELECT t.*, f.hyl_fname10 as faculty_name " +
                     "FROM huyl_teacher10 t " +
                     "LEFT JOIN huyl_faculty10 f ON t.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE t.hyl_tno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTeacher(rs);
            }
        }
        
        return null;
    }
    
    /**
     * 根据姓名模糊查询教师
     */
    public List<Teacher> findByName(String name) throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        String sql = "SELECT t.*, f.hyl_fname10 as faculty_name " +
                     "FROM huyl_teacher10 t " +
                     "LEFT JOIN huyl_faculty10 f ON t.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE t.hyl_tname10 ILIKE ? " +
                     "ORDER BY t.hyl_tno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    /**
     * 根据职称查询教师
     */
    public List<Teacher> findByTitle(String title) throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        String sql = "SELECT t.*, f.hyl_fname10 as faculty_name " +
                     "FROM huyl_teacher10 t " +
                     "LEFT JOIN huyl_faculty10 f ON t.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE t.hyl_ttitle10 = ? " +
                     "ORDER BY t.hyl_tno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, title);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    /**
     * 添加教师
     */
    public boolean addTeacher(Teacher teacher) throws SQLException {
        String sql = "INSERT INTO huyl_teacher10 (hyl_tage10, hyl_tname10, hyl_tbirth10, hyl_ttitle10, " +
                     "hyl_tsex10, hyl_temail10, hyl_toffice10, hyl_tphone10, hyl_fno10) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacher.getHylTage10());
            pstmt.setString(2, teacher.getHylTname10());
            
            // 处理出生日期，如果为null则设置为null
            if (teacher.getHylTbirth10() != null) {
                pstmt.setDate(3, new java.sql.Date(teacher.getHylTbirth10().getTime()));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            
            pstmt.setString(4, teacher.getHylTtitle10());
            pstmt.setString(5, teacher.getHylTsex10());
            pstmt.setString(6, teacher.getHylTemail10());
            pstmt.setString(7, teacher.getHylToffice10());
            pstmt.setString(8, teacher.getHylTphone10());
            
            // 处理学院编号，如果为null则设置为null
            if (teacher.getHylFno10() != null) {
                pstmt.setInt(9, teacher.getHylFno10());
            } else {
                pstmt.setNull(9, java.sql.Types.INTEGER);
            }
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新教师信息
     */
    public boolean updateTeacher(Teacher teacher) throws SQLException {
        String sql = "UPDATE huyl_teacher10 SET hyl_tage10=?, hyl_tname10=?, hyl_tbirth10=?, " +
                     "hyl_ttitle10=?, hyl_tsex10=?, hyl_temail10=?, hyl_toffice10=?, " +
                     "hyl_tphone10=?, hyl_fno10=? WHERE hyl_tno10=?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacher.getHylTage10());
            pstmt.setString(2, teacher.getHylTname10());
            
            // 处理出生日期，如果为null则设置为null
            if (teacher.getHylTbirth10() != null) {
                pstmt.setDate(3, new java.sql.Date(teacher.getHylTbirth10().getTime()));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            
            pstmt.setString(4, teacher.getHylTtitle10());
            pstmt.setString(5, teacher.getHylTsex10());
            pstmt.setString(6, teacher.getHylTemail10());
            pstmt.setString(7, teacher.getHylToffice10());
            pstmt.setString(8, teacher.getHylTphone10());
            
            // 处理学院编号，如果为null则设置为null
            if (teacher.getHylFno10() != null) {
                pstmt.setInt(9, teacher.getHylFno10());
            } else {
                pstmt.setNull(9, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(10, teacher.getHylTno10());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 删除教师
     */
    public boolean deleteTeacher(Integer teacherId) throws SQLException {
        String sql = "DELETE FROM huyl_teacher10 WHERE hyl_tno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacherId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 更新教师状态
     */
    public boolean updateTeacherStatus(Integer teacherId, String status) throws SQLException {
        String sql = "UPDATE huyl_teacher10 SET hyl_tstatus10 = ? WHERE hyl_tno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, teacherId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 查询在职教师
     */
    public List<Teacher> findActiveTeachers() throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        String sql = "SELECT t.*, f.hyl_fname10 as faculty_name " +
                     "FROM huyl_teacher10 t " +
                     "LEFT JOIN huyl_faculty10 f ON t.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE t.hyl_tstatus10 = '在职' " +
                     "ORDER BY t.hyl_tno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    /**
     * 更新教师个人资料（仅邮箱和电话）
     */
    public boolean updateTeacherProfile(Integer teacherId, String email, String phone) throws SQLException {
        String sql = "UPDATE huyl_teacher10 SET hyl_temail10 = ?, hyl_tphone10 = ? WHERE hyl_tno10 = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, phone);
            pstmt.setInt(3, teacherId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * 将ResultSet映射到Teacher对象
     */
    private Teacher mapResultSetToTeacher(ResultSet rs) throws SQLException {
        Teacher teacher = new Teacher();
        teacher.setHylTno10(rs.getInt("hyl_tno10"));
        teacher.setHylTage10(rs.getInt("hyl_tage10"));
        teacher.setHylTname10(rs.getString("hyl_tname10"));
        teacher.setHylTbirth10(rs.getDate("hyl_tbirth10"));
        teacher.setHylTtitle10(rs.getString("hyl_ttitle10"));
        teacher.setHylTsex10(rs.getString("hyl_tsex10"));
        teacher.setHylTemail10(rs.getString("hyl_temail10"));
        teacher.setHylToffice10(rs.getString("hyl_toffice10"));
        teacher.setHylTphone10(rs.getString("hyl_tphone10"));
        teacher.setHylTjoindate10(rs.getDate("hyl_tjoindate10"));
        teacher.setHylTstatus10(rs.getString("hyl_tstatus10"));
        teacher.setHylFno10(rs.getInt("hyl_fno10"));
        teacher.setFacultyName(rs.getString("faculty_name"));
        
        return teacher;
    }
} 