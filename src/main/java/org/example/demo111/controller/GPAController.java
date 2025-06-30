package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.demo111.model.User;
import org.example.demo111.service.EnrollmentService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * GPA管理控制器
 */
@WebServlet("/gpa/*")
public class GPAController extends HttpServlet {
    private EnrollmentService enrollmentService;
    
    @Override
    public void init() throws ServletException {
        enrollmentService = new EnrollmentService();
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
            case "/dashboard":
                showGPADashboard(request, response);
                break;
            case "/student":
                showStudentGPA(request, response);
                break;
            case "/course":
                showCourseGPA(request, response);
                break;
            case "/batch-update":
                batchUpdateGPA(request, response);
                break;
            case "/distribution":
                showGPADistribution(request, response);
                break;
            case "/ranking":
                showGPARanking(request, response);
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
            case "/update-score":
                updateScoreAndGPA(request, response);
                break;
            case "/batch-update":
                batchUpdateGPA(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    /**
     * 显示GPA管理仪表板
     */
    private void showGPADashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 根据用户类型选择不同的页面
        String pagePath = "/WEB-INF/views/";
        User currentUser = (User) request.getSession().getAttribute("user");
        
        switch (currentUser.getUserType()) {
            case "admin":
                pagePath += "admin/gpa-dashboard.jsp";
                break;
            case "teacher":
                pagePath += "teacher/gpa-dashboard.jsp";
                break;
            case "student":
                pagePath += "student/gpa-dashboard.jsp";
                break;
            default:
                pagePath += "gpa-dashboard.jsp";
                break;
        }
        
        request.getRequestDispatcher(pagePath).forward(request, response);
    }
    
    /**
     * 显示学生GPA信息
     */
    private void showStudentGPA(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentIdStr = request.getParameter("studentId");
        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            request.setAttribute("error", "请提供学生ID");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer studentId = Integer.parseInt(studentIdStr);
            
            // 获取学生GPA信息
            BigDecimal totalGPA = enrollmentService.getStudentTotalGPA(studentId);
            BigDecimal weightedGPA = enrollmentService.getStudentWeightedGPA(studentId);
            Integer gpaRank = enrollmentService.getStudentGPARank(studentId);
            String gpaGrade = enrollmentService.getStudentGPAGrade(studentId);
            List<Map<String, Object>> gpaHistory = enrollmentService.getStudentGPAHistory(studentId);
            
            request.setAttribute("studentId", studentId);
            request.setAttribute("totalGPA", totalGPA);
            request.setAttribute("weightedGPA", weightedGPA);
            request.setAttribute("gpaRank", gpaRank);
            request.setAttribute("gpaGrade", gpaGrade);
            request.setAttribute("gpaHistory", gpaHistory);
            
            request.getRequestDispatcher("/WEB-INF/views/student/gpa-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "学生ID格式不正确");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示课程GPA信息
     */
    private void showCourseGPA(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if (teachingClassIdStr == null || teachingClassIdStr.trim().isEmpty()) {
            request.setAttribute("error", "请提供教学班ID");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            // 获取课程GPA信息
            BigDecimal averageGPA = enrollmentService.getCourseAverageGPA(teachingClassId);
            Map<String, Integer> gpaDistribution = enrollmentService.getGPADistribution(teachingClassId);
            
            request.setAttribute("teachingClassId", teachingClassId);
            request.setAttribute("averageGPA", averageGPA);
            request.setAttribute("gpaDistribution", gpaDistribution);
            
            request.getRequestDispatcher("/WEB-INF/views/course/gpa-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "教学班ID格式不正确");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新成绩和GPA
     */
    private void updateScoreAndGPA(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentIdStr = request.getParameter("studentId");
        String teachingClassIdStr = request.getParameter("teachingClassId");
        String scoreStr = request.getParameter("score");
        
        if (studentIdStr == null || teachingClassIdStr == null || scoreStr == null) {
            request.setAttribute("error", "请提供完整的参数");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer studentId = Integer.parseInt(studentIdStr);
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            Integer score = Integer.parseInt(scoreStr);
            
            if (score < 0 || score > 100) {
                request.setAttribute("error", "成绩必须在0-100之间");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            boolean success = enrollmentService.updateScoreAndGPA(studentId, teachingClassId, score);
            
            if (success) {
                request.setAttribute("message", "成绩和GPA更新成功");
            } else {
                request.setAttribute("error", "成绩和GPA更新失败");
            }
            
            // 重定向回成绩管理页面
            response.sendRedirect(request.getContextPath() + "/enrollment/list?message=" + 
                                (success ? "update_success" : "update_failed"));
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "参数格式不正确");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 批量更新GPA
     */
    private void batchUpdateGPA(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查是否为管理员
        User currentUser = (User) request.getSession().getAttribute("user");
        if (!"admin".equals(currentUser.getUserType())) {
            request.setAttribute("error", "只有管理员可以执行此操作");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        
        boolean success = enrollmentService.batchUpdateAllGPA();
        
        if (success) {
            request.setAttribute("message", "批量更新GPA成功");
        } else {
            request.setAttribute("error", "批量更新GPA失败");
        }
        
        // 重定向回GPA管理页面
        response.sendRedirect(request.getContextPath() + "/gpa/dashboard?message=" + 
                            (success ? "batch_update_success" : "batch_update_failed"));
    }
    
    /**
     * 显示GPA分布
     */
    private void showGPADistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if (teachingClassIdStr == null || teachingClassIdStr.trim().isEmpty()) {
            request.setAttribute("error", "请提供教学班ID");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            Map<String, Integer> distribution = enrollmentService.getGPADistribution(teachingClassId);
            
            request.setAttribute("teachingClassId", teachingClassId);
            request.setAttribute("distribution", distribution);
            
            request.getRequestDispatcher("/WEB-INF/views/gpa/distribution.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "教学班ID格式不正确");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示GPA排名
     */
    private void showGPARanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 这里可以实现GPA排名功能
        request.getRequestDispatcher("/WEB-INF/views/gpa/ranking.jsp").forward(request, response);
    }
} 