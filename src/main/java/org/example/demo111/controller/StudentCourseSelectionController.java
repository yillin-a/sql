package org.example.demo111.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.User;
import org.example.demo111.service.EnrollmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 学生选课控制器
 */
@WebServlet("/student/select-course")
public class StudentCourseSelectionController extends HttpServlet {
    private final EnrollmentService enrollmentService;
    
    public StudentCourseSelectionController() {
        this.enrollmentService = new EnrollmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 检查用户是否登录
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // 检查是否是学生用户
            if (!"student".equals(user.getUserType())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有学生可以访问选课页面");
                return;
            }
            
            // 获取学生ID (对于学生用户，userId就是学号)
            Integer studentId = user.getUserId();
            
            // 获取可选的教学班
            List<Map<String, Object>> availableClasses = enrollmentService.getAvailableTeachingClasses(studentId);
            
            // 获取已选的教学班
            List<Map<String, Object>> enrolledClasses = enrollmentService.getEnrolledTeachingClasses(studentId);
            
            request.setAttribute("availableClasses", availableClasses);
            request.setAttribute("enrolledClasses", enrolledClasses);
            request.setAttribute("studentId", studentId);
            
            request.getRequestDispatcher("/WEB-INF/views/student/select-course.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 检查用户是否登录
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // 检查是否是学生用户
            if (!"student".equals(user.getUserType())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有学生可以进行选课操作");
                return;
            }
            
            // 获取学生ID (对于学生用户，userId就是学号)
            Integer studentId = user.getUserId();
            
            String action = request.getParameter("action");
            String teachingClassIdStr = request.getParameter("teachingClassId");
            
            if (teachingClassIdStr == null || teachingClassIdStr.trim().isEmpty()) {
                request.setAttribute("error", "请选择教学班");
                doGet(request, response);
                return;
            }
            
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            boolean success = false;
            String message = "";
            
            if ("enroll".equals(action)) {
                // 选课
                success = enrollmentService.selectCourse(studentId, teachingClassId);
                message = success ? "选课成功！" : "选课失败，请重试";
            } else if ("drop".equals(action)) {
                // 退选
                success = enrollmentService.dropCourse(studentId, teachingClassId);
                message = success ? "退选成功！" : "退选失败，请重试";
            } else {
                request.setAttribute("error", "无效的操作");
                doGet(request, response);
                return;
            }
            
            if (success) {
                request.setAttribute("success", message);
            } else {
                request.setAttribute("error", message);
            }
            
            // 重新加载页面数据
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败: " + e.getMessage());
            doGet(request, response);
        }
    }
    

} 