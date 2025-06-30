package org.example.demo111.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

/**
 * 数据库连接工具类
 */
public class DatabaseUtil {
    private static final String CONFIG_FILE = "database.properties";
    private static String url;
    private static String username;
    private static String password;
    
    static {
        loadConfig();
        // 加载PostgreSQL驱动
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("PostgreSQL驱动加载成功");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL驱动加载失败: " + e.getMessage());
        }
    }
    
    /**
     * 加载数据库配置
     */
    private static void loadConfig() {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (input == null) {
                System.err.println("未找到数据库配置文件，使用默认配置");
                // 使用默认配置
                url = "jdbc:postgresql://127.0.0.1:5432/postgres";
                username = "yillin";
                password = "Admin@123";
                return;
            }
            
            Properties prop = new Properties();
            prop.load(input);
            
            url = prop.getProperty("db.url", "jdbc:postgresql://127.0.0.1:5432/postgres");
            username = prop.getProperty("db.username", "yillin");
            password = prop.getProperty("db.password", "Admin@123");
            
            System.out.println("数据库配置加载成功:");
            System.out.println("URL: " + url);
            System.out.println("用户名: " + username);
            
        } catch (Exception e) {
            System.err.println("加载数据库配置失败: " + e.getMessage());
            // 使用默认配置
            url = "jdbc:postgresql://127.0.0.1:5432/postgres";
            username = "yillin";
            password = "Admin@123";
        }
    }
    
    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            System.out.println("数据库连接成功");
            return connection;
        } catch (SQLException e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            System.err.println("连接URL: " + url);
            System.err.println("用户名: " + username);
            throw e;
        }
    }
    
    /**
     * 测试数据库连接
     */
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            System.out.println("数据库连接测试成功");
            return true;
        } catch (SQLException e) {
            System.err.println("数据库连接测试失败: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 关闭数据库连接
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("数据库连接已关闭");
            } catch (SQLException e) {
                System.err.println("关闭数据库连接失败: " + e.getMessage());
            }
        }
    }
    
    /**
     * 获取数据库连接信息（用于调试）
     */
    public static String getConnectionInfo() {
        return String.format("URL: %s, 用户名: %s", url, username);
    }
} 