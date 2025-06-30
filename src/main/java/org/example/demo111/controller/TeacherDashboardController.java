package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.demo111.model.User;
import org.example.demo111.model.Teacher;
import org.example.demo111.service.TeacherService;
import org.example.demo111.service.EnrollmentService;

import java.io.IOException;
import java.util.List;

@WebServlet("/teacher/dashboard")
public class TeacherDashboardController extends HttpServlet {
    private TeacherService teacherService;
    private EnrollmentService enrollmentService;
    
    @Override
    public void init() throws ServletException {
        teacherService = new TeacherService();
        enrollmentService = new EnrollmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户登录状态和权限
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 获取教师详细信息
            Teacher teacher = teacherService.getTeacherById(user.getUserId());
            if (teacher == null) {
                request.setAttribute("error", "教师信息不存在");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            // 获取教师的教学班信息（这里需要扩展TeacherService）
            // 暂时使用模拟数据
            int totalTeachingClasses = 3; // 模拟数据
            int totalStudents = 150; // 模拟数据
            double averageScore = 82.5; // 模拟数据
            
            // 设置请求属性
            request.setAttribute("teacher", teacher);
            request.setAttribute("totalTeachingClasses", totalTeachingClasses);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("averageScore", averageScore);
            
            // 转发到教师仪表板页面
            request.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取教师信息时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
} 