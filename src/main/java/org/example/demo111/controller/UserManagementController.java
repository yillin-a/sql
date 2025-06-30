package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.demo111.model.User;
import org.example.demo111.service.UserService;

import java.io.IOException;
import java.util.List;

/**
 * 用户管理控制器
 */
@WebServlet("/admin/users/*")
public class UserManagementController extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查管理员权限
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        switch (pathInfo) {
            case "/":
            case "/list":
                listUsers(request, response);
                break;
            case "/stats":
                showUserStats(request, response);
                break;
            case "/trigger-status":
                checkTriggerStatus(request, response);
                break;
            case "/reset-password":
                resetPassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查管理员权限
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        switch (pathInfo) {
            case "/reset-password":
                resetPassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    /**
     * 列出所有用户
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userType = request.getParameter("type");
        List<User> users;
        
        if (userType != null && !userType.trim().isEmpty()) {
            users = userService.getUsersByType(userType);
        } else {
            users = userService.getAllUsers();
        }
        
        request.setAttribute("users", users);
        request.setAttribute("userType", userType);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-management.jsp").forward(request, response);
    }
    
    /**
     * 显示用户统计信息
     */
    private void showUserStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String stats = userService.getUserStats();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-stats.jsp").forward(request, response);
    }
    
    /**
     * 检查触发器状态
     */
    private void checkTriggerStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        boolean triggerStatus = userService.checkTriggerStatus();
        request.setAttribute("triggerStatus", triggerStatus);
        request.setAttribute("message", triggerStatus ? 
            "触发器工作正常，用户账户自动创建功能已启用" : 
            "触发器可能存在问题，请检查数据库配置");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/trigger-status.jsp").forward(request, response);
    }
    
    /**
     * 重置用户密码
     */
    private void resetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String userType = request.getParameter("userType");
        
        if (username != null && userType != null) {
            boolean success = userService.resetUserPassword(username, userType);
            if (success) {
                request.setAttribute("message", "密码重置成功！默认密码已设置。");
            } else {
                request.setAttribute("error", "密码重置失败，请检查用户名和用户类型。");
            }
        } else {
            request.setAttribute("error", "请提供用户名和用户类型。");
        }
        
        // 重新加载用户列表
        listUsers(request, response);
    }
} 