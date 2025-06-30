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

/**
 * 密码修改控制器
 */
@WebServlet("/password/*")
public class PasswordController extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户是否已登录
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        switch (pathInfo) {
            case "/":
            case "/change":
                showChangePasswordForm(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户是否已登录
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        switch (pathInfo) {
            case "/":
            case "/change":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    /**
     * 显示修改密码表单
     */
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // 根据用户类型选择不同的页面
        String pagePath = "/WEB-INF/views/";
        switch (currentUser.getUserType()) {
            case "admin":
                pagePath += "admin/change-password.jsp";
                break;
            case "student":
                pagePath += "student/change-password.jsp";
                break;
            case "teacher":
                pagePath += "teacher/change-password.jsp";
                break;
            default:
                pagePath += "change-password.jsp";
                break;
        }
        
        request.getRequestDispatcher(pagePath).forward(request, response);
    }
    
    /**
     * 处理密码修改
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 验证输入
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "请填写所有密码字段");
            showChangePasswordForm(request, response);
            return;
        }
        
        // 验证新密码确认
        if (!newPassword.trim().equals(confirmPassword.trim())) {
            request.setAttribute("error", "新密码与确认密码不匹配");
            showChangePasswordForm(request, response);
            return;
        }
        
        // 验证新密码格式
        if (!userService.isValidPassword(newPassword.trim())) {
            request.setAttribute("error", "新密码格式不正确：" + userService.getPasswordStrengthHint());
            showChangePasswordForm(request, response);
            return;
        }
        
        // 修改密码
        boolean success = userService.changePassword(currentUser.getUserId(), currentPassword.trim(), newPassword.trim());
        
        if (success) {
            request.setAttribute("message", "密码修改成功！请使用新密码登录。");
            // 可以选择是否让用户重新登录
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?message=password_changed");
        } else {
            request.setAttribute("error", "当前密码错误或修改失败，请重试");
            showChangePasswordForm(request, response);
        }
    }
} 