package org.example.demo111.service;

import org.example.demo111.dao.UserDAO;
import org.example.demo111.model.User;

import java.util.List;

public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * 用户登录验证
     */
    public User login(String uno, String password) {
        if (uno == null || password == null || uno.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        
        return userDAO.authenticateUser(uno.trim(), password.trim());
    }
    
    /**
     * 根据用户ID获取用户信息
     */
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }
    
    /**
     * 根据用户名获取用户信息
     */
    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        return userDAO.getUserByUsername(username.trim());
    }
    
    /**
     * 根据用户类型获取用户列表
     */
    public List<User> getUsersByType(String userType) {
        return userDAO.getUsersByType(userType);
    }
    
    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    
    /**
     * 更新用户密码
     */
    public boolean updatePassword(int userId, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }
        
        return userDAO.updatePassword(userId, newPassword.trim());
    }
    
    /**
     * 检查用户名是否存在
     */
    public boolean isUsernameExists(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        
        return userDAO.isUsernameExists(username.trim());
    }
    
    /**
     * 创建新用户
     */
    public boolean createUser(User user) {
        if (user == null || user.getUsername() == null || user.getPassword() == null || 
            user.getUserType() == null) {
            return false;
        }
        
        // 检查用户名是否已存在
        if (isUsernameExists(user.getUsername())) {
            return false;
        }
        
        return userDAO.createUser(user);
    }
    
    /**
     * 根据用户ID判断用户类型
     */
    public String getUserTypeById(int userId) {
        if (userId >= 100001 && userId <= 199999) {
            return "admin";
        } else if (userId >= 600001 && userId <= 699999) {
            return "student";
        } else if (userId >= 700001 && userId <= 799999) {
            return "teacher";
        }
        return "unknown";
    }
    
    /**
     * 验证用户权限
     */
    public boolean hasPermission(User user, String requiredType) {
        if (user == null || user.getUserType() == null) {
            return false;
        }
        
        // 管理员拥有所有权限
        if ("admin".equals(user.getUserType())) {
            return true;
        }
        
        // 检查特定权限
        return requiredType.equals(user.getUserType());
    }
    
    /**
     * 初始化用户数据（从现有学生和教师数据创建用户账户）
     */
    public void initializeUsers() {
        // 这个方法将在数据库初始化脚本中调用
        // 为现有的学生和教师创建用户账户
    }
    
    /**
     * 检查触发器状态
     */
    public boolean checkTriggerStatus() {
        try {
            // 检查用户表中是否有数据
            List<User> users = getAllUsers();
            return !users.isEmpty();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 获取用户统计信息
     */
    public String getUserStats() {
        try {
            List<User> allUsers = getAllUsers();
            List<User> students = getUsersByType("student");
            List<User> teachers = getUsersByType("teacher");
            List<User> admins = getUsersByType("admin");
            
            return String.format("总用户数: %d, 学生: %d, 教师: %d, 管理员: %d", 
                allUsers.size(), students.size(), teachers.size(), admins.size());
        } catch (Exception e) {
            return "获取用户统计信息失败: " + e.getMessage();
        }
    }
    
    /**
     * 重置用户密码为默认密码
     */
    public boolean resetUserPassword(String username, String userType) {
        if (username == null || userType == null) {
            return false;
        }
        
        String defaultPassword = "student".equals(userType) ? "Student@123" : "Teacher@123";
        User user = getUserByUsername(username);
        if (user != null) {
            return updatePassword(user.getUserId(), defaultPassword);
        }
        return false;
    }
    
    /**
     * 验证当前密码是否正确
     */
    public boolean verifyCurrentPassword(int userId, String currentPassword) {
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            return false;
        }
        
        User user = getUserById(userId);
        if (user != null) {
            return currentPassword.trim().equals(user.getPassword());
        }
        return false;
    }
    
    /**
     * 修改用户密码（需要验证当前密码）
     */
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        if (currentPassword == null || newPassword == null || 
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty()) {
            return false;
        }
        
        // 验证当前密码
        if (!verifyCurrentPassword(userId, currentPassword.trim())) {
            return false;
        }
        
        // 验证新密码格式（至少6位，包含字母和数字）
        if (!isValidPassword(newPassword.trim())) {
            return false;
        }
        
        return updatePassword(userId, newPassword.trim());
    }
    
    /**
     * 验证密码格式
     */
    public boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // 检查是否包含字母和数字
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        
        return hasLetter && hasDigit;
    }
    
    /**
     * 获取密码强度提示
     */
    public String getPasswordStrengthHint() {
        return "密码至少6位，必须包含字母和数字";
    }
} 