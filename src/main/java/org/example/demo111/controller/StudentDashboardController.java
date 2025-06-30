package org.example.demo111.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Student;
import org.example.demo111.model.User;
import org.example.demo111.service.CourseService;
import org.example.demo111.service.EnrollmentService;
import org.example.demo111.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/dashboard")
public class StudentDashboardController extends HttpServlet {
    private StudentService studentService;
    private EnrollmentService enrollmentService;
    private CourseService courseService;
    
    @Override
    public void init() throws ServletException {
        studentService = new StudentService();
        enrollmentService = new EnrollmentService();
        courseService = new CourseService();
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
            
            // 获取学生的选课记录
            List<org.example.demo111.model.Enrollment> enrollments = 
                enrollmentService.getStudentScores(user.getUserId());
            
            // 获取当前学期的课表
            List<Map<String, Object>> currentSchedule = 
                enrollmentService.getCurrentTermSchedule(user.getUserId());
            
            // 获取GPA历史趋势
            List<Map<String, Object>> gpaHistory = 
                enrollmentService.getGPAHistory(user.getUserId());
            
            // 获取成绩分布统计
            Map<String, Integer> scoreDistribution = 
                enrollmentService.getScoreDistribution(user.getUserId());
            
            // 获取专业排名信息
            Map<String, Object> rankingInfo = 
                studentService.getStudentRanking(user.getUserId());
            
            // 计算统计信息
            int totalCourses = enrollments.size();
            int completedCourses = 0;
            double totalGPA = 0.0;
            double totalCredits = 0.0;
            int excellentCount = 0; // 优秀(90+)
            int goodCount = 0;      // 良好(80-89)
            int averageCount = 0;   // 中等(70-79)
            int passCount = 0;      // 及格(60-69)
            int failCount = 0;      // 不及格(<60)
            
            for (org.example.demo111.model.Enrollment enrollment : enrollments) {
                if (enrollment.getHylEscore10() != null && enrollment.getHylEscore10() > 0) {
                    completedCourses++;
                    if (enrollment.getHylEgpa10() != null) {
                        totalGPA += enrollment.getHylEgpa10().doubleValue();
                    }
                    
                    // 统计成绩分布
                    int score = enrollment.getHylEscore10();
                    if (score >= 90) excellentCount++;
                    else if (score >= 80) goodCount++;
                    else if (score >= 70) averageCount++;
                    else if (score >= 60) passCount++;
                    else failCount++;
                    
                    // 只有及格的课程才能获得学分
                    if (score >= 60 && enrollment.getCourseCredit() != null) {
                        totalCredits += enrollment.getCourseCredit().doubleValue();
                    }
                }
            }
            
            double averageGPA = completedCourses > 0 ? totalGPA / completedCourses : 0.0;
            
            // 计算学习进度
            double progressPercentage = 0.0;
            if (totalCourses > 0) {
                progressPercentage = (double) completedCourses / totalCourses * 100;
            }
            
            // 设置请求属性
            request.setAttribute("student", student);
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("currentSchedule", currentSchedule);
            request.setAttribute("gpaHistory", gpaHistory);
            request.setAttribute("scoreDistribution", scoreDistribution);
            request.setAttribute("rankingInfo", rankingInfo);
            
            // 统计信息
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("completedCourses", completedCourses);
            request.setAttribute("averageGPA", averageGPA);
            request.setAttribute("totalCredits", totalCredits);
            request.setAttribute("progressPercentage", progressPercentage);
            
            // 成绩分布
            request.setAttribute("excellentCount", excellentCount);
            request.setAttribute("goodCount", goodCount);
            request.setAttribute("averageCount", averageCount);
            request.setAttribute("passCount", passCount);
            request.setAttribute("failCount", failCount);
            
            // 转发到学生仪表板页面
            request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取学生信息时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
} 