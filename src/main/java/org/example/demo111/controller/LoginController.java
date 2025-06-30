package org.example.demo111.controller;

import org.example.demo111.model.User;
import org.example.demo111.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            // 处理登出
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 显示登录页面
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String uno = request.getParameter("uno");
        String password = request.getParameter("password");

        // 验证输入
        if (uno == null || password == null || uno.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "用户ID和密码不能为空");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        

        // 验证用户登录
        User user = userService.login(uno.trim(), password.trim());

        System.out.println("uno: " + uno);
        System.out.println("password: " + password);

        if (user == null) {
            request.setAttribute("error", "用户ID或密码错误");
            request.setAttribute("uno", uno);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // 检查用户状态
        if (!"正常".equals(user.getStatus()) && !"在读".equals(user.getStatus()) && !"在职".equals(user.getStatus())) {
            request.setAttribute("error", "账户状态异常，请联系管理员");
            request.setAttribute("uno", uno);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // 登录成功，创建会话
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userType", user.getUserType());
        session.setAttribute("realName", user.getRealName());
        
        // 根据用户类型重定向到相应的首页
        String redirectUrl = getRedirectUrlByUserType(user.getUserType());
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
    
    /**
     * 根据用户类型获取重定向URL
     */
    private String getRedirectUrlByUserType(String userType) {
        switch (userType) {
            case "admin":
                return "/admin/home"; // 管理员首页
            case "student":
                return "/student/dashboard"; // 学生首页
            case "teacher":
                return "/teacher/dashboard"; // 教师首页
            default:
                return "/login";
        }
    }
} 