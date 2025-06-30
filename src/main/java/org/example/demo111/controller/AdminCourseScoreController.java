package org.example.demo111.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.example.demo111.service.CourseScoreStatisticsService;
import org.example.demo111.service.CourseService;
import org.example.demo111.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 管理员课程平均成绩控制器
 */
@WebServlet("/admin/course-score/*")
public class AdminCourseScoreController extends HttpServlet {
    private final CourseService courseService;
    private final CourseScoreStatisticsService scoreStatisticsService;
    private final StudentService studentService;
    
    public AdminCourseScoreController() {
        this.courseService = new CourseService();
        this.scoreStatisticsService = new CourseScoreStatisticsService();
        this.studentService = new StudentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
                showDashboard(request, response);
            } else if ("/average-scores".equals(pathInfo)) {
                showAverageScores(request, response);
            } else if ("/teacher-stats".equals(pathInfo)) {
                showTeacherStats(request, response);
            } else if ("/course-ranking".equals(pathInfo)) {
                showCourseRanking(request, response);
            } else if ("/score-distribution".equals(pathInfo)) {
                showScoreDistribution(request, response);
            } else if ("/export".equals(pathInfo)) {
                exportData(request, response);
            } else if ("/update-gpa".equals(pathInfo)) {
                updateStudentGPA(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/update-gpa".equals(pathInfo)) {
                updateStudentGPA(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示管理员课程成绩仪表板
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // 获取总体统计
        Map<String, Object> overallStats = courseService.getCourseAverageScoreOverallStats();
        
        // 获取课程统计
        List<Map<String, Object>> topCourses = courseService.getCourseAverageScoreDetails();
        if (topCourses.size() > 10) {
            topCourses = topCourses.subList(0, 10);
        }
        
        // 获取教师统计
        List<Map<String, Object>> topTeachers = courseService.getCourseAverageScoreByTeacher();
        if (topTeachers.size() > 5) {
            topTeachers = topTeachers.subList(0, 5);
        }
        
        // 获取成绩分布
        Map<String, Object> scoreDistribution = scoreStatisticsService.getCourseScoreDistribution();
        
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("topCourses", topCourses);
        request.setAttribute("topTeachers", topTeachers);
        request.setAttribute("scoreDistribution", scoreDistribution);
        request.getRequestDispatcher("/WEB-INF/views/admin/course-score-dashboard.jsp").forward(request, response);
    }
    
    /**
     * 显示课程平均成绩统计
     */
    private void showAverageScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String courseName = request.getParameter("courseName");
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        
        List<Map<String, Object>> scoreStats;
        
        if (courseName != null && !courseName.trim().isEmpty()) {
            scoreStats = courseService.getCourseAverageScoreByCourseName(courseName.trim());
        } else {
            scoreStats = courseService.getCourseAverageScoreDetails();
        }
        
        // 排序处理
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            final String sortField = sortBy;
            final boolean ascending = "asc".equalsIgnoreCase(order);
            
            scoreStats.sort((a, b) -> {
                Object valA = a.get(sortField);
                Object valB = b.get(sortField);
                
                if (valA == null && valB == null) return 0;
                if (valA == null) return ascending ? -1 : 1;
                if (valB == null) return ascending ? 1 : -1;
                
                if (valA instanceof Number && valB instanceof Number) {
                    double numA = ((Number) valA).doubleValue();
                    double numB = ((Number) valB).doubleValue();
                    return ascending ? Double.compare(numA, numB) : Double.compare(numB, numA);
                }
                
                String strA = valA.toString();
                String strB = valB.toString();
                return ascending ? strA.compareTo(strB) : strB.compareTo(strA);
            });
        }
        
        Map<String, Object> overallStats = courseService.getCourseAverageScoreOverallStats();
        
        request.setAttribute("scoreStats", scoreStats);
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("searchCourseName", courseName);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/WEB-INF/views/admin/course-average-scores.jsp").forward(request, response);
    }
    
    /**
     * 显示教师课程统计
     */
    private void showTeacherStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> teacherStats = courseService.getCourseAverageScoreByTeacher();
        
