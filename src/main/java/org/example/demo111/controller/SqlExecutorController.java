package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo111.util.DatabaseUtil;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/sql/execute")
public class SqlExecutorController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String script = request.getParameter("script");
        List<Map<String, Object>> results = new ArrayList<>();
        
        if ("user_init".equals(script)) {
            results = executeUserInitScript();
        } else if ("test_connection".equals(script)) {
            results = testDatabaseConnection();
        } else {
            Map<String, Object> result = new HashMap<>();
            result.put("status", "错误");
            result.put("message", "未知的脚本类型: " + script);
            results.add(result);
        }
        
        request.setAttribute("results", results);
        request.getRequestDispatcher("/WEB-INF/views/sql-result.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<Map<String, Object>> executeUserInitScript() {
        List<Map<String, Object>> results = new ArrayList<>();
        
        try {
            // 读取SQL脚本文件
            String sqlScript = readSqlScript("/user_init.sql");
            if (sqlScript == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "错误");
                result.put("message", "无法读取 user_init.sql 文件");
                results.add(result);
                return results;
            }
            
            // 分割SQL语句
            String[] statements = sqlScript.split(";");
            
            try (Connection conn = DatabaseUtil.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                for (int i = 0; i < statements.length; i++) {
                    String sql = statements[i].trim();
                    if (!sql.isEmpty() && !sql.startsWith("--")) {
                        try {
                            stmt.execute(sql);
                            
                            Map<String, Object> result = new HashMap<>();
                            result.put("status", "成功");
                            result.put("message", "执行SQL语句 " + (i + 1) + " 成功");
                            result.put("sql", sql.substring(0, Math.min(100, sql.length())) + "...");
                            results.add(result);
                            
                        } catch (Exception e) {
                            Map<String, Object> result = new HashMap<>();
                            result.put("status", "错误");
                            result.put("message", "执行SQL语句 " + (i + 1) + " 失败");
                            result.put("sql", sql.substring(0, Math.min(100, sql.length())) + "...");
                            result.put("error", e.getMessage());
                            results.add(result);
                        }
                    }
                }
                
                // 验证执行结果
                Map<String, Object> verifyResult = verifyUserTable();
                results.add(verifyResult);
                
            }
            
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("status", "错误");
            result.put("message", "执行用户初始化脚本时发生异常");
            result.put("error", e.getMessage());
            results.add(result);
        }
        
        return results;
    }
    
    private List<Map<String, Object>> testDatabaseConnection() {
        List<Map<String, Object>> results = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            Map<String, Object> result = new HashMap<>();
            result.put("status", "成功");
            result.put("message", "数据库连接测试成功");
            result.put("details", "连接URL: " + conn.getMetaData().getURL());
            results.add(result);
            
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("status", "错误");
            result.put("message", "数据库连接测试失败");
            result.put("error", e.getMessage());
            results.add(result);
        }
        
        return results;
    }
    
    private String readSqlScript(String resourcePath) {
        try (InputStream is = getClass().getResourceAsStream(resourcePath)) {
            if (is == null) {
                return null;
            }
            byte[] bytes = is.readAllBytes();
            return new String(bytes, StandardCharsets.UTF_8);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private Map<String, Object> verifyUserTable() {
        Map<String, Object> result = new HashMap<>();
        result.put("status", "验证");
        result.put("message", "验证用户表创建结果");
        
        try (Connection conn = DatabaseUtil.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT COUNT(*) FROM huyl_users10")) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                result.put("details", "用户表创建成功，共有 " + count + " 个用户");
            } else {
                result.put("details", "用户表创建成功，但无法获取用户数量");
            }
            
        } catch (Exception e) {
            result.put("status", "错误");
            result.put("message", "验证用户表时发生异常");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
} 