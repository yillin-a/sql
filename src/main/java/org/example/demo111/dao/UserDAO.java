package org.example.demo111.dao;

import org.example.demo111.model.User;
import org.example.demo111.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    /**
     * 根据用户ID和密码验证用户登录
     */
    public User authenticateUser(String uno, String password) {

        System.out.println("in dao");
        System.out.println("uno: " + uno);
        System.out.println("password: " + password);


        String sql = "SELECT * FROM huyl_user10 WHERE hyl_uno10 = ? AND hyl_upassword10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, Integer.parseInt(uno));
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("hyl_uno10"));
                    user.setUsername(rs.getString("hyl_uname10"));
                    user.setPassword(rs.getString("hyl_upassword10"));
                    user.setUserType(rs.getString("hyl_utype10"));
                    user.setRealName(rs.getString("hyl_uname10")); // 使用用户名作为真实姓名
                    user.setEmail(rs.getString("hyl_uname10") + "@univ.edu"); // 生成默认邮箱
                    user.setPhone(""); // 默认空电话
                    user.setStatus("正常"); // 默认状态
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 根据用户ID获取用户信息
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM huyl_user10 WHERE hyl_uno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("hyl_uno10"));
                    user.setUsername(rs.getString("hyl_uname10"));
                    user.setPassword(rs.getString("hyl_upassword10"));
                    user.setUserType(rs.getString("hyl_utype10"));
                    user.setRealName(rs.getString("hyl_uname10"));
                    user.setEmail(rs.getString("hyl_uname10") + "@univ.edu");
                    user.setPhone("");
                    user.setStatus("正常");
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 根据用户类型获取用户列表
     */
    public List<User> getUsersByType(String userType) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM huyl_user10 WHERE hyl_utype10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userType);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("hyl_uno10"));
                    user.setUsername(rs.getString("hyl_uname10"));
                    user.setPassword(rs.getString("hyl_upassword10"));
                    user.setUserType(rs.getString("hyl_utype10"));
                    user.setRealName(rs.getString("hyl_uname10"));
                    user.setEmail(rs.getString("hyl_uname10") + "@univ.edu");
                    user.setPhone("");
                    user.setStatus("正常");
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * 更新用户密码
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE huyl_user10 SET hyl_upassword10 = ? WHERE hyl_uno10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * 检查用户名是否存在
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM huyl_user10 WHERE hyl_uname10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * 创建新用户
     */
    public boolean createUser(User user) {
        String sql = "INSERT INTO huyl_user10 (hyl_uname10, hyl_upassword10, hyl_utype10, hyl_ucreated10) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getUserType());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * 根据用户名获取用户信息
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM huyl_user10 WHERE hyl_uname10 = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("hyl_uno10"));
                    user.setUsername(rs.getString("hyl_uname10"));
                    user.setPassword(rs.getString("hyl_upassword10"));
                    user.setUserType(rs.getString("hyl_utype10"));
                    user.setRealName(rs.getString("hyl_uname10"));
                    user.setEmail(rs.getString("hyl_uname10") + "@univ.edu");
                    user.setPhone("");
                    user.setStatus("正常");
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM huyl_user10 ORDER BY hyl_uno10";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("hyl_uno10"));
                user.setUsername(rs.getString("hyl_uname10"));
                user.setPassword(rs.getString("hyl_upassword10"));
                user.setUserType(rs.getString("hyl_utype10"));
                user.setRealName(rs.getString("hyl_uname10"));
                user.setEmail(rs.getString("hyl_uname10") + "@univ.edu");
                user.setPhone("");
                user.setStatus("正常");
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
} 