        request.setAttribute("teacherStats", teacherStats);
        request.getRequestDispatcher("/WEB-INF/views/admin/teacher-course-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示课程统计
     */
    private void showCourseRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> courseStats = scoreStatisticsService.getCourseScoreRankingAsMap();
        
        request.setAttribute("courseStats", courseStats);
        request.getRequestDispatcher("/WEB-INF/views/admin/course-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示成绩分布统计
     */
    private void showScoreDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Map<String, Object> distribution = scoreStatisticsService.getCourseScoreDistribution();
        List<Map<String, Object>> courseStats = courseService.getCourseScoreStats();
        
        request.setAttribute("distribution", distribution);
        request.setAttribute("courseStats", courseStats);
        request.getRequestDispatcher("/WEB-INF/views/admin/score-distribution.jsp").forward(request, response);
    }
    
    /**
     * 导出数据
     */
    private void exportData(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String type = request.getParameter("type");
        
        if ("course-scores".equals(type)) {
            exportCourseScores(request, response);
        } else if ("teacher-stats".equals(type)) {
            exportTeacherStats(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "不支持的导出类型");
        }
    }
    
    /**
     * 导出课程成绩数据
     */
    private void exportCourseScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> scoreStats = courseService.getCourseAverageScoreDetails();
        
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=course_scores.csv");
        
        // 写入CSV头部
        response.getWriter().write("课程名称,课程类型,教学班编号,授课教师,学年,学期,选课人数,平均成绩,最高分,最低分,优秀人数,良好人数,中等人数,及格人数,不及格人数\n");
        
        // 写入数据
        for (Map<String, Object> stat : scoreStats) {
            StringBuilder line = new StringBuilder();
            line.append("\"").append(stat.get("courseName")).append("\",");
            line.append("\"").append(stat.get("courseType")).append("\",");
            line.append(stat.get("teachingClassId")).append(",");
            line.append("\"").append(stat.get("teacherName")).append("\",");
            line.append(stat.get("year")).append(",");
            line.append(stat.get("term")).append(",");
            line.append(stat.get("studentCount")).append(",");
            line.append(stat.get("avgScore")).append(",");
            line.append(stat.get("maxScore")).append(",");
            line.append(stat.get("minScore")).append(",");
            line.append(stat.get("excellentCount")).append(",");
            line.append(stat.get("goodCount")).append(",");
            line.append(stat.get("averageCount")).append(",");
            line.append(stat.get("passCount")).append(",");
            line.append(stat.get("failCount")).append("\n");
            
            response.getWriter().write(line.toString());
        }
    }
    
    /**
     * 导出教师统计数据
     */
    private void exportTeacherStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> teacherStats = courseService.getCourseAverageScoreByTeacher();
        
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=teacher_stats.csv");
        
        // 写入CSV头部
        response.getWriter().write("教师姓名,课程数量,教学班数量,选课总人数,平均成绩,最高分,最低分,优秀人数,良好人数,中等人数,及格人数,不及格人数\n");
        
        // 写入数据
        for (Map<String, Object> stat : teacherStats) {
            StringBuilder line = new StringBuilder();
            line.append("\"").append(stat.get("teacherName")).append("\",");
            line.append(stat.get("courseCount")).append(",");
            line.append(stat.get("teachingClassCount")).append(",");
            line.append(stat.get("totalStudents")).append(",");
            line.append(stat.get("avgScore")).append(",");
            line.append(stat.get("maxScore")).append(",");
            line.append(stat.get("minScore")).append(",");
            line.append(stat.get("excellentCount")).append(",");
            line.append(stat.get("goodCount")).append(",");
            line.append(stat.get("averageCount")).append(",");
            line.append(stat.get("passCount")).append(",");
            line.append(stat.get("failCount")).append("\n");
            
            response.getWriter().write(line.toString());
        }
    }

    /**
     * 更新所有学生的GPA
     */
    private void updateStudentGPA(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 调用服务更新所有学生的GPA
            studentService.updateAllStudentsGPA();
            
            // 设置成功消息
            request.getSession().setAttribute("successMessage", "所有学生的GPA已成功更新！");
            
            // 重定向到仪表板
            response.sendRedirect(request.getContextPath() + "/admin/course-score/dashboard");
            
        } catch (Exception e) {
            // 设置错误消息
            request.getSession().setAttribute("errorMessage", "更新学生GPA失败: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/course-score/dashboard");
        }
    }
} 