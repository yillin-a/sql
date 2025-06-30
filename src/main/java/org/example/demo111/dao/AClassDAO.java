package org.example.demo111.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.example.demo111.model.AClass;
import org.example.demo111.util.DatabaseUtil;

/**
 * 行政班数据访问对象
 */
public class AClassDAO {

    /**
     * 获取所有行政班
     */
    public List<AClass> getAllAClasses() throws SQLException {
        List<AClass> aClasses = new ArrayList<>();
        String sql = "SELECT ac.*, m.hyl_mname10 as major_name, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_acno10 = ac.hyl_acno10) as current_students " +
                     "FROM huyl_aclass10 ac " +
                     "LEFT JOIN huyl_major10 m ON ac.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "ORDER BY ac.hyl_acyear10 DESC, m.hyl_mname10, ac.hyl_acname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                aClasses.add(mapResultSetToAClass(rs));
            }
        }
        return aClasses;
    }

    /**
     * 根据ID获取行政班
     */
    public AClass getAClassById(Integer id) throws SQLException {
        String sql = "SELECT ac.*, m.hyl_mname10 as major_name, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_acno10 = ac.hyl_acno10) as current_students " +
                     "FROM huyl_aclass10 ac " +
                     "LEFT JOIN huyl_major10 m ON ac.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE ac.hyl_acno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAClass(rs);
                }
            }
        }
        return null;
    }

    /**
     * 根据专业获取行政班列表
     */
    public List<AClass> getAClassesByMajor(Integer majorId) throws SQLException {
        List<AClass> aClasses = new ArrayList<>();
        String sql = "SELECT ac.*, m.hyl_mname10 as major_name, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_acno10 = ac.hyl_acno10) as current_students " +
                     "FROM huyl_aclass10 ac " +
                     "LEFT JOIN huyl_major10 m ON ac.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE ac.hyl_mno10 = ? " +
                     "ORDER BY ac.hyl_acyear10 DESC, ac.hyl_acname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, majorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    aClasses.add(mapResultSetToAClass(rs));
                }
            }
        }
        return aClasses;
    }

    /**
     * 添加行政班
     */
    public boolean addAClass(AClass aClass) throws SQLException {
        String sql = "INSERT INTO huyl_aclass10 (hyl_acname10, hyl_acyear10, hyl_acmaxstu10, hyl_mno10) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, aClass.getHylAcname10());
            pstmt.setInt(2, aClass.getHylAcyear10());
            pstmt.setInt(3, aClass.getHylAcmaxstu10());
            pstmt.setInt(4, aClass.getHylMno10());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 更新行政班
     */
    public boolean updateAClass(AClass aClass) throws SQLException {
        String sql = "UPDATE huyl_aclass10 SET hyl_acname10 = ?, hyl_acyear10 = ?, " +
                     "hyl_acmaxstu10 = ?, hyl_mno10 = ? WHERE hyl_acno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, aClass.getHylAcname10());
            pstmt.setInt(2, aClass.getHylAcyear10());
            pstmt.setInt(3, aClass.getHylAcmaxstu10());
            pstmt.setInt(4, aClass.getHylMno10());
            pstmt.setInt(5, aClass.getHylAcno10());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 删除行政班
     */
    public boolean deleteAClass(Integer id) throws SQLException {
        String sql = "DELETE FROM huyl_aclass10 WHERE hyl_acno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * 搜索行政班
     */
    public List<AClass> searchAClasses(String keyword) throws SQLException {
        List<AClass> aClasses = new ArrayList<>();
        String sql = "SELECT ac.*, m.hyl_mname10 as major_name, f.hyl_fname10 as faculty_name, " +
                     "(SELECT COUNT(*) FROM huyl_student10 s WHERE s.hyl_acno10 = ac.hyl_acno10) as current_students " +
                     "FROM huyl_aclass10 ac " +
                     "LEFT JOIN huyl_major10 m ON ac.hyl_mno10 = m.hyl_mno10 " +
                     "LEFT JOIN huyl_faculty10 f ON m.hyl_fno10 = f.hyl_fno10 " +
                     "WHERE ac.hyl_acname10 LIKE ? OR m.hyl_mname10 LIKE ? OR f.hyl_fname10 LIKE ? " +
                     "ORDER BY ac.hyl_acyear10 DESC, m.hyl_mname10, ac.hyl_acname10";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    aClasses.add(mapResultSetToAClass(rs));
                }
            }
        }
        return aClasses;
    }

    /**
     * 检查行政班是否冲突（同一专业内班级名称唯一）
     */
    public boolean isAClassConflict(String className, Integer majorId, Integer excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM huyl_aclass10 WHERE hyl_acname10 = ? AND hyl_mno10 = ?";
        if (excludeId != null) {
            sql += " AND hyl_acno10 != ?";
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, className);
            pstmt.setInt(2, majorId);
            if (excludeId != null) {
                pstmt.setInt(3, excludeId);
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
     * 检查行政班是否有学生
     */
    public boolean hasStudents(Integer aClassId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM huyl_student10 WHERE hyl_acno10 = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, aClassId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * 将ResultSet映射到AClass对象
     */
    private AClass mapResultSetToAClass(ResultSet rs) throws SQLException {
        AClass aClass = new AClass();
        aClass.setHylAcno10(rs.getInt("hyl_acno10"));
        aClass.setHylAcname10(rs.getString("hyl_acname10"));
        aClass.setHylAcyear10(rs.getInt("hyl_acyear10"));
        aClass.setHylAcmaxstu10(rs.getInt("hyl_acmaxstu10"));
        aClass.setHylMno10(rs.getInt("hyl_mno10"));
        aClass.setMajorName(rs.getString("major_name"));
        aClass.setFacultyName(rs.getString("faculty_name"));
        aClass.setCurrentStudents(rs.getInt("current_students"));
        return aClass;
    }
} 