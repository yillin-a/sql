package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.demo111.model.User;
import org.example.demo111.model.Student;
import org.example.demo111.service.StudentService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 学生个人信息管理控制器
 */
@WebServlet("/student-score-analysis/*")
public class StudentScoreAnalysisController extends HttpServlet {
    private final StudentService studentService;
    
    public StudentScoreAnalysisController() {
        this.studentService = new StudentService();
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
        if (!"student".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 获取学生详细信息
            Student student = studentService.getStudentById(user.getUserId());
            if (student == null) {
                request.setAttribute("error", "学生信息不存在");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("student", student);
            request.getRequestDispatcher("/WEB-INF/views/student/profile-edit.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取学生信息失败：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户登录状态和权限
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 获取表单参数
            String email = request.getParameter("hylSemail10");
            String phone = request.getParameter("hylSphone10");
            String place = request.getParameter("hylSplace10");
            
            // 验证输入
            if (place == null || place.trim().isEmpty()) {
                request.setAttribute("error", "籍贯不能为空");
                doGet(request, response);
                return;
            }
            
            // 验证邮箱格式（如果填写）
            if (email != null && !email.trim().isEmpty() && !email.contains("@")) {
                request.setAttribute("error", "邮箱格式不正确");
                doGet(request, response);
                return;
            }
            
            // 更新学生信息
            boolean success = studentService.updateStudentProfile(user.getUserId(), 
                    email != null ? email.trim() : null, 
                    phone != null ? phone.trim() : null, 
                    place.trim());
            
            if (success) {
                request.setAttribute("success", "个人信息更新成功！");
            } else {
                request.setAttribute("error", "个人信息更新失败，请重试");
            }
            
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新个人信息时发生错误：" + e.getMessage());
            doGet(request, response);
        }
    }
} 