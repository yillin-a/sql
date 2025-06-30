package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo111.dao.FacultyDAO;
import org.example.demo111.model.Student;
import org.example.demo111.util.DatabaseUtil;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据库测试控制器
 */
@WebServlet("/test/database")
public class DatabaseTestController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> testResults = new ArrayList<>();
        
        // 测试1: 数据库连接
        testResults.add(testDatabaseConnection());
        
        // 测试2: 检查用户表是否存在
        testResults.add(testUserTableExists());
        
        // 测试3: 检查用户数据
        testResults.add(testUserData());
        
        // 测试4: 检查基础表数据
        testResults.add(testBasicTables());
        
        // 测试5: 测试用户登录功能
        testResults.add(testUserLogin());
        
        request.setAttribute("testResults", testResults);
        request.getRequestDispatcher("/WEB-INF/views/test.jsp").forward(request, response);
    }
    
    private Map<String, Object> testDatabaseConnection() {
        Map<String, Object> result = new HashMap<>();
        result.put("testName", "数据库连接测试");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                result.put("status", "成功");
                result.put("message", "数据库连接正常");
                result.put("details", "连接URL: " + conn.getMetaData().getURL());
            } else {
                result.put("status", "失败");
                result.put("message", "数据库连接失败");
            }
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "数据库连接异常: " + e.getMessage());
            result.put("details", e.toString());
        }
        
        return result;
    }
    
    private Map<String, Object> testUserTableExists() {
        Map<String, Object> result = new HashMap<>();
        result.put("testName", "用户表检查");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, null, "huyl_user10", new String[]{"TABLE"});
            
            if (tables.next()) {
                result.put("status", "成功");
                result.put("message", "用户表 huyl_user10 存在");
                
                // 检查表结构
                ResultSet columns = metaData.getColumns(null, null, "huyl_user10", null);
                List<String> columnNames = new ArrayList<>();
                while (columns.next()) {
                    columnNames.add(columns.getString("COLUMN_NAME"));
                }
                result.put("details", "表字段: " + String.join(", ", columnNames));
            } else {
                result.put("status", "失败");
                result.put("message", "用户表 huyl_user10 不存在");
                result.put("details", "请执行 user_init.sql 脚本创建用户表");
            }
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "检查用户表时发生异常: " + e.getMessage());
            result.put("details", e.toString());
        }
        
        return result;
    }
    
    private Map<String, Object> testUserData() {
        Map<String, Object> result = new HashMap<>();
        result.put("testName", "用户数据检查");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) as total, user_type, COUNT(*) as count FROM huyl_user10 GROUP BY user_type");
             ResultSet rs = pstmt.executeQuery()) {
            
            List<String> userStats = new ArrayList<>();
            int totalUsers = 0;
            
            while (rs.next()) {
                String userType = rs.getString("user_type");
                int count = rs.getInt("count");
                totalUsers += count;
                userStats.add(userType + ": " + count + "个");
            }
            
            if (totalUsers > 0) {
                result.put("status", "成功");
                result.put("message", "用户数据存在，总计: " + totalUsers + "个用户");
                result.put("details", "用户分布: " + String.join(", ", userStats));
            } else {
                result.put("status", "警告");
                result.put("message", "用户表中没有数据");
                result.put("details", "请执行 user_init.sql 脚本插入用户数据");
            }
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "检查用户数据时发生异常: " + e.getMessage());
            result.put("details", e.toString());
        }
        
        return result;
    }
    
    private Map<String, Object> testBasicTables() {
        Map<String, Object> result = new HashMap<>();
        result.put("testName", "基础表数据检查");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String[] tables = {"huyl_student10", "huyl_teacher10", "huyl_course10", "huyl_enroll10"};
            List<String> tableStats = new ArrayList<>();
            
            for (String table : tables) {
                try (PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM " + table);
                     ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        tableStats.add(table + ": " + count + "条记录");
                    }
                }
            }
            
            result.put("status", "成功");
            result.put("message", "基础表数据检查完成");
            result.put("details", "表数据: " + String.join(", ", tableStats));
            
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "检查基础表数据时发生异常: " + e.getMessage());
            result.put("details", e.toString());
        }
        
        return result;
    }
    
    private Map<String, Object> testUserLogin() {
        Map<String, Object> result = new HashMap<>();
        result.put("testName", "用户登录功能测试");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM huyl_user10 WHERE username = ? AND password = ?")) {
            
            // 测试管理员登录
            pstmt.setString(1, "100001");
            pstmt.setString(2, "100001");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result.put("status", "成功");
                    result.put("message", "用户登录功能正常");
                    result.put("details", "测试账号 100001 可以正常验证");
                } else {
                    result.put("status", "警告");
                    result.put("message", "测试账号 100001 验证失败");
                    result.put("details", "请检查用户数据是否正确插入");
                }
            }
            
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "测试用户登录功能时发生异常: " + e.getMessage());
            result.put("details", e.toString());
        }
        
        return result;
    }
} 