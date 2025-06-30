package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo111.model.Course;
import org.example.demo111.service.CourseService;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 课程管理控制器
 */
@WebServlet("/course/*")
public class CourseController extends HttpServlet {
    private final CourseService courseService;
    
    public CourseController() {
        this.courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listCourses(request, response);
            } else if ("/view".equals(pathInfo)) {
                viewCourse(request, response);
            } else if ("/edit".equals(pathInfo)) {
                editCourse(request, response);
            } else if ("/search".equals(pathInfo)) {
                searchCourses(request, response);
            } else if ("/stats".equals(pathInfo)) {
                showCourseStats(request, response);
            } else if ("/score-stats".equals(pathInfo)) {
                showCourseScoreStats(request, response);
            } else if ("/average-scores".equals(pathInfo)) {
                showCourseAverageScores(request, response);
            } else if ("/teacher-stats".equals(pathInfo)) {
                showTeacherCourseStats(request, response);
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
            if ("/add".equals(pathInfo)) {
                addCourse(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateCourse(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteCourse(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出所有课程
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Course> courses = courseService.getAllCourses();
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/WEB-INF/views/course/list.jsp").forward(request, response);
    }
    
    /**
     * 查看课程详情
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "课程不存在");
            return;
        }
        
        request.setAttribute("course", course);
        request.getRequestDispatcher("/WEB-INF/views/course/view.jsp").forward(request, response);
    }
    
    /**
     * 编辑课程信息
     */
    private void editCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "课程不存在");
            return;
        }
        
        request.setAttribute("course", course);
        request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
    }
    
    /**
     * 搜索课程
     */
    private void searchCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        
        List<Course> courses;
        
        if (name != null && !name.trim().isEmpty()) {
            courses = courseService.searchCoursesByName(name);
        } else if (type != null && !type.trim().isEmpty()) {
            courses = courseService.getCoursesByType(type);
        } else {
            courses = courseService.getAllCourses();
        }
        
        request.setAttribute("courses", courses);
        request.setAttribute("searchName", name);
        request.setAttribute("searchType", type);
        request.getRequestDispatcher("/WEB-INF/views/course/list.jsp").forward(request, response);
    }
    
    /**
     * 显示课程统计信息
     */
    private void showCourseStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Map<String, Object> stats = courseService.getCourseStats();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/course/stats.jsp").forward(request, response);
    }
    
    /**
     * 显示课程成绩统计
     */
    private void showCourseScoreStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> scoreStats = courseService.getCourseScoreStats();
        request.setAttribute("scoreStats", scoreStats);
        request.getRequestDispatcher("/WEB-INF/views/course/score-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示课程平均成绩统计
     */
    private void showCourseAverageScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String courseName = request.getParameter("courseName");
        List<Map<String, Object>> scoreStats;
        
        if (courseName != null && !courseName.trim().isEmpty()) {
            // 如果有搜索参数，按课程名称搜索
            scoreStats = courseService.getCourseAverageScoreByCourseName(courseName.trim());
        } else {
            // 否则获取所有课程的平均成绩
            scoreStats = courseService.getCourseAverageScoreDetails();
        }
        
        Map<String, Object> overallStats = courseService.getCourseAverageScoreOverallStats();
        
        request.setAttribute("scoreStats", scoreStats);
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("searchCourseName", courseName); // 保存搜索关键词用于回显
        request.getRequestDispatcher("/WEB-INF/views/course/average-scores.jsp").forward(request, response);
    }
    
    /**
     * 显示教师课程统计
     */
    private void showTeacherCourseStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> teacherStats = courseService.getCourseAverageScoreByTeacher();
        request.setAttribute("teacherStats", teacherStats);
        request.getRequestDispatcher("/WEB-INF/views/course/teacher-stats.jsp").forward(request, response);
    }
    
    /**
     * 添加课程
     */
    private void addCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Course course = parseCourseFromRequest(request);
        
        try {
            boolean success = courseService.addCourse(course);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/course/list?message=添加成功");
            } else {
                request.setAttribute("error", "添加课程失败");
                request.getRequestDispatcher("/WEB-INF/views/course/add.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("course", course);
            request.getRequestDispatcher("/WEB-INF/views/course/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新课程
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Course course = parseCourseFromRequest(request);
        
        try {
            boolean success = courseService.updateCourse(course);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/course/list?message=更新成功");
            } else {
                request.setAttribute("error", "更新课程失败，请重试");
                request.setAttribute("course", course);
                request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("course", course);
            request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除课程
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        
        try {
            boolean success = courseService.deleteCourse(courseId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/course/list?message=删除成功");
            } else {
                response.sendRedirect(request.getContextPath() + "/course/list?error=删除失败");
            }
        } catch (IllegalStateException e) {
            response.sendRedirect(request.getContextPath() + "/course/list?error=" + e.getMessage());
        }
    }
    
    /**
     * 从请求参数解析课程对象
     */
    private Course parseCourseFromRequest(HttpServletRequest request) {
        String courseIdStr = request.getParameter("hylCno10");
        Course course = new Course();
        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            course.setHylCno10(Integer.parseInt(courseIdStr));
        }

        course.setHylCname10(request.getParameter("hylCname10"));
        
        String creditStr = request.getParameter("hylCcredit10");
        if (creditStr != null && !creditStr.isEmpty()) {
            course.setHylCcredit10(new BigDecimal(creditStr));
        }
        
        String hourStr = request.getParameter("hylChour10");
        if (hourStr != null && !hourStr.isEmpty()) {
            course.setHylChour10(Integer.parseInt(hourStr));
        }
        
        course.setHylCtest10(request.getParameter("hylCtest10"));
        course.setHylCtype10(request.getParameter("hylCtype10"));
        course.setHylCprereq10(request.getParameter("hylCprereq10"));
        course.setHylCdesc10(request.getParameter("hylCdesc10"));
        
        return course;
    }
} 